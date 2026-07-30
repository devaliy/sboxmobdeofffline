import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/app_user.dart';
import 'api_client.dart';

/// Typed wrappers for every Section 13 endpoint. Nothing outside this file
/// should call `dio` directly — this is the one place that knows the wire
/// shapes, so a real-backend field-name mismatch only ever needs fixing
/// here.
class AuthEndpoints {
  AuthEndpoints(this._dio);
  final Dio _dio;

  Future<({AppUser user, String token})> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required int currentClassId,
  }) async {
    final res = await _guard(() => _dio.post('/auth/register', data: {
          'firstname': firstName,
          'lastname': lastName,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'current_class_id': currentClassId,
        }));
    return (
      user: AppUser.fromJson(res.data['user'] as Map<String, dynamic>),
      token: res.data['token'] as String,
    );
  }

  Future<({AppUser user, String token})> login({
    required String identifier,
    required String password,
  }) async {
    final res = await _guard(() => _dio.post('/auth/login', data: {
          'email': identifier,
          'password': password,
        }));
    return (
      user: AppUser.fromJson(res.data['user'] as Map<String, dynamic>),
      token: res.data['token'] as String,
    );
  }

  Future<void> logout() => _guard(() => _dio.post('/auth/logout'));

  /// Returns the mock's `debug_otp` (a real backend would just email/SMS
  /// it) so the dev build can surface it directly in the UI.
  Future<String?> forgotPassword({required String identifier}) async {
    final res = await _guard(() => _dio.post('/auth/password/forgot', data: {
          if (identifier.contains('@')) 'email': identifier else 'phone_number': identifier,
        }));
    return res.data['debug_otp'] as String?;
  }

  Future<void> resetPassword({
    required String identifier,
    required String otp,
    required String newPassword,
  }) =>
      _guard(() => _dio.post('/auth/password/reset', data: {
            if (identifier.contains('@')) 'email': identifier else 'phone_number': identifier,
            'otp': otp,
            'new_password': newPassword,
          }));

  Future<AppUser> me() async {
    final res = await _guard(() => _dio.get('/auth/me'));
    return AppUser.fromJson(res.data['user'] as Map<String, dynamic>);
  }

  Future<AppUser> updateProfile({int? currentClassId, String? phoneNumber}) async {
    final res = await _guard(() => _dio.patch('/profile', data: {
          'current_class_id': ?currentClassId,
          'phone_number': ?phoneNumber,
        }));
    return AppUser.fromJson(res.data['user'] as Map<String, dynamic>);
  }
}

/// Manifest fetch (spec Section 4.4) — consumed by M4's Setup screen.
/// Pack *downloads* themselves go through `PackDownloader`
/// (`core/downloads/pack_downloader.dart`) directly rather than this
/// class: resumable streaming-to-disk needs lower-level control
/// (`Options.responseType: ResponseType.stream`, incremental progress,
/// absolute-URL resolution for `download_url`'s full API path) than a
/// simple typed wrapper can offer.
class ContentEndpoints {
  ContentEndpoints(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> manifest() async {
    final res = await _guard(() => _dio.get('/content/manifest'));
    return res.data as Map<String, dynamic>;
  }
}

/// Device -> server sync (spec Section 4.6), consumed by M8's outbox
/// worker.
class SyncEndpoints {
  SyncEndpoints(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> practiceAttempts(List<Map<String, dynamic>> attempts) async {
    final res = await _guard(() => _dio.post('/sync/practice-attempts', data: {'attempts': attempts}));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> readingProgress(List<Map<String, dynamic>> progress) async {
    final res = await _guard(() => _dio.post('/sync/reading-progress', data: {'progress': progress}));
    return res.data as Map<String, dynamic>;
  }
}

Future<T> _guard<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw ApiException.fromDioException(e);
  }
}

final authEndpointsProvider = Provider<AuthEndpoints>((ref) => AuthEndpoints(ref.watch(dioProvider)));
final contentEndpointsProvider =
    Provider<ContentEndpoints>((ref) => ContentEndpoints(ref.watch(dioProvider)));
final syncEndpointsProvider = Provider<SyncEndpoints>((ref) => SyncEndpoints(ref.watch(dioProvider)));
