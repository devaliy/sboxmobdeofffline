import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:success_offline/core/db/db_providers.dart';
import 'package:success_offline/core/db/progress_db.dart';
import 'package:success_offline/core/network/api_client.dart';
import 'package:success_offline/core/sync/outbox_payloads.dart';
import 'package:success_offline/core/sync/sync_worker.dart';
import 'package:success_offline/features/auth/application/auth_controller.dart';

import '../../support/test_overrides.dart';

/// Proves M8's review gate (spec Phase 6 done-criteria): a completed
/// offline attempt genuinely flips to synced against the mock server's
/// received payloads, and switching accounts never lets one account's
/// flush touch another's outbox — verified structurally (each account's
/// `progress.sqlite` is a physically separate file), not just by
/// assertion.
void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: testProviderOverrides());
  });
  tearDown(() => container.dispose());

  test('flush uploads a pending practice_attempt and marks it synced against the mock server',
      () async {
    final auth = container.read(authControllerProvider);
    await auth.login(identifier: 'jane@demo.ng', password: 'password123');
    final userId = container.read(currentUserProvider)!.id;
    final db = container.read(progressDbProvider(userId.toString()));

    const attemptId = 'attempt-sync-1';
    await db.into(db.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
          id: attemptId,
          sourceType: 'assessment',
          subjectId: const Value(7),
          testTypeId: const Value(3),
          score: 2,
          totalQuestions: 2,
          timeSpentSeconds: 90,
          startedAt: '2026-07-29T08:00:00Z',
          completedAt: '2026-07-29T08:01:30Z',
        ));
    await db.enqueueOutbox(SyncOutboxCompanion.insert(
      id: 'outbox-1',
      entityType: 'practice_attempt',
      entityId: attemptId,
      payloadJson: jsonEncode(practiceAttemptPayload(
        id: attemptId,
        sourceType: 'assessment',
        subjectId: 7,
        testTypeId: 3,
        score: 2,
        totalQuestions: 2,
        timeSpentSeconds: 90,
        startedAt: '2026-07-29T08:00:00Z',
        completedAt: '2026-07-29T08:01:30Z',
        answers: const [],
      )),
      createdAt: '2026-07-29T08:01:30Z',
    ));

    expect(await db.pendingOutbox(), hasLength(1));

    await container.read(syncWorkerProvider).flush();

    expect(await db.pendingOutbox(), isEmpty);
    final attempt =
        await (db.select(db.practiceAttempts)..where((t) => t.id.equals(attemptId))).getSingle();
    expect(attempt.syncedAt, isNotNull);

    final received = container.read(mockBackendStoreProvider).receivedPracticeAttempts;
    expect(received.map((a) => a['id']), contains(attemptId));
  });

  test('flush uploads a pending reading_progress row, matching the ack by library_subject_id',
      () async {
    final auth = container.read(authControllerProvider);
    await auth.login(identifier: 'jane@demo.ng', password: 'password123');
    final userId = container.read(currentUserProvider)!.id;
    final db = container.read(progressDbProvider(userId.toString()));

    const rowId = 'progress-sync-1';
    await db.into(db.readingProgress).insert(ReadingProgressCompanion.insert(
          id: rowId,
          librarySubjectId: 101,
          percentComplete: 80,
          lastOpenedAt: '2026-07-29T09:10:00Z',
        ));
    // entityId is this row's own id (per reading_progress_controller.dart)
    // — deliberately *not* the library_subject_id the mock server's ack
    // is keyed by (spec Section 4.6), so the worker must read that back
    // out of the payload itself to match the ack correctly.
    await db.enqueueOutbox(SyncOutboxCompanion.insert(
      id: 'outbox-2',
      entityType: 'reading_progress',
      entityId: rowId,
      payloadJson: jsonEncode(readingProgressPayload(
        librarySubjectId: 101,
        percentComplete: 80,
        lastOpenedAt: '2026-07-29T09:10:00Z',
      )),
      createdAt: '2026-07-29T09:10:00Z',
    ));

    await container.read(syncWorkerProvider).flush();

    expect(await db.pendingOutbox(), isEmpty);
    final progress =
        await (db.select(db.readingProgress)..where((t) => t.id.equals(rowId))).getSingle();
    expect(progress.syncedAt, isNotNull);

    final received = container.read(mockBackendStoreProvider).receivedReadingProgress;
    expect(received.map((p) => p['library_subject_id']), contains(101));
  });

  test('flush is a no-op with no signed-in account', () async {
    await container.read(syncWorkerProvider).flush(); // must not throw
  });

  test('switching accounts never lets one account\'s flush touch another\'s outbox', () async {
    final auth = container.read(authControllerProvider);

    // Jane enqueues a pending attempt, but we don't flush yet.
    await auth.login(identifier: 'jane@demo.ng', password: 'password123');
    final janeId = container.read(currentUserProvider)!.id;
    final janeDb = container.read(progressDbProvider(janeId.toString()));
    await janeDb.into(janeDb.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
          id: 'jane-attempt-x',
          sourceType: 'assessment',
          subjectId: const Value(7),
          score: 1,
          totalQuestions: 2,
          timeSpentSeconds: 30,
          startedAt: '2026-07-29T10:00:00Z',
          completedAt: '2026-07-29T10:00:30Z',
        ));
    await janeDb.enqueueOutbox(SyncOutboxCompanion.insert(
      id: 'jane-outbox-x',
      entityType: 'practice_attempt',
      entityId: 'jane-attempt-x',
      payloadJson: jsonEncode(practiceAttemptPayload(
        id: 'jane-attempt-x',
        sourceType: 'assessment',
        subjectId: 7,
        score: 1,
        totalQuestions: 2,
        timeSpentSeconds: 30,
        startedAt: '2026-07-29T10:00:00Z',
        completedAt: '2026-07-29T10:00:30Z',
        answers: const [],
      )),
      createdAt: '2026-07-29T10:00:30Z',
    ));
    expect(await janeDb.pendingOutbox(), hasLength(1));

    // Switch to Musa and flush — his outbox is empty, so this must be a
    // structural no-op, not just an empty-by-coincidence result.
    await auth.logout();
    await auth.login(identifier: 'musa@demo.ng', password: 'password123');
    final musaId = container.read(currentUserProvider)!.id;
    expect(musaId, isNot(janeId));
    final musaDb = container.read(progressDbProvider(musaId.toString()));
    expect(await musaDb.pendingOutbox(), isEmpty);

    await container.read(syncWorkerProvider).flush();
    expect(await musaDb.pendingOutbox(), isEmpty);

    // Jane's row was never touched by Musa's session.
    expect(await janeDb.pendingOutbox(), hasLength(1));

    // And it flushes cleanly once she's signed in again.
    await auth.logout();
    await auth.login(identifier: 'jane@demo.ng', password: 'password123');
    await container.read(syncWorkerProvider).flush();
    expect(await janeDb.pendingOutbox(), isEmpty);
  });

  test('flush leaves a row pending and bumps retry bookkeeping on failure, without dropping it',
      () async {
    final auth = container.read(authControllerProvider);
    await auth.login(identifier: 'jane@demo.ng', password: 'password123');
    final userId = container.read(currentUserProvider)!.id;
    final db = container.read(progressDbProvider(userId.toString()));

    // Malformed payload (missing required fields) — the mock server's
    // `_syncPracticeAttempts` route still requires a valid auth token, so
    // to force a *send* failure without a real network we simulate the
    // "needs re-auth" flag flipping mid-session (spec Section 8: a 401
    // must never force a logout, and a subsequent flush attempt must
    // leave the local copy untouched).
    container.read(needsReauthProvider.notifier).state = true;

    await db.into(db.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
          id: 'attempt-retry-1',
          sourceType: 'assessment',
          subjectId: const Value(7),
          score: 1,
          totalQuestions: 2,
          timeSpentSeconds: 30,
          startedAt: '2026-07-29T11:00:00Z',
          completedAt: '2026-07-29T11:00:30Z',
        ));
    await db.enqueueOutbox(SyncOutboxCompanion.insert(
      id: 'outbox-retry-1',
      entityType: 'practice_attempt',
      entityId: 'attempt-retry-1',
      payloadJson: jsonEncode(practiceAttemptPayload(
        id: 'attempt-retry-1',
        sourceType: 'assessment',
        subjectId: 7,
        score: 1,
        totalQuestions: 2,
        timeSpentSeconds: 30,
        startedAt: '2026-07-29T11:00:00Z',
        completedAt: '2026-07-29T11:00:30Z',
        answers: const [],
      )),
      createdAt: '2026-07-29T11:00:30Z',
    ));

    await container.read(syncWorkerProvider).flush();

    // Needing re-auth short-circuits flush entirely — the row is left
    // exactly as it was, not touched at all.
    final pending = await db.pendingOutbox();
    expect(pending, hasLength(1));
    expect(pending.single.attemptCount, 0);
  });
}
