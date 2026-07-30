import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/application/auth_controller.dart';
import '../db/progress_db.dart';
import '../network/api_client.dart';
import '../network/endpoints.dart';

/// Flushes the signed-in account's `sync_outbox` against the server (spec
/// Section 8): batches pending rows by entity type, POSTs them, and marks
/// each row per the server's per-item ack — never blocks the UI, and
/// never touches another account's outbox, since it only ever reads
/// [currentProgressDbProvider] (a physically separate file per account).
class SyncWorker {
  SyncWorker(this._ref);
  final Ref _ref;

  Future<void> flush() async {
    final db = _ref.read(currentProgressDbProvider);
    if (db == null) return;
    // A session that needs re-auth would just 401 on every request — spec
    // Section 8: sync fails silently, it never forces a re-login.
    if (_ref.read(needsReauthProvider)) return;

    final due = (await db.pendingOutbox()).where(_isDue).toList();
    if (due.isEmpty) return;

    final attemptRows = due.where((r) => r.entityType == 'practice_attempt').toList();
    final progressRows = due.where((r) => r.entityType == 'reading_progress').toList();

    if (attemptRows.isNotEmpty) {
      await _flushBatch(
        db: db,
        rows: attemptRows,
        ackKeyOf: (row) => row.entityId,
        send: (payloads) => _ref.read(syncEndpointsProvider).practiceAttempts(payloads),
      );
    }
    if (progressRows.isNotEmpty) {
      await _flushBatch(
        db: db,
        rows: progressRows,
        // reading_progress acks are keyed by library_subject_id, not the
        // row's own id (spec Section 4.6) — read it back out of the
        // payload rather than the outbox row itself.
        ackKeyOf: (row) =>
            '${(jsonDecode(row.payloadJson) as Map<String, dynamic>)['library_subject_id']}',
        send: (payloads) => _ref.read(syncEndpointsProvider).readingProgress(payloads),
      );
    }
  }

  /// Exponential backoff (15s, 30s, 60s, ... capped at ~64min) keyed off
  /// `attempt_count`/`last_attempted_at` — never hammers a struggling
  /// connection, never gives up either.
  bool _isDue(SyncOutboxData row) {
    if (row.attemptCount == 0 || row.lastAttemptedAt == null) return true;
    final exponent = row.attemptCount - 1 < 8 ? row.attemptCount - 1 : 8;
    final backoff = Duration(seconds: 15 * (1 << exponent));
    return DateTime.now().toUtc().isAfter(DateTime.parse(row.lastAttemptedAt!).add(backoff));
  }

  Future<void> _flushBatch({
    required ProgressDb db,
    required List<SyncOutboxData> rows,
    required String Function(SyncOutboxData row) ackKeyOf,
    required Future<Map<String, dynamic>> Function(List<Map<String, dynamic>> payloads) send,
  }) async {
    final payloads = [for (final row in rows) jsonDecode(row.payloadJson) as Map<String, dynamic>];
    try {
      final response = await send(payloads);
      final results = (response['results'] as List).cast<Map<String, dynamic>>();
      final syncedKeys = results.where((r) => r['status'] == 'synced').map((r) => '${r['id']}').toSet();

      for (final row in rows) {
        if (syncedKeys.contains(ackKeyOf(row))) {
          await db.markOutboxRowSynced(row);
        } else {
          await db.markOutboxAttempt(row.id);
        }
      }
    } catch (_) {
      // Offline, timeout, or a server error — every row in this batch
      // stays pending; just bump its retry bookkeeping for backoff.
      for (final row in rows) {
        await db.markOutboxAttempt(row.id);
      }
    }
  }
}

final syncWorkerProvider = Provider<SyncWorker>((ref) => SyncWorker(ref));
