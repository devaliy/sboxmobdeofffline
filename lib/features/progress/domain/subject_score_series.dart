/// One subject/book's score-over-time line — feeds the report's multi-line
/// "score over time" chart, one series per subject.
class SubjectScoreSeries {
  const SubjectScoreSeries({required this.label, required this.points});

  final String label;
  final List<ScorePoint> points;
}

class ScorePoint {
  const ScorePoint({required this.date, required this.scorePercent});

  final DateTime date;
  final double scorePercent;
}
