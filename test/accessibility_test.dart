import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:success_offline/main.dart';

import 'support/test_overrides.dart';

/// Spec Section 9: "respect system text-scale in addition to the in-app
/// font-size setting." Flutter respects it by default with zero extra
/// code — the actual risk is a fixed-size layout (a tight Row, a small
/// chip) silently overflowing once every Text widget grows. This drives
/// the app through its main screens at a large system text scale and
/// checks nothing throws — the same kind of infinite-width/overflow
/// exception this build has hit for real more than once (M6, M8).
void main() {
  Future<void> pastSplash(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 950));
    await tester.pumpAndSettle();
  }

  // Some screens have a genuinely continuous animation while their data is
  // still loading (e.g. the shimmer sweep on a cold StreamProvider) —
  // pumpAndSettle never terminates while one is live, the same class of
  // issue M7's exam countdown hit. A bounded pump sidesteps it without
  // needing pixel-perfect settling, which is all an overflow/exception
  // check like this one needs.
  Future<void> safeSettle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('Main screens survive a 1.4x system text scale without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(ProviderScope(overrides: testProviderOverrides(), child: const SuccessBoxApp()));
    await pastSplash(tester);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.widgetWithText(TextFormField, 'Email or phone number'), 'jane@demo.ng');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Content gate -> Setup. Just the Study panel is enough to exercise
    // PackCard's tight title/size/item-count row under bigger text.
    expect(find.text('JSS2 Mathematics'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Assessment'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Skip actually downloading (irrelevant to this check) — go straight
    // to the shell via Settings/Progress/Practice, which is reachable
    // from Setup only once content exists, so instead directly drive the
    // router past the gate the way the M3 flow test does: download the
    // one Study pack, which is enough to unlock Home.
    await tester.tap(find.text('Study Center'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('JSS2 Mathematics'));
    await tester.pump();
    await tester.tap(find.textContaining('Download 1 selected'));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 300));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
    }
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    for (final tab in ['Study', 'Practice', 'Progress', 'Settings', 'Home']) {
      await tester.tap(find.text(tab).first);
      await safeSettle(tester);
      expect(tester.takeException(), isNull, reason: 'Overflow/exception on the $tab tab at 1.4x text scale');
    }

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
