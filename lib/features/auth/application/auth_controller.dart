import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/db_providers.dart';
import '../../../core/db/progress_db.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';
import '../../../core/network/secure_session_store.dart';
import '../../../core/router/router_state.dart';
import '../domain/app_user.dart';

/// The signed-in user's cached profile — `null` until the first successful
/// login/register/refresh in this process. Screens that need "no data yet"
/// handling (Home's greeting, Settings) should treat null gracefully
/// rather than assuming it's always populated the instant [AuthStatus] is
/// `loggedIn` (the splash bootstrap is optimistic-local first, network
/// refresh second).
final currentUserProvider = StateProvider<AppUser?>((ref) => null);

/// The signed-in account's progress database — `null` until [currentUserProvider]
/// is populated. Lives here (not `core/db`) since it's really "auth state
/// projected onto a db handle"; every feature that reads/writes progress
/// (Home, Study Center, Practice, Progress) should go through this rather
/// than re-deriving the user id itself.
final currentProgressDbProvider = Provider<ProgressDb?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.watch(progressDbProvider(user.id.toString()));
});

/// Orchestrates auth per spec Sections 7/8/3.3. Deliberately a plain
/// service (not a Notifier) — it doesn't hold state itself, it only reads
/// and writes the focused providers above/in `router_state.dart` that do.
class AuthController {
  AuthController(this._ref);
  final Ref _ref;

  /// Called once at splash. Trusts a cached session immediately (so the
  /// app works fully offline / in airplane mode after a force-quit), then
  /// best-effort refreshes the profile in the background — a failure here
  /// (offline, or a genuinely expired token) never forces the student out.
  Future<void> bootstrap() async {
    StoredSession? session;
    try {
      session = await _ref.read(secureSessionStoreProvider).read();
    } catch (_) {
      // Secure storage (Android Keystore-backed) can throw on some devices
      // — treated the same as "no session" rather than left to crash the
      // app at splash, consistent with every other soft-fail in this file.
      session = null;
    }
    if (session == null) {
      _ref.read(authStatusProvider.notifier).state = AuthStatus.loggedOut;
      return;
    }
    _ref.read(authStatusProvider.notifier).state = AuthStatus.loggedIn;
    unawaited(_refreshProfile());
  }

  Future<void> _refreshProfile() async {
    try {
      final user = await _ref.read(authEndpointsProvider).me();
      _ref.read(currentUserProvider.notifier).state = user;
    } catch (_) {
      // Offline, or a 401 already recorded by the dio interceptor via
      // needsReauthProvider — either way, silent per spec Section 8.
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final result = await _ref
        .read(authEndpointsProvider)
        .login(identifier: identifier, password: password);
    await _completeSignIn(result.user, result.token);
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required int currentClassId,
  }) async {
    final result = await _ref
        .read(authEndpointsProvider)
        .register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
          currentClassId: currentClassId,
        );
    await _completeSignIn(result.user, result.token);
  }

  /// Settings -> Edit profile (spec Section 7/13's `PATCH /profile`) — the
  /// only two fields the backend contract allows changing; name/email
  /// aren't editable from the app.
  Future<void> updateProfile({int? currentClassId, String? phoneNumber}) async {
    final user = await _ref
        .read(authEndpointsProvider)
        .updateProfile(
          currentClassId: currentClassId,
          phoneNumber: phoneNumber,
        );
    _ref.read(currentUserProvider.notifier).state = user;
  }

  Future<String?> forgotPassword(String identifier) =>
      _ref.read(authEndpointsProvider).forgotPassword(identifier: identifier);

  Future<void> resetPassword({
    required String identifier,
    required String otp,
    required String newPassword,
  }) => _ref
      .read(authEndpointsProvider)
      .resetPassword(
        identifier: identifier,
        otp: otp,
        newPassword: newPassword,
      );

  Future<void> _completeSignIn(AppUser user, String token) async {
    // Per spec Section 3.3: opening `ProgressDb.forUser` transparently
    // creates the file on first use or reopens it as-is if this account
    // has used this device before — no branching needed here.
    _ref.read(progressDbProvider(user.id.toString()));

    await _ref
        .read(secureSessionStoreProvider)
        .save(token: token, userId: user.id);
    _ref.read(currentUserProvider.notifier).state = user;
    _ref.read(needsReauthProvider.notifier).state = false;
    _ref.read(authStatusProvider.notifier).state = AuthStatus.loggedIn;
  }

  /// Returns true when unsynced results were left behind (spec Section
  /// 3.3's logout warning) so the caller can surface the one-line notice.
  /// Content databases are never touched by logout.
  Future<bool> logout() async {
    final session = await _ref.read(secureSessionStoreProvider).read();
    var hadUnsynced = false;
    if (session != null) {
      final progressDb = _ref.read(
        progressDbProvider(session.userId.toString()),
      );
      hadUnsynced = (await progressDb.pendingOutbox()).isNotEmpty;
    }

    try {
      await _ref.read(authEndpointsProvider).logout();
    } catch (_) {
      // Offline logout still logs the device out locally.
    }

    await _ref.read(secureSessionStoreProvider).clear();
    _ref.read(currentUserProvider.notifier).state = null;
    _ref.read(needsReauthProvider.notifier).state = false;
    _ref.read(authStatusProvider.notifier).state = AuthStatus.loggedOut;
    return hadUnsynced;
  }
}

final authControllerProvider = Provider<AuthController>(
  (ref) => AuthController(ref),
);
