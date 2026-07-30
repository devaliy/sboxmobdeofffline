import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/progress_db.dart';
import '../../../core/sync/outbox_payloads.dart';
import '../../auth/application/auth_controller.dart';

const _uuid = Uuid();

/// Writes `reading_progress` locally first, then enqueues it for sync
/// (spec Section 8) — never blocks the reader UI on network. Progress is
/// monotonic: scrolling back up never *reduces* the recorded percentage,
/// since the student has still "seen" that much of the subject.
class ReadingProgressController {
  ReadingProgressController(this._ref);
  final Ref _ref;

  Future<void> recordProgress({
    required int librarySubjectId,
    required int percentComplete,
    String? lastPosition,
  }) async {
    final db = _ref.read(currentProgressDbProvider);
    if (db == null) return;

    final clamped = percentComplete.clamp(0, 100);
    final existing = await db.watchReadingProgress(librarySubjectId).first;
    if (existing != null && existing.percentComplete >= clamped) return;

    final id = existing?.id ?? _uuid.v4();
    final nowIso = DateTime.now().toUtc().toIso8601String();

    await db.into(db.readingProgress).insertOnConflictUpdate(ReadingProgressCompanion(
          id: Value(id),
          librarySubjectId: Value(librarySubjectId),
          percentComplete: Value(clamped),
          lastPosition: Value(lastPosition),
          lastOpenedAt: Value(nowIso),
          syncedAt: const Value(null),
        ));

    await db.enqueueOutbox(SyncOutboxCompanion.insert(
      id: _uuid.v4(),
      entityType: 'reading_progress',
      entityId: id,
      payloadJson: jsonEncode(readingProgressPayload(
        librarySubjectId: librarySubjectId,
        percentComplete: clamped,
        lastPosition: lastPosition,
        lastOpenedAt: nowIso,
      )),
      createdAt: nowIso,
    ));
    await db.recordActivity(); // reading counts toward the daily streak, not points
  }
}

final readingProgressControllerProvider =
    Provider<ReadingProgressController>((ref) => ReadingProgressController(ref));
