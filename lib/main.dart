import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/sync/sync_triggers.dart';
import 'core/sync/sync_worker.dart';
import 'core/theme/theme.dart';

void main() {
  // A guard of last resort: an uncaught error anywhere in an unawaited
  // Future (startup included) would otherwise escape the isolate and take
  // the whole app down on-device with no on-screen sign of what happened —
  // as opposed to Flutter's own framework errors (widget build/layout),
  // which `FlutterError.onError` already reports without crashing.
  runZonedGuarded(
    () => runApp(const ProviderScope(child: SuccessBoxApp())),
    (error, stack) => FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stack),
    ),
  );
}

class SuccessBoxApp extends ConsumerStatefulWidget {
  const SuccessBoxApp({super.key});

  @override
  ConsumerState<SuccessBoxApp> createState() => _SuccessBoxAppState();
}

/// Two of the sync engine's three triggers (spec Section 8) live here at
/// the app root: app-resume (this observer) and connectivity-regained
/// (activated below via `syncTriggersProvider`). The third — periodic
/// background sync via `workmanager` — was never wired up and the
/// dependency has been removed entirely: on a real Android device its
/// plugin auto-registers a `WorkManager` startup `ContentProvider` that
/// runs before `Application.onCreate()`/the Flutter engine, and its
/// `WorkDatabase` init was crashing the whole process at launch (visible as
/// the splash flashing and immediately closing) — for a feature that had no
/// caller anywhere in this codebase.
class _SuccessBoxAppState extends ConsumerState<SuccessBoxApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(syncWorkerProvider).flush();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Activates the connectivity-regained listener — see
    // sync_triggers.dart. Nothing here reads its value; the side effect
    // (the `ref.listen` subscription) is the point.
    ref.watch(syncTriggersProvider);

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'SuccessBOX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
