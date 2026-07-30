/// What Home's "Continue studying" card needs — assembled from a
/// `reading_progress` row (in the account's `progress.sqlite`) joined
/// against the matching subject/book (in the device-shared
/// `study_content.sqlite`). Null anywhere in the chain (deleted pack,
/// nothing read yet) just means "show the empty state" upstream.
class ContinueStudyingInfo {
  const ContinueStudyingInfo({
    required this.librarySubjectId,
    required this.subjectTitle,
    required this.bookName,
    required this.bookColor,
    required this.percentComplete,
  });

  final int librarySubjectId;
  final String subjectTitle;
  final String bookName;
  final String bookColor;
  final int percentComplete;
}
