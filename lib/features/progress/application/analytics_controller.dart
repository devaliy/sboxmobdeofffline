import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/assessment_content_db.dart';
import '../../../core/db/db_providers.dart';
import '../../../core/db/progress_db.dart';
import '../../../core/db/study_content_db.dart';
import '../../auth/application/auth_controller.dart';
import '../domain/attempt_detail.dart';
import 'progress_providers.dart';

/// Reconstructs one past attempt's questions+answers for the Analytics
/// report's "view" action — joins each `practice_answers` row back to its
/// source question by `questionSource`, since that's the only thing in the
/// answer row that says which content database it came from.
final attemptDetailProvider =
    FutureProvider.autoDispose.family<AttemptDetail?, String>((ref, attemptId) async {
  final db = ref.watch(currentProgressDbProvider);
  if (db == null) return null;

  final attempt =
      await (db.select(db.practiceAttempts)..where((t) => t.id.equals(attemptId))).getSingleOrNull();
  if (attempt == null) return null;

  final studyDb = ref.watch(studyContentDbProvider);
  final assessmentDb = ref.watch(assessmentContentDbProvider);
  final subjectLabel = await resolveSubjectLabel(attempt, studyDb, assessmentDb);
  final testTypeLabel =
      (attempt.testTypeLabel?.isNotEmpty ?? false) ? attempt.testTypeLabel! : (attempt.sourceType == 'library' ? 'Self Test' : 'Practice');

  final storedAnswers = await db.answersForAttempt(attemptId);
  final answers = <AttemptAnswerDetail>[];
  for (final answer in storedAnswers) {
    final detail = answer.questionSource == 'assessment'
        ? await _fromAssessmentQuestion(assessmentDb, answer)
        : await _fromLibraryQuestion(studyDb, answer);
    if (detail != null) answers.add(detail);
  }

  return AttemptDetail(
    attempt: attempt,
    subjectLabel: subjectLabel,
    testTypeLabel: testTypeLabel,
    answers: answers,
  );
});

Future<AttemptAnswerDetail?> _fromAssessmentQuestion(
  AssessmentContentDb db,
  PracticeAnswer answer,
) async {
  final q = await db.questionById(answer.questionId);
  if (q == null) return null;
  return AttemptAnswerDetail(
    questionText: q.questionText,
    imagePath: q.imagePath,
    options: {
      'A': q.optionA,
      'B': q.optionB,
      'C': q.optionC,
      'D': q.optionD,
      if (q.optionE != null) 'E': q.optionE!,
    },
    correctOption: q.correctOption,
    selectedOption: answer.selectedOption,
    isCorrect: answer.isCorrect,
    explanation: q.explanation,
  );
}

Future<AttemptAnswerDetail?> _fromLibraryQuestion(StudyContentDb db, PracticeAnswer answer) async {
  final q = await db.questionById(answer.questionId);
  if (q == null) return null;
  return AttemptAnswerDetail(
    questionText: q.questionText,
    imagePath: q.imagePath,
    options: {
      'A': q.optionA,
      'B': q.optionB,
      'C': q.optionC,
      'D': q.optionD,
      if (q.optionE != null) 'E': q.optionE!,
    },
    correctOption: q.correctOption,
    selectedOption: answer.selectedOption,
    isCorrect: answer.isCorrect,
    explanation: q.explanation,
  );
}

class AnalyticsController {
  AnalyticsController(this._ref);
  final Ref _ref;

  Future<void> deleteAttempt(String attemptId) async {
    final db = _ref.read(currentProgressDbProvider);
    if (db == null) return;
    await db.deleteAttempt(attemptId);
  }

  /// Plain-text summary for the report table's "share" action — copied to
  /// the clipboard rather than an OS share sheet, since this is an offline
  /// app with nothing else to share to.
  String buildSummary(AttemptDetail detail) {
    final percent = detail.scorePercent.round();
    return '${detail.subjectLabel} — ${detail.testTypeLabel}\n'
        'Score: ${detail.attempt.score}/${detail.attempt.totalQuestions} ($percent%)\n'
        'Completed: ${detail.attempt.completedAt}';
  }
}

final analyticsControllerProvider = Provider<AnalyticsController>((ref) => AnalyticsController(ref));
