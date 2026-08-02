/// One subject/book's share of total recorded study+practice time — feeds
/// the report's "time spent per subject" pie chart.
class SubjectTimeSlice {
  const SubjectTimeSlice({required this.label, required this.seconds});

  final String label;
  final int seconds;
}
