/// Builds the exact `sync_outbox.payload_json` shapes from spec Section
/// 4.6 — pre-serialized once at enqueue time, so the M8 sync worker can
/// POST them straight through without re-deriving anything from the
/// content databases (which may have changed, or been removed, by the
/// time a retry finally succeeds).
library;

Map<String, dynamic> readingProgressPayload({
  required int librarySubjectId,
  required int percentComplete,
  String? lastPosition,
  required String lastOpenedAt,
}) =>
    {
      'library_subject_id': librarySubjectId,
      'percent_complete': percentComplete,
      'last_position': lastPosition,
      'last_opened_at': lastOpenedAt,
    };

Map<String, dynamic> practiceAnswerPayload({
  required String id,
  required int questionId,
  required String questionSource,
  String? selectedOption,
  required bool isCorrect,
  required int timeSpentSeconds,
}) =>
    {
      'id': id,
      'question_id': questionId,
      'question_source': questionSource,
      'selected_option': selectedOption,
      'is_correct': isCorrect,
      'time_spent_seconds': timeSpentSeconds,
    };

Map<String, dynamic> practiceAttemptPayload({
  required String id,
  required String sourceType,
  int? subjectId,
  int? librarySubjectId,
  int? testTypeId,
  required int score,
  required int totalQuestions,
  required int timeSpentSeconds,
  required String startedAt,
  required String completedAt,
  required List<Map<String, dynamic>> answers,
}) =>
    {
      'id': id,
      'source_type': sourceType,
      'subject_id': subjectId,
      'library_subject_id': librarySubjectId,
      'test_type_id': testTypeId,
      'score': score,
      'total_questions': totalQuestions,
      'time_spent_seconds': timeSpentSeconds,
      'started_at': startedAt,
      'completed_at': completedAt,
      'answers': answers,
    };
