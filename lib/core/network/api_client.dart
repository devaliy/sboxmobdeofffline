import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock/mock_api_adapter.dart';
import 'mock/mock_backend_store.dart';
import 'secure_session_store.dart';

/// The real backend (API_DOCUMENTATION.md) is what the app talks to by
/// default now. This is only a *default* — [useMockBackendProvider] below
/// is what `dioProvider` actually reads, and every test overrides it back
/// to `true` via `testProviderOverrides()` regardless of this constant, so
/// `flutter test` can never accidentally hit the live server no matter
/// what this flag is set to.
const bool kUseMockBackend = false;

const String kApiBaseUrl = 'https://successbox.ng/api/v1';

/// Flips to true when any *protected* endpoint returns 401 — a real bearer
/// token expired mid-session. Per spec Section 8, this must never force the
/// student out: offline features stay fully available, and the prompt to
/// re-authenticate only ever surfaces in Settings or on a manual sync action.
final needsReauthProvider = StateProvider<bool>((ref) => false);

final mockBackendStoreProvider = Provider<MockBackendStore>((ref) => MockBackendStore());

/// The provider `dioProvider` actually reads — a thin, overridable wrapper
/// around [kUseMockBackend] so tests can force the mock on regardless of
/// what the app's own default is. See `test/support/test_overrides.dart`.
final useMockBackendProvider = Provider<bool>((ref) => kUseMockBackend);

/// dio instance + auth interceptor. Every Section 13 endpoint is called
/// through this — see `endpoints.dart` for the typed wrappers.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: kApiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    responseType: ResponseType.json,
  ));

  if (ref.watch(useMockBackendProvider)) {
    dio.httpClientAdapter = MockApiAdapter(ref.watch(mockBackendStoreProvider));
  }

  final sessionStore = ref.watch(secureSessionStoreProvider);

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final session = await sessionStore.read();
      if (session != null) {
        options.headers['Authorization'] = 'Bearer ${session.token}';
      }
      handler.next(options);
    },
    onError: (error, handler) {
      final status = error.response?.statusCode;
      final path = error.requestOptions.path;
      final isAuthEndpoint = path.contains('/auth/login') ||
          path.contains('/auth/register') ||
          path.contains('/auth/password/');
      if (status == 401 && !isAuthEndpoint) {
        ref.read(needsReauthProvider.notifier).state = true;
      }
      handler.next(error);
    },
  ));

  return dio;
});

/// Typed failure for every non-2xx response, carrying the server's message
/// (mock or real) so the UI can show it directly.
class ApiException implements Exception {
  ApiException(this.statusCode, this.message);
  final int? statusCode;
  final String message;

  factory ApiException.fromDioException(DioException e) {
    final data = e.response?.data;
    final message = (data is Map && data['message'] is String)
        ? data['message'] as String
        : e.message ?? 'Something went wrong. Please try again.';
    return ApiException(e.response?.statusCode, message);
  }

  @override
  String toString() => message;
}
