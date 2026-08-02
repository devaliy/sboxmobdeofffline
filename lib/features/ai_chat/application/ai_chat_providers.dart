import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sync/sync_triggers.dart';
import '../data/ai_chat_repository.dart';
import '../domain/ai_conversation.dart';
import '../domain/ai_message.dart';

/// True when the device has any connectivity — the same signal
/// `syncTriggersProvider` already uses, reused here rather than a second
/// SuccessAI-specific connectivity check (SUCCESSAI_BUILD_PROMPT.md
/// Section 2: "show the same offline treatment as elsewhere in the app").
final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityStreamProvider).valueOrNull;
  return connectivity?.any((r) => r != ConnectivityResult.none) ?? false;
});

/// Three genuinely different situations the conversation list can be in
/// (SUCCESSAI_BUILD_PROMPT.md Section 4): a real empty account, offline
/// with nothing cached yet, and the server reporting SuccessAI itself is
/// unavailable — each needs its own message, not one generic placeholder.
class AiConversationsState {
  const AiConversationsState({
    required this.conversations,
    this.isOfflineCache = false,
    this.unavailable = false,
  });

  final List<AiConversation> conversations;
  final bool isOfflineCache;
  final bool unavailable;
}

/// Reacts to connectivity changes so coming back online automatically
/// retries the network fetch.
final aiConversationsProvider = FutureProvider.autoDispose<AiConversationsState>((ref) async {
  final repo = ref.watch(aiChatRepositoryProvider);
  if (repo == null) return const AiConversationsState(conversations: []);

  if (!ref.watch(isOnlineProvider)) {
    return AiConversationsState(conversations: await repo.cachedConversations(), isOfflineCache: true);
  }
  try {
    return AiConversationsState(conversations: await repo.fetchConversationsFromNetwork());
  } on DioException catch (e) {
    if (e.response?.statusCode == 503) {
      return const AiConversationsState(conversations: [], unavailable: true);
    }
    return AiConversationsState(conversations: await repo.cachedConversations(), isOfflineCache: true);
  }
});

class AiChatState {
  const AiChatState({
    required this.messages,
    required this.conversationId,
    this.sending = false,
    this.isOfflineCache = false,
    this.unavailable = false,
    this.error,
  });

  final List<AiMessage> messages;
  /// Null until the first message is sent for a brand-new chat — once the
  /// server assigns one, every subsequent send in this same controller
  /// instance reuses it.
  final String? conversationId;
  final bool sending;
  /// True when [messages] came from the local cache because the network
  /// call failed — drives the "offline — showing saved messages" banner.
  final bool isOfflineCache;
  /// 503: SuccessAI is disabled/misconfigured server-side — distinct from
  /// a connectivity problem, shown as its own message rather than a retry.
  final bool unavailable;
  /// Set on a 502 (the student's message was saved, the AI reply failed)
  /// or on "no connectivity while trying to send" — surfaced with a retry
  /// action that reuses [conversationId], never starts a new thread.
  final String? error;

  AiChatState copyWith({
    List<AiMessage>? messages,
    String? conversationId,
    bool? sending,
    bool? isOfflineCache,
    bool? unavailable,
    String? error,
    bool clearError = false,
  }) =>
      AiChatState(
        messages: messages ?? this.messages,
        conversationId: conversationId ?? this.conversationId,
        sending: sending ?? this.sending,
        isOfflineCache: isOfflineCache ?? this.isOfflineCache,
        unavailable: unavailable ?? this.unavailable,
        error: clearError ? null : (error ?? this.error),
      );
}

class AiChatController extends AutoDisposeFamilyAsyncNotifier<AiChatState, String?> {
  String? _lastFailedText;

  @override
  Future<AiChatState> build(String? conversationId) async {
    if (conversationId == null) {
      return const AiChatState(messages: [], conversationId: null);
    }
    final repo = ref.watch(aiChatRepositoryProvider);
    if (repo == null) return const AiChatState(messages: [], conversationId: null);

    final online = ref.watch(isOnlineProvider);
    if (!online) {
      final cached = await repo.fetchMessages(conversationId); // repository itself falls back to cache
      return AiChatState(messages: cached, conversationId: conversationId, isOfflineCache: true);
    }
    final messages = await repo.fetchMessages(conversationId);
    return AiChatState(messages: messages, conversationId: conversationId);
  }

  Future<void> send(String text) async {
    final repo = ref.read(aiChatRepositoryProvider);
    if (repo == null) return;
    final current = state.valueOrNull ?? const AiChatState(messages: [], conversationId: null);

    if (!ref.read(isOnlineProvider)) {
      state = AsyncData(current.copyWith(error: 'no_connection', clearError: false));
      return;
    }

    _lastFailedText = text;
    state = AsyncData(current.copyWith(sending: true, clearError: true));

    try {
      final result = await repo.sendMessage(text: text, conversationId: current.conversationId);
      _lastFailedText = null;
      state = AsyncData(AiChatState(
        messages: [...current.messages, ...result.messages],
        conversationId: result.conversationId,
        sending: false,
      ));
      // The conversation list screen (if still mounted underneath this
      // one — `push` doesn't unmount what's below it) would otherwise
      // keep showing whatever it fetched before this thread existed or
      // before its preview/timestamp changed.
      ref.invalidate(aiConversationsProvider);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 503) {
        state = AsyncData(current.copyWith(sending: false, unavailable: true));
      } else if (status == 502) {
        // The student's message was saved server-side even though the
        // reply failed — refetch so it shows up, then offer retry (same
        // conversation id, never a new thread).
        final convId = current.conversationId;
        List<AiMessage> refreshed = current.messages;
        if (convId != null) {
          refreshed = await repo.fetchMessages(convId);
        }
        state = AsyncData(AiChatState(
          messages: refreshed,
          conversationId: convId,
          sending: false,
          error: 'SuccessAI couldn\'t reply just now. Your message was saved — try again?',
        ));
      } else {
        state = AsyncData(current.copyWith(sending: false, error: 'no_connection'));
      }
    }
  }

  Future<void> retry() async {
    final text = _lastFailedText;
    if (text == null) return;
    await send(text);
  }
}

final aiChatControllerProvider =
    AsyncNotifierProvider.autoDispose.family<AiChatController, AiChatState, String?>(
  AiChatController.new,
);
