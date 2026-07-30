import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:success_offline/core/db/db_providers.dart';
import 'package:success_offline/core/db/study_content_db.dart';
import 'package:success_offline/core/router/widgets/app_bottom_nav.dart';
import 'package:success_offline/core/router/widgets/app_top_nav.dart';
import 'package:success_offline/features/auth/application/auth_controller.dart';
import 'package:success_offline/main.dart';

import 'support/test_overrides.dart';

void main() {
  Future<void> pastSplash(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 950));
    await tester.pumpAndSettle();
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 200, scrollable: find.byType(Scrollable).first);
    // scrollUntilVisible stops the instant any part of the target
    // intersects the viewport, which can leave it clipped right at the
    // edge — ensureVisible properly aligns it (centered) so the tap's
    // center point reliably lands inside bounds.
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Downloading a pack mixes two async primitives `pumpAndSettle` alone
  /// can't reliably drive through: the mock backend's simulated network
  /// latency (`Future.delayed`, gated by testWidgets' fake clock — needs
  /// `pump(duration)` to advance) and `compute()`'s real isolate
  /// message-passing for the off-main-isolate zip decode (spec Section 8
  /// — doesn't run on the fake clock at all, and `pumpAndSettle` alone can
  /// return early since no widget rebuild is scheduled while it's
  /// pending). Interleaving both keeps whichever is currently blocking
  /// moving.
  Future<void> waitForDownload(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 300));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
    }
    await tester.pumpAndSettle();
  }

  /// The content gate watches drift stream queries; disposing the widget
  /// tree cancels those subscriptions, and drift schedules a zero-duration
  /// cleanup Timer when that happens. Left alone, that Timer is still
  /// "pending" by the time testWidgets' teardown asserts none are —
  /// tearing the tree down explicitly, then pumping once more, flushes it
  /// before that assertion runs.
  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    // A single pump() isn't reliably enough to flush a Timer scheduled
    // *during* that same disposal; pumpAndSettle loops until nothing
    // remains pending.
    await tester.pumpAndSettle();
  }

  testWidgets('Boots to splash, then routes an unauthenticated user to Login',
      (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(overrides: testProviderOverrides(), child: const SuccessBoxApp()));
    await pastSplash(tester);

    expect(find.text('Welcome back'), findsOneWidget);
    await disposeCleanly(tester);
  });

  testWidgets(
      'Full M3 flow: real login against the mock backend -> content gate (Setup) -> '
      'main shell, tab switching, real logout', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(ProviderScope(overrides: testProviderOverrides(), child: const SuccessBoxApp()));
    await pastSplash(tester);

    // Auth gate: logged out -> Login. Log in with a real demo account
    // against the in-process mock backend.
    expect(find.text('Welcome back'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'Email or phone number'), 'jane@demo.ng');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    // Content gate: logged in, no packs installed -> Setup (mandatory).
    // Jane's default class (JSS 2) matches the mock Study pack, so it's
    // visible without changing the class dropdown.
    expect(find.text('Get your content'), findsOneWidget);
    expect(find.text('JSS2 Mathematics'), findsOneWidget);

    await tester.tap(find.text('JSS2 Mathematics'));
    await tester.pump();
    await tester.tap(find.textContaining('Download 1 selected'));
    await waitForDownload(tester);
    // PackCard's installed state (M9) shows a version tag + a remove
    // action rather than a plain "Installed" label.
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

    await tester.tap(find.text('Assessment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Physics'));
    await tester.pump();
    await tester.tap(find.textContaining('Download 1 selected'));
    await waitForDownload(tester);

    // At least one (here, both) domain installed unlocks Home.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Both gates cleared -> lands on Home inside the main shell.
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Resources'), findsOneWidget); // Home's quick-actions section, not the Study tab

    await tester.tap(find.text('Study'));
    await tester.pumpAndSettle();
    expect(find.text('Study Center'), findsWidgets);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    // Real profile, fetched via /auth/me during splash's background refresh.
    expect(find.text('Jane Davies'), findsOneWidget);

    await tapVisible(tester, find.text('Log out'));

    // Real logout drops back through both gates to Login.
    expect(find.text('Welcome back'), findsOneWidget);
    await disposeCleanly(tester);
  });

  testWidgets('Desktop-width surface renders the top nav density, not the bottom nav',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(overrides: testProviderOverrides());
    // Disposed explicitly at the end of this test body (not via
    // addTearDown) so the drift stream cleanup it triggers can be flushed
    // with one more pump before testWidgets' "no pending timers" check.

    // Real login via the auth controller (rather than poking router state
    // directly) so splash's bootstrap sees a genuine cached session.
    // `runAsync` is required here: this runs before any `pump()`, so the
    // fake clock `testWidgets` normally drives isn't advancing yet — a
    // bare `await` on the mock adapter's simulated network delay would
    // hang forever waiting on a timer nothing is ticking.
    await tester.runAsync(() => container.read(authControllerProvider).login(
          identifier: 'jane@demo.ng',
          password: 'password123',
        ));
    // Seed the content gate directly (this test is about nav density, not
    // the download flow — see the dedicated Setup test for that).
    final studyDb = container.read(studyContentDbProvider);
    await tester.runAsync(() async {
      await studyDb.into(studyDb.installedStudyPacks).insert(InstalledStudyPacksCompanion.insert(
            scopeType: 'book',
            scopeId: 12,
            version: '1',
            checksum: 'sha256:test',
            sizeBytes: 100,
            installedAt: DateTime.now().toIso8601String(),
          ));
      // Wait for the content-gate stream to actually observe the insert —
      // otherwise the app's first redirect evaluation (at boot) can still
      // see "no content" and land briefly on Setup before catching up,
      // which now (correctly) stays there rather than bouncing to Home.
      await container.read(installedStudyPacksProvider.future);
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const SuccessBoxApp()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppTopNav), findsOneWidget);
    expect(find.byType(AppBottomNav), findsNothing);
    expect(find.text('Practice'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    container.dispose();
    await tester.pumpAndSettle();
  });
}
