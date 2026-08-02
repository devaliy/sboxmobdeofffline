import '../../../core/db/progress_db.dart';

/// A [PracticeAttempt] with its subject/test-type labels resolved — legacy
/// attempts recorded before the `subject_name`/`test_type_label` columns
/// existed fall back to a live content-DB lookup (see
/// `progress_providers.dart`'s `resolveSubjectLabel`).
class AttemptRow {
  const AttemptRow({
    required this.attempt,
    required this.subjectLabel,
    required this.testTypeLabel,
  });

  final PracticeAttempt attempt;
  final String subjectLabel;
  final String testTypeLabel;

  double get scorePercent =>
      attempt.totalQuestions == 0 ? 0 : attempt.score / attempt.totalQuestions * 100;
}
