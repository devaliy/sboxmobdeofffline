import '../../../core/db/assessment_content_db.dart';

/// A completed exam attempt, held only long enough to hand off from the
/// exam session to the results screen via `state.extra` (mirrors
/// `StudyQuizResult` in Study Center, M6).
class PracticeResult {
  const PracticeResult({
    required this.subjectName,
    required this.testTypeName,
    required this.questions,
    required this.selectedOptions,
    required this.flagged,
    required this.score,
    required this.timeSpentSeconds,
  });

  final String subjectName;
  final String testTypeName;
  final List<Question> questions;
  final Map<int, String?> selectedOptions;
  final Set<int> flagged;
  final int score;
  final int timeSpentSeconds;

  int get total => questions.length;
}
