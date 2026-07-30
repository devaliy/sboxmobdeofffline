import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/assessment_content_db.dart';
import '../../../core/db/progress_db.dart';
import '../../../core/sync/outbox_payloads.dart';
import '../../auth/application/auth_controller.dart';
import '../domain/practice_result.dart';

const _uuid = Uuid();

/// Grades a completed exam session and writes the result: one
/// `practice_attempts` row (`source_type: 'assessment'`) plus its
/// `practice_answers`, all in a single transaction, then enqueues the sync
/// payload — same write-then-enqueue shape Study Center's
/// [StudyQuizController] uses for `source_type: 'library'` (M6).
class PracticeExamController {
  PracticeExamController(this._ref);
  final Ref _ref;

  Future<PracticeResult> submit({
    required int subjectId,
    required int testTypeId,
    required String subjectName,
    required String testTypeName,
    required List<Question> questions,
    required Map<int, String?> selectedOptions,
    required Set<int> flagged,
    required DateTime startedAt,
  }) async {
    final db = _ref.read(currentProgressDbProvider);
    if (db == null) {
      throw StateError('Cannot submit an exam without a signed-in account.');
    }

    final completedAt = DateTime.now().toUtc();
    final attemptId = _uuid.v4();
    final timeSpentSeconds = completedAt.difference(startedAt).inSeconds;
    var score = 0;
    final answerCompanions = <PracticeAnswersCompanion>[];
    final answerPayloads = <Map<String, dynamic>>[];

    for (final question in questions) {
      final selected = selectedOptions[question.id];
      final isCorrect = selected != null && selected == question.correctOption;
      if (isCorrect) score++;

      final answerId = _uuid.v4();
      answerCompanions.add(PracticeAnswersCompanion.insert(
        id: answerId,
        attemptId: attemptId,
        questionId: question.id,
        questionSource: 'assessment',
        selectedOption: Value(selected),
        isCorrect: isCorrect,
        timeSpentSeconds: 0,
      ));
      answerPayloads.add(practiceAnswerPayload(
        id: answerId,
        questionId: question.id,
        questionSource: 'assessment',
        selectedOption: selected,
        isCorrect: isCorrect,
        timeSpentSeconds: 0,
      ));
    }

    final startedAtIso = startedAt.toUtc().toIso8601String();
    final completedAtIso = completedAt.toIso8601String();

    await db.transaction(() async {
      await db.into(db.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
            id: attemptId,
            sourceType: 'assessment',
            subjectId: Value(subjectId),
            testTypeId: Value(testTypeId),
            score: score,
            totalQuestions: questions.length,
            timeSpentSeconds: timeSpentSeconds,
            startedAt: startedAtIso,
            completedAt: completedAtIso,
          ));
      for (final companion in answerCompanions) {
        await db.into(db.practiceAnswers).insert(companion);
      }
      await db.enqueueOutbox(SyncOutboxCompanion.insert(
        id: _uuid.v4(),
        entityType: 'practice_attempt',
        entityId: attemptId,
        payloadJson: jsonEncode(practiceAttemptPayload(
          id: attemptId,
          sourceType: 'assessment',
          subjectId: subjectId,
          testTypeId: testTypeId,
          score: score,
          totalQuestions: questions.length,
          timeSpentSeconds: timeSpentSeconds,
          startedAt: startedAtIso,
          completedAt: completedAtIso,
          answers: answerPayloads,
        )),
        createdAt: completedAtIso,
      ));
    });
    await db.recordActivity(pointsEarned: score * 10);

    return PracticeResult(
      subjectName: subjectName,
      testTypeName: testTypeName,
      questions: questions,
      selectedOptions: selectedOptions,
      flagged: flagged,
      score: score,
      timeSpentSeconds: timeSpentSeconds,
    );
  }
}

final practiceExamControllerProvider =
    Provider<PracticeExamController>((ref) => PracticeExamController(ref));
