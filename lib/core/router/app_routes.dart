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
  static const profile = '/profile';

  static const home = '/home';
  static const study = '/study';
  static const practice = '/practice';
  static const analytics = '/analytics';
  static const settings = '/settings';
  static const notifications = '/notifications';

  // SuccessAI (SUCCESSAI_BUILD_PROMPT.md): a Home entry point, not a nav
  // tab — top-level routes so they're reachable from anywhere (including
  // the floating chat button) without disturbing whichever shell branch
  // the student was on.
  static const aiChat = '/ai-chat';
  static const aiChatNew = '/ai-chat/new';
  static String aiChatConversation(String conversationId) => '/ai-chat/$conversationId';

  // Analytics report: viewing a single past attempt in detail is a
  // top-level route (not nested under the shell) so it can be pushed from
  // the report's data table with a plain back arrow, same shape as
  // Practice's own results screen.
  static String attemptDetail(String attemptId) => '/analytics/attempt/$attemptId';

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
  // style preference. Keyed by subject+category+year+format (a client-side
  // `PracticeTestType` name, 'speed'|'standard') rather than a `test_type_id`
  // — there's no server `test_types` row backing a session anymore.
  static String practiceExam({
    required int subjectId,
    required int categoryId,
    required int yearId,
    required String testType,
  }) =>
      '/practice-exam/$subjectId/$categoryId/$yearId/$testType';
  static String practiceExamResults({
    required int subjectId,
    required int categoryId,
    required int yearId,
    required String testType,
  }) =>
      '${practiceExam(subjectId: subjectId, categoryId: categoryId, yearId: yearId, testType: testType)}/results';

  /// Dev-only routes, exempt from the auth/content guards — see
  /// MOBILE_APP_BUILD_PROMPT.md's non-goals: never shipped as a real
  /// destination, just a design/QA aid during the build.
  static const devShowcase = '/dev/showcase';
}
