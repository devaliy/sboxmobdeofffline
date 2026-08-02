import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:success_offline/main.dart';

import '../../support/test_overrides.dart';

/// The exam session's desktop density (two-column question+options / image
/// panel, `IntrinsicHeight`-stretched) has a real branch of layout code
/// (`exam_session_screen.dart`'s `_ExamBody`) that no other test actually
/// renders — every other practice test runs at a mobile viewport. This
/// proves that branch builds and lays out cleanly (no `RenderFlex`
/// overflow, no exceptions) rather than only ever being exercised at
/// mobile width.
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

  testWidgets('Exam session at desktop width lays out the two-column question+image panel '
      'without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
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
    await waitForDownload(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Objective'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Standard Test')); // exercises a different format than the mobile tests
    await tester.pumpAndSettle();
    await tester.tap(find.text('Physics'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2019'));
    // Bounded pump, not pumpAndSettle — the countdown's Timer.periodic
    // keeps scheduling frames for the whole session.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(tester.takeException(), isNull);
    expect(find.text('1/4'), findsOneWidget);
    // The question card and the (always-reserved, image-or-placeholder)
    // right-hand panel both render side by side.
    expect(find.text('What is the acceleration due to gravity (approx.)?'), findsOneWidget);

    // Answer and move to the next question — re-lays-out the two-column
    // body for a different question (one with a real image this time),
    // still with no overflow.
    await tester.tap(find.text('9.8 m/s²'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('2/4'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
