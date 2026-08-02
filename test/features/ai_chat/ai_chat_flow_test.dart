import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:success_offline/core/sync/sync_triggers.dart';
import 'package:success_offline/main.dart';

import '../../support/test_overrides.dart';

/// The base test overrides stub connectivity to an empty stream (every
/// other test only needs Dio calls to work, which doesn't depend on it) —
/// SuccessAI's send flow explicitly checks it though (offline must refuse
/// to send, per SUCCESSAI_BUILD_PROMPT.md), so this suite needs a real
/// "online" signal to exercise that path at all.
List<Override> _onlineOverrides() => [
      ...testProviderOverrides(),
      connectivityStreamProvider.overrideWith((ref) => Stream.value([ConnectivityResult.wifi])),
    ];

/// End-to-end coverage for SuccessAI (SUCCESSAI_BUILD_PROMPT.md) against
/// the mock backend's `/ai/chat` + `/ai/conversations` routes: empty state
/// -> new chat -> send -> AI reply renders -> conversation shows up back
/// in the list. The mock never calls a real AI provider (see
/// `MockBackendStore.sendAiMessage`'s canned reply) — this proves the
/// client-side plumbing (routing, provider wiring, cache upsert) works,
/// not the real OpenRouter integration, which lives entirely server-side.
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

  /// The SuccessAI resource card can sit below the fold on a short mobile
  /// viewport — scroll it fully into view before tapping rather than
  /// assuming its default position is already on screen.
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 200, scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(finder);
    await tester.pump();
    await tester.tap(finder);
  }

  /// Deliberately no trailing `pumpAndSettle()`: `EmptyState` (shown by
  /// SuccessAI's "no conversations yet" / "ask me anything" states) has a
  /// permanently-repeating pulse animation, so `pumpAndSettle` never
  /// returns once one is on screen — the same reason `accessibility_test
  /// .dart`'s `safeSettle` exists. Bounded pumps only, with `runAsync`
  /// delays interleaved so real isolate work left over from the pack
  /// import (same root cause `waitForDownload` above exists for) has a
  /// chance to actually drain too.
  Future<void> settleAsync(WidgetTester tester) async {
    for (var i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 300));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
    }
  }

  testWidgets('New chat -> send -> AI reply renders -> conversation appears in the list',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(ProviderScope(overrides: _onlineOverrides(), child: const SuccessBoxApp()));
    await pastSplash(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Email or phone number'), 'jane@demo.ng');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Download all'));
    await waitForDownload(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Home's SuccessAI resource card -> conversation list, real empty state.
    await tapVisible(tester, find.text('SuccessAI'));
    await settleAsync(tester);
    expect(find.text('Ask SuccessAI anything'), findsOneWidget);

    await tester.tap(find.text('New chat'));
    await settleAsync(tester);
    expect(find.text('Ask SuccessAI anything'), findsOneWidget); // chat screen's own empty state

    await tester.enterText(find.byType(TextField), 'What is photosynthesis?');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await settleAsync(tester);

    expect(find.text('What is photosynthesis?'), findsOneWidget);
    expect(find.textContaining('Mock SuccessAI reply to: What is photosynthesis?'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Route replaced itself onto the real conversation id -> back to the
    // list shows the new thread instead of the empty state.
    await tester.pageBack();
    await settleAsync(tester);
    expect(find.text('Ask SuccessAI anything'), findsNothing);
    expect(find.textContaining('What is photosynthesis?'), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('The floating chat button opens a chat sheet from any main-shell page',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(ProviderScope(overrides: _onlineOverrides(), child: const SuccessBoxApp()));
    await pastSplash(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Email or phone number'), 'jane@demo.ng');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Download all'));
    await waitForDownload(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Study'));
    await settleAsync(tester);

    await tester.tap(find.byTooltip('Ask SuccessAI'));
    await settleAsync(tester);

    expect(find.text('SuccessAI'), findsWidgets);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await settleAsync(tester);
    // Dismissing the sheet lands back on Study, not some other screen.
    expect(find.text('Study Center'), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
