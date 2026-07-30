/// Path constants — the single source of truth for every route in the app,
/// per spec Section 6's information architecture. Nothing should build a
/// route path with a raw string literal outside this file.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const setup = '/setup';
  static const editProfile = '/settings/edit-profile';

  static const home = '/home';
  static const study = '/study';
  static const practice = '/practice';
  static const progress = '/progress';
  static const settings = '/settings';

  // Study Center drill-down: Book grid -> Subject(week) list -> Reader ->
  // "Test yourself" quiz -> results (spec Section 7). Relative segments
  // (no leading '/') since these are declared as child GoRoutes of `study`.
  static const studyBookSegment = 'book/:bookId';
  static const studySubjectSegment = 'subject/:subjectId';
  static const studyQuizSegment = 'quiz';
  static const studyQuizResultsSegment = 'results';

  static String studyBook(int bookId) => '$study/book/$bookId';
  static String studySubject(int bookId, int subjectId) =>
      '${studyBook(bookId)}/subject/$subjectId';
  static String studyQuiz(int bookId, int subjectId) => '${studySubject(bookId, subjectId)}/quiz';
  static String studyQuizResults(int bookId, int subjectId) =>
      '${studyQuiz(bookId, subjectId)}/results';

  // Practice/CBT (spec Section 1.5/9): the active exam session is a
  // top-level route (outside the shell's StatefulShellRoute), not nested
  // under `practice`, so the bottom/top nav chrome never wraps it — "no
  // other chrome" during an active test is a hard requirement, not a
  // style preference.
  static String practiceExam(int testTypeId) => '/practice-exam/$testTypeId';
  static String practiceExamResults(int testTypeId) => '${practiceExam(testTypeId)}/results';

  /// Dev-only routes, exempt from the auth/content guards — see
  /// MOBILE_APP_BUILD_PROMPT.md's non-goals: never shipped as a real
  /// destination, just a design/QA aid during the build.
  static const devShowcase = '/dev/showcase';
}
