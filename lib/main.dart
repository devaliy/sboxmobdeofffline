import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/sync/sync_triggers.dart';
import 'core/sync/sync_worker.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: SuccessBoxApp()));
}

class SuccessBoxApp extends ConsumerStatefulWidget {
  const SuccessBoxApp({super.key});

  @override
  ConsumerState<SuccessBoxApp> createState() => _SuccessBoxAppState();
}

/// Two of the sync engine's three triggers (spec Section 8) live here at
/// the app root: app-resume (this observer) and connectivity-regained
/// (activated below via `syncTriggersProvider`). The third — periodic
/// background sync via `workmanager` — is deliberately out of scope for
/// this build: it's Android-only, this environment has no Android
/// toolchain to compile or run it against, and it couldn't reach the
/// in-process mock backend from its own isolate regardless.
class _SuccessBoxAppState extends ConsumerState<SuccessBoxApp> with WidgetsBindingObserver {
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
