import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:success_offline/core/db/assessment_content_db.dart';
import 'package:success_offline/core/db/db_providers.dart';
import 'package:success_offline/core/db/progress_db.dart';
import 'package:success_offline/core/db/study_content_db.dart';
import 'package:success_offline/core/theme/theme.dart';
import 'package:success_offline/features/auth/application/auth_controller.dart';
import 'package:success_offline/features/progress/presentation/analytics_screen.dart';
import 'package:success_offline/features/progress/presentation/attempt_detail_screen.dart';

/// Isolated coverage for the Analytics report (formerly Progress) — seeds a
/// [ProgressDb] directly with a handful of attempts (skipping login/setup,
/// which the full-app flow tests already cover) so the stats/pie/line/table
/// derivations have real, varied data to render against instead of only
/// ever being exercised by the empty state.
void main() {
  late ProgressDb db;

  setUp(() => db = ProgressDb.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  // The default 800x600 test surface is narrower than the report's data
  // table (it scrolls horizontally by design) and shorter than the full
  // page — both would put the row action icons out of the tappable
  // viewport. A generous fixed surface avoids needing scroll gymnastics
  // in every interaction test below.
  void useGenerousViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1400, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  // A bounded pump rather than pumpAndSettle: drift's `.watch()` streams
  // keep a query alive for as long as anything is subscribed, which reads
  // as "still settling" to pumpAndSettle's frame-scheduling heuristic even
  // once the data has already resolved and rendered.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  // Fully unmounts the widget tree before the test ends — without this,
  // drift's internal stream-cancellation bookkeeping can leave a
  // zero-duration cleanup Timer pending past teardown, which
  // flutter_test's invariant check flags as a leak.
  Future<void> disposeTree(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  }

  Future<void> seedAttempt({
    required String id,
    required String subjectName,
    required int score,
    required int total,
    required String completedAt,
  }) {
    return db.into(db.practiceAttempts).insert(PracticeAttemptsCompanion.insert(
          id: id,
          sourceType: 'assessment',
          subjectId: const Value(1),
          subjectName: Value(subjectName),
          testTypeLabel: const Value('Standard Test'),
          score: score,
          totalQuestions: total,
          timeSpentSeconds: 300,
          startedAt: completedAt,
          completedAt: completedAt,
        ));
  }

  Widget buildApp() {
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const AnalyticsScreen()),
      GoRoute(
        path: '/analytics/attempt/:attemptId',
        builder: (context, state) =>
            AttemptDetailScreen(attemptId: state.pathParameters['attemptId']!),
      ),
    ]);
    return ProviderScope(
      overrides: [
        currentProgressDbProvider.overrideWithValue(db),
        studyContentDbProvider.overrideWith((ref) => StudyContentDb.forTesting(NativeDatabase.memory())),
        assessmentContentDbProvider
            .overrideWith((ref) => AssessmentContentDb.forTesting(NativeDatabase.memory())),
      ],
      child: MaterialApp.router(routerConfig: router, theme: AppTheme.light()),
    );
  }

  testWidgets('shows the empty state with no attempts recorded', (tester) async {
    await tester.pumpWidget(buildApp());
    await settle(tester);

    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Nothing to report yet'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await disposeTree(tester);
  });

  testWidgets('renders headline stats, mini stat tiles and the test history table', (tester) async {
    await seedAttempt(id: 'a1', subjectName: 'Physics', score: 3, total: 4, completedAt: '2026-06-01T08:00:00Z');
    await seedAttempt(id: 'a2', subjectName: 'Physics', score: 4, total: 4, completedAt: '2026-06-15T08:00:00Z');
    await seedAttempt(id: 'a3', subjectName: 'Chemistry', score: 1, total: 4, completedAt: '2026-07-01T08:00:00Z');

    await tester.pumpWidget(buildApp());
    await settle(tester);

    expect(find.text('Nothing to report yet'), findsNothing);
    // Mini stat tiles.
    expect(find.text('3'), findsWidgets); // total tests taken
    expect(find.text('Total tests taken'), findsOneWidget);
    expect(find.text('Highest score'), findsOneWidget);
    expect(find.text('Total passed'), findsOneWidget);
    expect(find.text('Total failed'), findsOneWidget);
    // Test history table shows both subjects.
    expect(find.text('Physics'), findsWidgets);
    expect(find.text('Chemistry'), findsWidgets);

    expect(tester.takeException(), isNull);

    await disposeTree(tester);
  });

  testWidgets('viewing an attempt from the table opens its detail screen', (tester) async {
    useGenerousViewport(tester);
    await seedAttempt(id: 'a1', subjectName: 'Physics', score: 3, total: 4, completedAt: '2026-06-01T08:00:00Z');
    await db.into(db.practiceAnswers).insert(PracticeAnswersCompanion.insert(
          id: 'ans-1',
          attemptId: 'a1',
          questionId: 1,
          questionSource: 'assessment',
          selectedOption: const Value('A'),
          isCorrect: true,
          timeSpentSeconds: 10,
        ));

    await tester.pumpWidget(buildApp());
    await settle(tester);

    await tester.tap(find.byTooltip('View'));
    await settle(tester);

    expect(find.text('Test result'), findsOneWidget);
    expect(find.textContaining('Physics'), findsWidgets);
    expect(tester.takeException(), isNull);

    await disposeTree(tester);
  });

  testWidgets('deleting an attempt removes it from the table', (tester) async {
    useGenerousViewport(tester);
    await seedAttempt(id: 'a1', subjectName: 'Physics', score: 3, total: 4, completedAt: '2026-06-01T08:00:00Z');

    await tester.pumpWidget(buildApp());
    await settle(tester);
    expect(find.text('Physics'), findsWidgets);

    await tester.tap(find.byTooltip('Delete'));
    await settle(tester);
    await tester.tap(find.text('Delete').last);
    await settle(tester);

    expect(find.text('Nothing to report yet'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await disposeTree(tester);
  });
}
