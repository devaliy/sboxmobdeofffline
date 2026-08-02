import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_controller.dart';

/// Shared by every "Log out" affordance (Settings, the Profile screen, the
/// top-nav profile dropdown) so the unsynced-results warning only has one
/// implementation. The router's own `authStatusProvider` listener handles
/// navigating back to Login once the session clears — this never needs to
/// push a route itself.
Future<void> runLogoutFlow(BuildContext context, WidgetRef ref) async {
  final hadUnsynced = await ref.read(authControllerProvider).logout();
  if (!context.mounted) return;
  if (hadUnsynced) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You have unsynced results — they'll upload next time you're online and signed in."),
      ),
    );
  }
}
