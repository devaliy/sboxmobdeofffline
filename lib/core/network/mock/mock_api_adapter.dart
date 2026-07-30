import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'mock_backend_store.dart';

class MockApiException implements Exception {
  MockApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;
}

/// Transport-layer test double for the entire Section 13 API contract.
/// Plugged in as `dio.httpClientAdapter` (see `api_client.dart`) so every
/// caller — endpoints.dart, and everything built on it — goes through the
/// exact same request/response path a real backend would use. Swapping to
/// the real backend later is a one-line change (drop the adapter override),
/// per spec Section 14's "build against a local mock server" guidance.
class MockApiAdapter implements HttpClientAdapter {
  MockApiAdapter(this._store);

  final MockBackendStore _store;
  static const _prefix = '/api/v1';

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200)); // feel like a network

    final path = options.uri.path.startsWith(_prefix)
        ? options.uri.path.substring(_prefix.length)
        : options.uri.path;
    final method = options.method.toUpperCase();
    final auth = options.headers['Authorization'] as String?;

    Map<String, dynamic>? body;
    if (requestStream != null) {
      final bytes = <int>[];
      await for (final chunk in requestStream) {
        bytes.addAll(chunk);
      }
      if (bytes.isNotEmpty) {
        body = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      }
    }

    try {
      return await _route(method, path, body, auth, options);
    } on MockApiException catch (e) {
      return _json({'message': e.message}, e.statusCode);
    }
  }

  Future<ResponseBody> _route(
    String method,
    String path,
    Map<String, dynamic>? body,
    String? auth,
    RequestOptions options,
  ) async {
    if (method == 'POST' && path == '/auth/register') return _register(body!);
    if (method == 'POST' && path == '/auth/login') return _login(body!);
    if (method == 'POST' && path == '/auth/logout') return _logout(auth);
    if (method == 'POST' && path == '/auth/password/forgot') return _forgotPassword(body!);
    if (method == 'POST' && path == '/auth/password/reset') return _resetPassword(body!);
    if (method == 'GET' && path == '/auth/me') return _me(auth);
    if (method == 'PATCH' && path == '/profile') return _updateProfile(auth, body!);

    if (method == 'GET' && path == '/content/manifest') return _manifest();

    final studyPackMatch = RegExp(r'^/content/study/(\d+)/pack$').firstMatch(path);
    if (method == 'GET' && studyPackMatch != null) {
      return _packDownload(_store.studyPack.zipBytes, options);
    }
    final assessmentPackMatch = RegExp(r'^/content/assessment/(\d+)/pack$').firstMatch(path);
    if (method == 'GET' && assessmentPackMatch != null) {
      return _packDownload(_store.assessmentPack.zipBytes, options);
    }

    if (method == 'POST' && path == '/sync/practice-attempts') {
      return _syncPracticeAttempts(auth, body!);
    }
    if (method == 'POST' && path == '/sync/reading-progress') {
      return _syncReadingProgress(auth, body!);
    }
    if (method == 'GET' && path == '/sync/status') return _json({'last_synced_at': null}, 200);

    throw MockApiException(404, 'Mock backend: no route for $method $path');
  }

  // --- Auth ------------------------------------------------------------------

  Future<ResponseBody> _register(Map<String, dynamic> body) async {
    final email = body['email'] as String;
    final phone = body['phone_number'] as String;
    if (_store.identifierTaken(email, phone)) {
      throw MockApiException(422, 'An account with that email or phone number already exists.');
    }
    final user = _store.createUser(
      firstName: body['firstname'] as String,
      lastName: body['lastname'] as String,
      email: email,
      phoneNumber: phone,
      password: body['password'] as String,
      currentClassId: body['current_class_id'] as int,
    );
    final token = _store.issueToken(user.id);
    return _json({'user': user.toJson(), 'token': token}, 201);
  }

  Future<ResponseBody> _login(Map<String, dynamic> body) async {
    final identifier = (body['email'] ?? body['phone_number'] ?? body['identifier']) as String;
    final password = body['password'] as String;
    final user = _store.findByLoginIdentifier(identifier);
    if (user == null || user.password != password) {
      throw MockApiException(401, 'Incorrect email/phone or password.');
    }
    final token = _store.issueToken(user.id);
    return _json({'user': user.toJson(), 'token': token}, 200);
  }

  Future<ResponseBody> _logout(String? auth) async {
    _store.revokeToken(auth);
    return _json({}, 200);
  }

  Future<ResponseBody> _forgotPassword(Map<String, dynamic> body) async {
    final identifier = (body['email'] ?? body['phone_number']) as String;
    if (_store.findByLoginIdentifier(identifier) == null) {
      throw MockApiException(404, 'No account found for that email/phone.');
    }
    final otp = _store.issueOtp(identifier);
    // A real backend sends this by SMS/email; the mock hands it back so the
    // dev UI can display "Your OTP (mock): 1234" instead of a real inbox.
    return _json({'message': 'OTP sent', 'debug_otp': otp}, 200);
  }

  Future<ResponseBody> _resetPassword(Map<String, dynamic> body) async {
    final identifier = (body['email'] ?? body['phone_number']) as String;
    final otp = body['otp'] as String;
    final newPassword = body['new_password'] as String;
    if (!_store.verifyAndConsumeOtp(identifier, otp)) {
      throw MockApiException(422, 'Invalid or expired OTP.');
    }
    final user = _store.findByLoginIdentifier(identifier);
    if (user == null) throw MockApiException(404, 'No account found for that email/phone.');
    user.password = newPassword;
    return _json({'message': 'Password reset'}, 200);
  }

  Future<ResponseBody> _me(String? auth) async {
    final user = _store.userForToken(auth);
    if (user == null) throw MockApiException(401, 'Session expired.');
    return _json({'user': user.toJson()}, 200);
  }

  Future<ResponseBody> _updateProfile(String? auth, Map<String, dynamic> body) async {
    final user = _store.userForToken(auth);
    if (user == null) throw MockApiException(401, 'Session expired.');
    if (body['current_class_id'] != null) user.currentClassId = body['current_class_id'] as int;
    if (body['phone_number'] != null) user.phoneNumber = body['phone_number'] as String;
    return _json({'user': user.toJson()}, 200);
  }

  // --- Content -----------------------------------------------------------

  Future<ResponseBody> _manifest() async => _json(_store.manifestJson(), 200);

  Future<ResponseBody> _packDownload(Uint8List fullBytes, RequestOptions options) async {
    final rangeHeader = options.headers['Range'] as String? ?? options.headers['range'] as String?;
    if (rangeHeader == null) {
      return ResponseBody.fromBytes(
        fullBytes,
        200,
        headers: {
          'content-type': ['application/zip'],
          'accept-ranges': ['bytes'],
          'content-length': ['${fullBytes.length}'],
        },
      );
    }

    // "bytes=START-END" | "bytes=START-"
    final match = RegExp(r'bytes=(\d+)-(\d*)').firstMatch(rangeHeader);
    if (match == null) throw MockApiException(416, 'Malformed Range header.');
    final start = int.parse(match.group(1)!);
    final endGroup = match.group(2);
    final end = (endGroup == null || endGroup.isEmpty)
        ? fullBytes.length - 1
        : int.parse(endGroup).clamp(0, fullBytes.length - 1);
    if (start >= fullBytes.length || start > end) {
      throw MockApiException(416, 'Range not satisfiable.');
    }
    final slice = fullBytes.sublist(start, end + 1);
    return ResponseBody.fromBytes(
      slice,
      206,
      headers: {
        'content-type': ['application/zip'],
        'accept-ranges': ['bytes'],
        'content-range': ['bytes $start-$end/${fullBytes.length}'],
        'content-length': ['${slice.length}'],
      },
    );
  }

  // --- Sync ----------------------------------------------------------------

  Future<ResponseBody> _syncPracticeAttempts(String? auth, Map<String, dynamic> body) async {
    if (_store.userForToken(auth) == null) throw MockApiException(401, 'Session expired.');
    final attempts = (body['attempts'] as List).cast<Map<String, dynamic>>();
    _store.receivedPracticeAttempts.addAll(attempts);
    return _json({
      'results': [
        for (final a in attempts) {'id': a['id'], 'status': 'synced'},
      ],
    }, 200);
  }

  Future<ResponseBody> _syncReadingProgress(String? auth, Map<String, dynamic> body) async {
    if (_store.userForToken(auth) == null) throw MockApiException(401, 'Session expired.');
    final progress = (body['progress'] as List).cast<Map<String, dynamic>>();
    _store.receivedReadingProgress.addAll(progress);
    return _json({
      'results': [
        for (final p in progress) {'id': p['library_subject_id'], 'status': 'synced'},
      ],
    }, 200);
  }

  // --- Helpers ---------------------------------------------------------------

  ResponseBody _json(Object data, int statusCode) {
    return ResponseBody.fromString(
      jsonEncode(data),
      statusCode,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }
}
