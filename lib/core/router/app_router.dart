import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/_dev/design_showcase_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/practice/domain/practice_result.dart';
import '../../features/practice/presentation/exam_session_screen.dart';
import '../../features/practice/presentation/practice_results_screen.dart';
import '../../features/practice/presentation/practice_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/edit_profile_screen.dart';
import '../../features/setup/presentation/setup_screen.dart';
import '../../features/study_center/domain/study_quiz_result.dart';
import '../../features/study_center/presentation/book_detail_screen.dart';
import '../../features/study_center/presentation/reader_screen.dart';
import '../../features/study_center/presentation/study_center_screen.dart';
import '../../features/study_center/presentation/study_quiz_results_screen.dart';
import '../../features/study_center/presentation/study_quiz_screen.dart';
import '../theme/theme_controller.dart';
import 'app_routes.dart';
import 'app_shell.dart';
import 'router_state.dart';

/// Bridges Riverpod state changes into a [Listenable] go_router can watch
/// via `refreshListenable` — the standard pattern for reactive redirects
/// without rebuilding the router itself on every state change.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(authStatusProvider, (_, _) => notifyListeners());
    ref.listen(contentInstalledProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    debugLogDiagnostics: false,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: AppRoutes.setup, builder: (context, state) => const SetupScreen()),
      GoRoute(path: AppRoutes.editProfile, builder: (context, state) => const EditProfileScreen()),
      // Top-level, outside the shell: an active exam session must never
      // show the bottom/top nav chrome (spec Section 1.5) — see the
      // comment on AppRoutes.practiceExam for why this can't be nested
      // under the `practice` branch like Study Center's drill-down is.
      GoRoute(
        path: '/practice-exam/:testTypeId',
        builder: (context, state) =>
            ExamSessionScreen(testTypeId: int.parse(state.pathParameters['testTypeId']!)),
        routes: [
          GoRoute(
            path: 'results',
            builder: (context, state) => PracticeResultsScreen(result: state.extra! as PracticeResult),
          ),
        ],
      ),
      // Dev-only QA aid (spec Section 10) — excluded from the route tree
      // entirely outside debug builds, not just unlinked from Settings,
      // per Phase 8's "remove debug-only screens".
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.devShowcase,
          builder: (context, state) => DesignShowcaseScreen(
            onToggleTheme: () {
              final notifier = ref.read(themeModeProvider.notifier);
              notifier.state = notifier.state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.study,
              builder: (context, state) => const StudyCenterScreen(),
              routes: [
                GoRoute(
                  path: AppRoutes.studyBookSegment,
                  builder: (context, state) =>
                      BookDetailScreen(bookId: int.parse(state.pathParameters['bookId']!)),
                  routes: [
                    GoRoute(
                      path: AppRoutes.studySubjectSegment,
                      builder: (context, state) => ReaderScreen(
                        bookId: int.parse(state.pathParameters['bookId']!),
                        subjectId: int.parse(state.pathParameters['subjectId']!),
                      ),
                      routes: [
                        GoRoute(
                          path: AppRoutes.studyQuizSegment,
                          builder: (context, state) => StudyQuizScreen(
                            bookId: int.parse(state.pathParameters['bookId']!),
                            subjectId: int.parse(state.pathParameters['subjectId']!),
                          ),
                          routes: [
                            GoRoute(
                              path: AppRoutes.studyQuizResultsSegment,
                              builder: (context, state) => StudyQuizResultsScreen(
                                bookId: int.parse(state.pathParameters['bookId']!),
                                result: state.extra! as StudyQuizResult,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.practice, builder: (context, state) => const PracticeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.progress, builder: (context, state) => const ProgressScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
          ]),
        ],
      ),
    ],
  );
});

/// Auth gate + content gate, per spec Section 6's information
/// architecture. Dev routes (`/dev/...`) bypass both guards entirely.
String? _redirect(Ref ref, GoRouterState state) {
  final loc = state.matchedLocation;
  if (loc.startsWith('/dev')) return null;

  final auth = ref.read(authStatusProvider);
  final hasContent = ref.read(contentInstalledProvider);

  const authPages = {AppRoutes.login, AppRoutes.register, AppRoutes.forgotPassword};
  final onSplash = loc == AppRoutes.splash;
  final onAuthPages = authPages.contains(loc);
  final onSetup = loc == AppRoutes.setup;

  if (auth == AuthStatus.unknown) {
    return onSplash ? null : AppRoutes.splash;
  }

  if (auth == AuthStatus.loggedOut) {
    return onAuthPages ? null : AppRoutes.login;
  }

  // Logged in from here on.
  if (!hasContent) {
    return onSetup ? null : AppRoutes.setup;
  }

  // Once content exists, Setup is still reachable deliberately (Settings ->
  // "Manage downloaded content") — only bounce splash/auth pages home.
  if (onSplash || onAuthPages) {
    return AppRoutes.home;
  }

  return null;
}
