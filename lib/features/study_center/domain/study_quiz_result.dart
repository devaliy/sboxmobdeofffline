import '../../../core/db/study_content_db.dart';

/// What the results/review screen needs — the questions plus whichever
/// option (if any) the student picked for each, alongside the final score.
class StudyQuizResult {
  const StudyQuizResult({
    required this.questions,
    required this.selectedOptions,
    required this.score,
  });

  final List<LibraryQuestion> questions;
  final Map<int, String?> selectedOptions; // questionId -> selected option letter
  final int score;

  int get total => questions.length;
}
