import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:success_offline/main.dart';

import '../../support/test_overrides.dart';

/// Proves M10's "keyboard navigation in the exam session" requirement
/// (spec Phase 8) actually does something, not just that the code
/// compiles: a full attempt driven entirely by the keyboard — letter keys
/// to pick an option, arrow keys between questions, Enter to submit on
/// the last one — should score identically to the mouse-driven flow
/// `practice_flow_test.dart` already proves.
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

  testWidgets('A full exam attempt driven entirely by the keyboard scores 4/4',
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

    await tester.tap(find.text('Assessment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Physics'));
    await tester.pump();
    await tester.tap(find.textContaining('Download 1 selected'));
    await waitForDownload(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('JAMB Practice'));
    // Bounded pump, not pumpAndSettle — the countdown's Timer.periodic
    // keeps scheduling frames for the whole session (see
    // practice_flow_test.dart for the full explanation).
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Question 1 of 4'), findsOneWidget);

    // Q1: correct_option is 'A' — select it, then move on with the arrow
    // key instead of tapping "Next".
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();

    expect(find.text('Question 2 of 4'), findsOneWidget);
    // Q2: correct_option is 'B'.
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();

    expect(find.text('Question 3 of 4'), findsOneWidget);
    // Q3 (passage-linked): correct_option is 'B'. Use the digit-key
    // alias (2 == B) to prove both key schemes work, not just letters.
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();

    expect(find.text('Question 4 of 4'), findsOneWidget);
    // Q4: correct_option is 'A'. This is the last question, so onNext is
    // null and Enter falls through to submit — every question is already
    // answered, so no confirmation dialog appears.
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    // Submitting cancels the ticker before awaiting the DB write, so
    // pumpAndSettle is safe again from here on.
    await tester.pumpAndSettle();

    expect(find.text('4 / 4 correct'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('ArrowLeft returns to a previous question with its answer preserved',
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

    await tester.tap(find.text('Assessment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Physics'));
    await tester.pump();
    await tester.tap(find.textContaining('Download 1 selected'));
    await waitForDownload(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('JAMB Practice'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Q1: select the correct answer, advance, then come straight back —
    // proving the selection persists across the round trip is the point,
    // so nothing gets re-selected on the way back.
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(find.text('Question 2 of 4'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(find.text('Question 1 of 4'), findsOneWidget);

    // Answer the remaining three questions and submit — if Q1's
    // keyboard-driven selection hadn't actually persisted, this would
    // score 3/4, not 4/4.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text('4 / 4 correct'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
