import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:success_offline/main.dart';

import '../../support/test_overrides.dart';

/// The desktop combined topics-sidebar + reader view (`DesktopBookReader`)
/// has no other coverage — `study_center_flow_test.dart` runs at a mobile
/// viewport, which takes the separate list -> reader route entirely. This
/// proves the desktop branch (opening a book lands directly in the reader,
/// sidebar + book progress header + content + inline "Take test" all at
/// once) renders cleanly, with no overflow or exceptions.
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

  testWidgets(
      'Desktop: opening a book lands directly in the combined topics+reader view, no overflow',
      (WidgetTester tester) async {
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

    expect(find.text('JSS2 Mathematics'), findsOneWidget);
    await tester.tap(find.text('JSS2 Mathematics'));
    await waitForDownload(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Study'));
    await tester.pumpAndSettle();
    expect(find.text('Study Center'), findsWidgets);
    expect(find.text('Mathematics'), findsOneWidget);

    // No intermediate "pick a week" list on desktop — one tap on the book
    // lands directly in the topics sidebar + reader, already showing its
    // first (only) week's content.
    await tester.tap(find.text('Mathematics'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Week 1: Algebra Basics'), findsWidgets); // sidebar tile + content heading
    expect(find.textContaining('Algebraic expressions combine numbers'), findsOneWidget);
    expect(find.text('Take test'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
