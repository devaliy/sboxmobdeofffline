import '../../../core/db/progress_db.dart';

/// One question+answer pair from a past attempt, reconstructed by joining a
/// `practice_answers` row back to its source question (assessment or
/// library, per `questionSource`) — enough to re-render the question
/// exactly as it appeared during the attempt.
class AttemptAnswerDetail {
  const AttemptAnswerDetail({
    required this.questionText,
    required this.imagePath,
    required this.options,
    required this.correctOption,
    required this.selectedOption,
    required this.isCorrect,
    required this.explanation,
  });

  final String questionText;
  final String? imagePath;

  /// Letter ('A'..'E') -> option text, in order.
  final Map<String, String> options;
  final String correctOption;
  final String? selectedOption;
  final bool isCorrect;
  final String? explanation;
}

class AttemptDetail {
  const AttemptDetail({
    required this.attempt,
    required this.subjectLabel,
    required this.testTypeLabel,
    required this.answers,
  });

  final PracticeAttempt attempt;
  final String subjectLabel;
  final String testTypeLabel;
  final List<AttemptAnswerDetail> answers;

  double get scorePercent =>
      attempt.totalQuestions == 0 ? 0 : attempt.score / attempt.totalQuestions * 100;
}
