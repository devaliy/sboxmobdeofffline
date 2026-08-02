import 'package:drift/drift.dart' show Value;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/progress_db.dart';
import '../../../core/network/endpoints.dart';
import '../../auth/application/auth_controller.dart';
import '../domain/ai_conversation.dart';
import '../domain/ai_message.dart';

/// Read-through cache combinator (SUCCESSAI_BUILD_PROMPT.md Section 3):
/// every method tries the network first and upserts the result into the
/// account's cache tables on success; any failure (offline, timeout, 5xx)
/// falls back to whatever's cached. There is no outbox here — sending a
/// message always requires a live call, per spec.
class AiChatRepository {
  AiChatRepository(this._endpoints, this._db);
  final AiChatEndpoints _endpoints;
  final ProgressDb _db;

  /// Network-only — throws [DioException] on any failure (offline, 503,
  /// timeout) so the caller (the provider layer) can distinguish "server
  /// says unavailable" from "no connectivity" and pick the right empty
  /// state, rather than this method silently swallowing the difference.
  Future<List<AiConversation>> fetchConversationsFromNetwork() async {
    final raw = await _endpoints.listConversations();
    final conversations = [for (final json in raw) AiConversation.fromJson(json)];
    await _db.upsertCachedConversations([
      for (final c in conversations)
        AiConversationsCacheCompanion.insert(
          id: c.id,
          title: c.title,
          updatedAt: c.updatedAt.toIso8601String(),
          lastMessage: Value(c.lastMessage),
          cachedAt: DateTime.now().toUtc().toIso8601String(),
        ),
    ]);
    return conversations;
  }

  Future<List<AiConversation>> cachedConversations() async {
    final rows = await _db.watchCachedConversations().first;
    return [
      for (final row in rows)
        AiConversation(
          id: row.id,
          title: row.title,
          updatedAt: DateTime.parse(row.updatedAt),
          lastMessage: row.lastMessage,
        ),
    ];
  }

  Future<List<AiMessage>> fetchMessages(String conversationId) async {
    try {
      final raw = await _endpoints.listMessages(conversationId);
      final messages = [
        for (final json in raw) AiMessage.fromJson(json, conversationId: conversationId),
      ];
      await _cacheMessages(messages);
      return messages;
    } on DioException {
      return _cachedMessages(conversationId);
    }
  }

  Future<void> _cacheMessages(List<AiMessage> messages) async {
    await _db.upsertCachedMessages([
      for (final m in messages)
        AiMessagesCacheCompanion.insert(
          id: m.id,
          conversationId: m.conversationId,
          content: m.content,
          isAi: m.isAi,
          sender: m.sender,
          createdAt: m.createdAt.toIso8601String(),
          cachedAt: DateTime.now().toUtc().toIso8601String(),
        ),
    ]);
  }

  Future<List<AiMessage>> _cachedMessages(String conversationId) async {
    final rows = await _db.watchCachedMessages(conversationId).first;
    return [
      for (final row in rows)
        AiMessage(
          id: row.id,
          conversationId: row.conversationId,
          content: row.content,
          isAi: row.isAi,
          sender: row.sender,
          createdAt: DateTime.parse(row.createdAt),
        ),
    ];
  }

  /// Always a live call — no offline queue for this one (an AI reply can't
  /// be produced offline and queued for later). Response shape isn't
  /// pinned down in the doc beyond "contains both the saved user message
  /// and the AI's reply", so this parses defensively and falls back to
  /// re-fetching the conversation's authoritative message list from
  /// [fetchMessages] when the envelope doesn't match what's expected.
  Future<AiSendResult> sendMessage({required String text, String? conversationId}) async {
    final res = await _endpoints.sendMessage(message: text, conversationId: conversationId);

    final newConversationId = (res['conversation_id'] ??
            (res['conversation'] is Map ? (res['conversation'] as Map)['id'] : null) ??
            conversationId)
        ?.toString();
    if (newConversationId == null) {
      throw StateError('SuccessAI reply did not include a conversation id.');
    }

    final messages = _parseSendMessages(res, newConversationId);
    if (messages.isNotEmpty) {
      await _cacheMessages(messages);
      return AiSendResult(conversationId: newConversationId, messages: messages);
    }

    // Envelope didn't match any expected shape — fall back to the
    // already-verified list endpoint for authoritative state.
    final refetched = await fetchMessages(newConversationId);
    return AiSendResult(conversationId: newConversationId, messages: refetched);
  }

  List<AiMessage> _parseSendMessages(Map<String, dynamic> res, String conversationId) {
    if (res['messages'] is List) {
      return [
        for (final json in res['messages'] as List)
          AiMessage.fromJson(json as Map<String, dynamic>, conversationId: conversationId),
      ];
    }
    final messages = <AiMessage>[];
    if (res['user_message'] is Map) {
      messages.add(AiMessage.fromJson(res['user_message'] as Map<String, dynamic>, conversationId: conversationId));
    }
    if (res['ai_message'] is Map) {
      messages.add(AiMessage.fromJson(res['ai_message'] as Map<String, dynamic>, conversationId: conversationId));
    } else if (res['reply'] is Map) {
      messages.add(AiMessage.fromJson(res['reply'] as Map<String, dynamic>, conversationId: conversationId));
    }
    return messages;
  }
}

class AiSendResult {
  const AiSendResult({required this.conversationId, required this.messages});
  final String conversationId;
  final List<AiMessage> messages;
}

/// Null when signed out — callers treat that the same as "nothing to show
/// yet" (matches every other `currentProgressDbProvider`-dependent
/// provider in the app).
final aiChatRepositoryProvider = Provider<AiChatRepository?>((ref) {
  final db = ref.watch(currentProgressDbProvider);
  if (db == null) return null;
  return AiChatRepository(ref.watch(aiChatEndpointsProvider), db);
});
