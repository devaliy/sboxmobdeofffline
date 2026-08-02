/// The exam formats offered for any Assessment subject+category
/// combination. Fixed client-side rather than read from the server's
/// `test_types` table: pulling real `pack.json` files directly from
/// production across every installed subject (and a broad sample of the
/// rest of the catalog) confirmed `test_types` is `[]` everywhere — it's
/// never been populated — while `categories` (e.g. "UTME Simulator", "SSCE
/// Test Engine") and `questions.category_id` are real and populated.
/// Building a picker around data that will never arrive would just be a
/// permanently-empty screen; these two formats are what the app offers
/// instead, applied against whichever category+subject the student picks.
enum PracticeTestType {
  speed(label: 'Speed Test', durationMinutes: 10, numQuestions: 10),
  standard(label: 'Standard Test', durationMinutes: 60, numQuestions: 45);

  const PracticeTestType({
    required this.label,
    required this.durationMinutes,
    required this.numQuestions,
  });

  final String label;
  final int durationMinutes;
  final int numQuestions;
}
