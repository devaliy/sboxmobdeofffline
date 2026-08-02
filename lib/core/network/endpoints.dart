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
    String deviceName = 'SuccessBOX App',
  }) async {
    final res = await _guard(() => _dio.post('/auth/login', data: {
          // `identifier` accepts either an email or a phone number — the
          // server checks both columns itself (API_DOCUMENTATION.md
          // Section 2), so there's no client-side branching needed.
          'identifier': identifier,
          'password': password,
          'device_name': deviceName,
        }));
    return (
      user: AppUser.fromJson(res.data['user'] as Map<String, dynamic>),
      token: res.data['token'] as String,
    );
  }

  Future<void> logout() => _guard(() => _dio.post('/auth/logout'));

  /// The real backend only supports email-based reset — no `phone_number`
  /// field exists on this endpoint (API_DOCUMENTATION.md Section 2). The
  /// mock hands back a `debug_otp` so the dev build can surface it
  /// directly in the UI (a real backend just emails it, so this key is
  /// simply absent there — `as String?` already handles that).
  Future<String?> forgotPassword({required String identifier}) async {
    final res = await _guard(() => _dio.post('/auth/password/forgot', data: {
          'email': identifier,
        }));
    return res.data['debug_otp'] as String?;
  }

  Future<void> resetPassword({
    required String identifier,
    required String otp,
    required String newPassword,
  }) =>
      _guard(() => _dio.post('/auth/password/reset', data: {
            'email': identifier,
            'otp': otp,
            'password': newPassword,
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

  /// Server-side counts + last-received timestamps per entity type
  /// (API_DOCUMENTATION.md Section 5) — a "last synced" indicator that
  /// survives a reinstall, since purely local state has nothing to show
  /// right after a fresh install even for an account with years of
  /// server-side history.
  Future<Map<String, dynamic>> status() async {
    final res = await _guard(() => _dio.get('/sync/status'));
    return res.data as Map<String, dynamic>;
  }
}

/// SuccessAI (SUCCESSAI_BUILD_PROMPT.md Section 2) — no API key of any kind
/// lives in this app; every call reuses the same bearer token as every
/// other authenticated endpoint via [dioProvider]'s interceptor. Server is
/// authoritative for everything: conversation ids, titles, message
/// ordering. `POST /ai/chat` is rate-limited server-side (20/min) — this
/// class deliberately has no client-side retry loop.
class AiChatEndpoints {
  AiChatEndpoints(this._dio);
  final Dio _dio;

  /// Omit [conversationId] to start a new thread. Response contains both
  /// the saved user message and the AI's reply.
  Future<Map<String, dynamic>> sendMessage({String? conversationId, required String message}) async {
    final res = await _guard(() => _dio.post('/ai/chat', data: {
          'conversation_id': ?conversationId,
          'message': message,
        }));
    return res.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> listConversations() async {
    final res = await _guard(() => _dio.get('/ai/conversations'));
    return List<Map<String, dynamic>>.from(res.data['conversations'] as List? ?? res.data as List);
  }

  Future<List<Map<String, dynamic>>> listMessages(String conversationId) async {
    final res = await _guard(() => _dio.get('/ai/conversations/$conversationId/messages'));
    return List<Map<String, dynamic>>.from(res.data['messages'] as List? ?? res.data as List);
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
final aiChatEndpointsProvider =
    Provider<AiChatEndpoints>((ref) => AiChatEndpoints(ref.watch(dioProvider)));
