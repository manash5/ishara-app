import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_exception_mapper.dart';
import 'api_response.dart';
import 'auth_interceptor.dart';
import 'mock_api_adapter.dart';
import 'mock_api_settings.dart';
import 'token_refresh_remote_data_source.dart';
import 'token_storage.dart';
import '../../config/api_config.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final client = ApiClient(
    tokenStorage: ref.watch(tokenStorageProvider),
    adapter: ApiConfig.useMockApi
        ? MockApiAdapter(simulation: () => ref.read(mockApiSettingsProvider))
        : null,
  );
  ref.onDispose(client.dio.close);
  return client;
}

/// The one dio client for the REST API. Every method throws an
/// `AppException` (never a `DioException`); remote data sources parse the
/// body with [ApiEnvelope.fromJson].
class ApiClient {
  ApiClient({
    required TokenStorage tokenStorage,
    HttpClientAdapter? adapter,
    List<Duration> retryDelays = defaultRetryDelays,
    bool enableLogging = kDebugMode,
  }) {
    final options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    _dio = Dio(options);
    // Refresh goes through a bare client so a failing refresh can't loop.
    final refreshDio = Dio(options);
    if (adapter != null) {
      _dio.httpClientAdapter = adapter;
      refreshDio.httpClientAdapter = adapter;
    }

    // Add interceptors
    _dio.interceptors.add(
      AuthInterceptor(
        tokens: tokenStorage,
        dio: _dio,
        refresh: TokenRefreshRemoteDataSource(refreshDio).refresh,
      ),
    );

    // Auto retry on network failures
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: retryDelays.length,
        retryDelays: retryDelays,
        retryEvaluator: (error, attempt) => isRetryable(error),
      ),
    );

    // Only add logger in debug mode. Headers stay out of the log: they
    // carry the access token.
    if (enableLogging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  static const defaultRetryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 3),
  ];

  /// Retry on connection errors and timeouts, not on 4xx/5xx.
  static bool isRetryable(DioException error) =>
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.connectionError;

  late final Dio _dio;

  Dio get dio => _dio;

  // GET request
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _send(
    () => _dio.get(path, queryParameters: queryParameters, options: options),
  );

  // POST request
  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _send(
    () => _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  // PUT request
  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _send(
    () => _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  // DELETE request
  Future<Response<dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _send(
    () => _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  Future<Response<dynamic>> _send(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
