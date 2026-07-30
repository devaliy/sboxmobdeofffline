import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:success_offline/main.dart';

import '../../support/test_overrides.dart';

/// Proves M7's review gate end-to-end (spec Phase 5 done-criteria): with a
/// downloaded Assessment pack, a signed-in user can run a full timed exam
/// start-to-finish — subject/test-type setup, passage-linked questions,
/// flagging, question palette, submit — and land on a correctly scored,
/// reviewable results screen. All against imported mock data, not stubs.
void main() {
  Future<void> pastSplash(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 950));
    await tester.pumpAndSettle();
  }

  Future<void> waitForDownload(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 300));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
    }
    await tester.pumpAndSettle();
  }

  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  }

  testWidgets(
      'Full timed exam offline: Physics / JAMB Practice, flag one question, score 4/4',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(ProviderScope(overrides: testProviderOverrides(), child: const SuccessBoxApp()));
    await pastSplash(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Email or phone number'), 'jane@demo.ng');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    // Only the Assessment domain is relevant here — skip Study.
    await tester.tap(find.text('Assessment'));
    await tester.pumpAndSettle();
    expect(find.text('Physics'), findsOneWidget);
    await tester.tap(find.text('Physics'));
    await tester.pump();
    await tester.tap(find.textContaining('Download 1 selected'));
    await waitForDownload(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Setup: subject -> test type.
    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    expect(find.text('Practice'), findsWidgets);
    expect(find.text('Physics'), findsOneWidget);
    expect(find.text('JAMB Practice'), findsOneWidget);
    expect(find.textContaining('4 questions'), findsOneWidget);

    // The exam's countdown is a real Timer.periodic that keeps scheduling
    // frames for the whole session (that's the point — it must keep
    // ticking even if nothing else changes) — `pumpAndSettle()` would
    // never settle while it's alive, so every interaction from here until
    // Submit (which cancels it) uses a bounded `pump()` instead.
    await tester.tap(find.text('JAMB Practice'));
    // A bounded pump long enough to finish the page's slide-in transition
    // and let the questions FutureProvider resolve — NOT pumpAndSettle,
    // since the countdown's Timer.periodic would keep it spinning forever.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Exam session: no bottom/top nav chrome — this is the top-level,
    // chrome-free route (see AppRoutes.practiceExam).
    expect(find.text('Question 1 of 4'), findsOneWidget);

    // Q1: flag it, then answer correctly, then move on.
    await tester.tap(find.byIcon(Icons.flag_outlined));
    await tester.pump();
    expect(find.byIcon(Icons.flag_rounded), findsWidgets); // toolbar flag icon now filled
    await tester.tap(find.text('A. 9.8 m/s²'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pump();

    // Q2.
    expect(find.text('Question 2 of 4'), findsOneWidget);
    await tester.tap(find.text('B. Newton'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pump();

    // Q3: passage-linked — its title renders even collapsed, once the
    // passage FutureProvider resolves (one more pump beyond the bare
    // setState rebuild the other questions needed).
    expect(find.text('Question 3 of 4'), findsOneWidget);
    await tester.pump();
    expect(find.text('Newton\'s Laws of Motion'), findsOneWidget);
    await tester.tap(find.text('B. An external force acts on it'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pump();

    // Q4: last question -> "Next" is replaced by "Submit".
    expect(find.text('Question 4 of 4'), findsOneWidget);
    await tester.tap(find.text('A. F = ma'));
    await tester.pump();
    expect(find.text('Next'), findsNothing);
    await tester.tap(find.text('Submit'));
    // Submit cancels the ticker before awaiting the DB write, so
    // pumpAndSettle is safe again from here on.
    await tester.pumpAndSettle();

    // Results: perfect score, one flagged question noted in review.
    expect(find.text('4 / 4 correct'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('JAMB Practice'), findsOneWidget);
    expect(find.text('Physics'), findsWidgets);
    expect(find.byIcon(Icons.flag_rounded), findsOneWidget); // the flagged-question badge in review

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Back on the Practice setup screen, inside the shell again.
    expect(find.text('JAMB Practice'), findsOneWidget);

    await disposeCleanly(tester);
  });
}
