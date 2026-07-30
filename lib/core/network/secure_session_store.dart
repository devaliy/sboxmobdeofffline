import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoredSession {
  const StoredSession({required this.token, required this.userId});
  final String token;
  final int userId;
}

/// The bearer token and active user id — the only two pieces of auth state
/// persisted to disk, and the only place they're allowed to live (spec
/// Section 8: "No password or token is ever written to any `.sqlite` file
/// or `shared_preferences` — only `flutter_secure_storage`").
abstract class SecureSessionStore {
  Future<void> save({required String token, required int userId});
  Future<StoredSession?> read();
  Future<void> clear();
}

class FlutterSecureSessionStore implements SecureSessionStore {
  FlutterSecureSessionStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'auth_user_id';

  @override
  Future<void> save({required String token, required int userId}) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId.toString());
  }

  @override
  Future<StoredSession?> read() async {
    final token = await _storage.read(key: _tokenKey);
    final userIdRaw = await _storage.read(key: _userIdKey);
    if (token == null || userIdRaw == null) return null;
    final userId = int.tryParse(userIdRaw);
    if (userId == null) return null;
    return StoredSession(token: token, userId: userId);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
  }
}

/// Test double — avoids the `flutter_secure_storage` platform channel,
/// which isn't available under `flutter test`.
class InMemorySecureSessionStore implements SecureSessionStore {
  StoredSession? _session;

  @override
  Future<void> save({required String token, required int userId}) async {
    _session = StoredSession(token: token, userId: userId);
  }

  @override
  Future<StoredSession?> read() async => _session;

  @override
  Future<void> clear() async => _session = null;
}

final secureSessionStoreProvider = Provider<SecureSessionStore>((ref) {
  return FlutterSecureSessionStore();
});
