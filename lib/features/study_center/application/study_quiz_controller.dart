import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/progress_db.dart';
import '../../../core/db/study_content_db.dart';
import '../../../core/sync/outbox_payloads.dart';
import '../../auth/application/auth_controller.dart';
import '../domain/study_quiz_result.dart';

const _uuid = Uuid();

/// Grades a Study Center "test yourself" quiz and writes the result: one
/// `practice_attempts` row (`source_type: 'library'`) plus its
/// `practice_answers`, all in a single transaction, then enqueues the sync
/// payload (spec Section 4.6) — written locally first, synced later,
/// exactly like the M7 Practice/CBT engine will do for assessment attempts.
class StudyQuizController {
  StudyQuizController(this._ref);
  final Ref _ref;

  Future<StudyQuizResult> submit({
    required int librarySubjectId,
    required List<LibraryQuestion> questions,
    required Map<int, String?> selectedOptions,
    required DateTime startedAt,
  }) async {
    final db = _ref.read(currentProgressDbProvider);
    if (db == null) {
      throw StateError('Cannot submit a quiz without a signed-in account.');
    }

    final completedAt = DateTime.now().toUtc();
    final attemptId = _uuid.v4();
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
        questionSource: 'library',
        selectedOption: Value(selected),
        isCorrect: isCorrect,
        timeSpentSeconds: 0,
      ));
      answerPayloads.add(practiceAnswerPayload(
        id: answerId,
        questionId: question.id,
        questionSource: 'library',
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
            sourceType: 'library',
            librarySubjectId: Value(librarySubjectId),
            score: score,
            totalQuestions: questions.length,
            timeSpentSeconds: completedAt.difference(startedAt).inSeconds,
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
          sourceType: 'library',
          librarySubjectId: librarySubjectId,
          score: score,
          totalQuestions: questions.length,
          timeSpentSeconds: completedAt.difference(startedAt).inSeconds,
          startedAt: startedAtIso,
          completedAt: completedAtIso,
          answers: answerPayloads,
        )),
        createdAt: completedAtIso,
      ));
    });
    await db.recordActivity(pointsEarned: score * 10);

    return StudyQuizResult(questions: questions, selectedOptions: selectedOptions, score: score);
  }
}

final studyQuizControllerProvider = Provider<StudyQuizController>((ref) => StudyQuizController(ref));
