import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_worker.dart';

/// Defaults to the real `connectivity_plus` stream; overridden in tests
/// (see `test/support/test_overrides.dart`) to avoid the platform channel
/// that doesn't exist under `flutter test` — same reasoning as
/// `SetupController`'s injectable `isOnWifi`.
final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Activates the "connectivity regained" sync trigger (spec Section 8) —
/// `ref.watch` this once near the app root to start listening. Deliberately
/// a `Provider<void>` rather than a widget: the only side effect needed is
/// the `ref.listen` subscription itself, so there's nothing to build.
final syncTriggersProvider = Provider<void>((ref) {
  ref.listen(connectivityStreamProvider, (previous, next) {
    final hasConnection = next.valueOrNull?.any((r) => r != ConnectivityResult.none) ?? false;
    if (hasConnection) {
      ref.read(syncWorkerProvider).flush();
    }
  });
});
