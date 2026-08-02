import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:success_offline/core/db/progress_db.dart';

void main() {
  late ProgressDb db;

  setUp(() => db = ProgressDb.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('local_stats is a single row, created lazily on first read', () async {
    final stats = await db.readLocalStats();
    expect(stats.id, 1);
    expect(stats.totalPoints, 0);
    expect(stats.currentStreakDays, 0);
  });

  test('records a practice attempt with answers and enqueues + flushes an outbox entry',
      () async {
    const attemptId = 'c3f1e2a0-attempt';
    await db.into(db.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
          id: attemptId,
          sourceType: 'assessment',
          subjectId: const Value(7),
          testTypeId: const Value(3),
          score: 32,
          totalQuestions: 40,
          timeSpentSeconds: 2280,
          startedAt: '2026-07-29T08:00:00Z',
          completedAt: '2026-07-29T08:38:00Z',
        ));
    await db.into(db.practiceAnswers).insert(PracticeAnswersCompanion.insert(
          id: 'a1b2-answer',
          attemptId: attemptId,
          questionId: 30021,
          questionSource: 'assessment',
          selectedOption: const Value('B'),
          isCorrect: true,
          timeSpentSeconds: 34,
        ));

    await db.enqueueOutbox(SyncOutboxCompanion.insert(
      id: 'outbox-1',
      entityType: 'practice_attempt',
      entityId: attemptId,
      payloadJson: '{"id":"$attemptId"}',
      createdAt: '2026-07-29T08:38:01Z',
    ));

    final attempts = await db.watchRecentAttempts().first;
    expect(attempts.single.score, 32);

    var pending = await db.pendingOutbox();
    expect(pending, hasLength(1));
    expect(pending.single.status, 'pending');

    await db.markOutboxSynced('outbox-1');
    pending = await db.pendingOutbox();
    expect(pending, isEmpty);
  });

  test('recordActivity awards points and starts a 1-day streak on first activity', () async {
    await db.recordActivity(pointsEarned: 20);
    final stats = await db.readLocalStats();
    expect(stats.totalPoints, 20);
    expect(stats.currentStreakDays, 1);
    expect(stats.longestStreakDays, 1);
  });

  test('recordActivity on the same day adds points without re-bumping the streak', () async {
    await db.recordActivity(pointsEarned: 10);
    await db.recordActivity(pointsEarned: 15);
    final stats = await db.readLocalStats();
    expect(stats.totalPoints, 25);
    expect(stats.currentStreakDays, 1);
  });

  test('recordActivity on a consecutive day extends the streak and bumps the longest', () async {
    await db.recordActivity(pointsEarned: 10); // "today" -> streak 1
    final yesterday = DateTime.now().toUtc().subtract(const Duration(days: 1));
    final yesterdayIso = yesterday.toIso8601String().substring(0, 10);
    await (db.update(db.localStats)..where((t) => t.id.equals(1)))
        .write(LocalStatsCompanion(lastActiveDate: Value(yesterdayIso)));

    await db.recordActivity(pointsEarned: 5);
    final stats = await db.readLocalStats();
    expect(stats.currentStreakDays, 2);
    expect(stats.longestStreakDays, 2);
  });

  test('recordActivity after a gap of more than a day resets the streak but keeps the longest',
      () async {
    final longAgo = DateTime.now().toUtc().subtract(const Duration(days: 5));
    final longAgoIso = longAgo.toIso8601String().substring(0, 10);
    await db.into(db.localStats).insertOnConflictUpdate(LocalStatsCompanion(
          id: const Value(1),
          lastActiveDate: Value(longAgoIso),
          currentStreakDays: const Value(5),
          longestStreakDays: const Value(5),
        ));

    await db.recordActivity(pointsEarned: 1);
    final stats = await db.readLocalStats();
    expect(stats.currentStreakDays, 1);
    expect(stats.longestStreakDays, 5);
  });

  test('practice_attempts persists subjectName/testTypeLabel and answersForAttempt reads them back',
      () async {
    const attemptId = 'attempt-with-labels';
    await db.into(db.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
          id: attemptId,
          sourceType: 'assessment',
          subjectId: const Value(7),
          subjectName: const Value('Physics'),
          testTypeLabel: const Value('Speed Test'),
          score: 3,
          totalQuestions: 4,
          timeSpentSeconds: 120,
          startedAt: '2026-07-29T08:00:00Z',
          completedAt: '2026-07-29T08:02:00Z',
        ));
    await db.into(db.practiceAnswers).insert(PracticeAnswersCompanion.insert(
          id: 'answer-1',
          attemptId: attemptId,
          questionId: 1,
          questionSource: 'assessment',
          selectedOption: const Value('A'),
          isCorrect: true,
          timeSpentSeconds: 10,
        ));

    final attempts = await db.watchAllAttempts().first;
    expect(attempts.single.subjectName, 'Physics');
    expect(attempts.single.testTypeLabel, 'Speed Test');

    final answers = await db.answersForAttempt(attemptId);
    expect(answers, hasLength(1));
    expect(answers.single.selectedOption, 'A');
  });

  test('deleteAttempt removes the attempt and its answers', () async {
    const attemptId = 'attempt-to-delete';
    await db.into(db.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
          id: attemptId,
          sourceType: 'library',
          librarySubjectId: const Value(5),
          score: 1,
          totalQuestions: 2,
          timeSpentSeconds: 60,
          startedAt: '2026-07-29T08:00:00Z',
          completedAt: '2026-07-29T08:01:00Z',
        ));
    await db.into(db.practiceAnswers).insert(PracticeAnswersCompanion.insert(
          id: 'answer-del',
          attemptId: attemptId,
          questionId: 9,
          questionSource: 'library',
          selectedOption: const Value('C'),
          isCorrect: false,
          timeSpentSeconds: 5,
        ));

    await db.deleteAttempt(attemptId);

    expect(await db.watchAllAttempts().first, isEmpty);
    expect(await db.answersForAttempt(attemptId), isEmpty);
  });

  test('reading_progress upserts per library subject', () async {
    await db.into(db.readingProgress).insert(ReadingProgressCompanion.insert(
          id: 'rp-1',
          librarySubjectId: 101,
          percentComplete: 80,
          lastOpenedAt: '2026-07-29T09:10:00Z',
          lastPosition: const Value('section-3'),
        ));

    final progress = await db.watchReadingProgress(101).first;
    expect(progress?.percentComplete, 80);
  });
}
