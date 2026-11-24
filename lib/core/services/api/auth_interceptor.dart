import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'token_storage.dart';

/// Exchanges a refresh token for new tokens (`POST /auth/refresh`).
typedef TokenRefresher = Future<AuthTokens> Function(String refreshToken);

/// Adds `Authorization: Bearer <access token>` to protected requests. On a
/// 401 it refreshes once — concurrent 401s share that refresh — saves the new
/// tokens and retries the request. If the refresh fails it clears the tokens,
/// which signs the user out.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokens,
    required this.dio,
    required this.refresh,
  });

  static const retriedKey = 'auth_retried';

  final TokenStorage tokens;

  /// The client to retry on (the one this interceptor is added to).
  final Dio dio;
  final TokenRefresher refresh;
  Future<AuthTokens?>? _refreshing;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!ApiEndpoints.isPublic(options.path)) {
      final stored = await tokens.read();
      if (stored != null) {
        options.headers['Authorization'] = 'Bearer ${stored.accessToken}';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        ApiEndpoints.isPublic(options.path) ||
        options.extra[retriedKey] == true) {
      return handler.next(err);
    }

    final fresh = await _freshTokens(options);
    if (fresh == null) return handler.next(err);

    options.extra[retriedKey] = true;
    try {
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// Tokens to retry with: the stored ones if another request already
  /// refreshed them, otherwise the result of the single shared refresh.
  Future<AuthTokens?> _freshTokens(RequestOptions failed) async {
    if (_refreshing case final pending?) return pending;
    final stored = await tokens.read();
    if (stored == null) return null;
    final sent = failed.headers['Authorization'];
    if (sent != null && sent != 'Bearer ${stored.accessToken}') return stored;
    // Another request may have started a refresh while we read storage.
    return _refreshing ??= _refreshOnce(stored)
        .whenComplete(() => _refreshing = null);
  }

  Future<AuthTokens?> _refreshOnce(AuthTokens stored) async {
    try {
      final fresh = await refresh(stored.refreshToken);
      await tokens.save(fresh);
      return fresh;
    } catch (_) {
      await tokens.clear();
      return null;
    }
  }
}
