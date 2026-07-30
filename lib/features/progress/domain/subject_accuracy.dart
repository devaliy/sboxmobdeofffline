/// One subject/book's aggregate accuracy across every attempt recorded
/// against it (Study Center "test yourself" quizzes count toward their
/// book; Practice/CBT attempts count toward their assessment subject).
class SubjectAccuracy {
  const SubjectAccuracy({required this.label, required this.correct, required this.total});

  final String label;
  final int correct;
  final int total;

  double get accuracy => total == 0 ? 0 : correct / total;
}
