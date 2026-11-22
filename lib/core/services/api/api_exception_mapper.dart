import 'package:dio/dio.dart';

import '../../error/app_exception.dart';

/// Maps a [DioException] to the typed [AppException] data sources throw.
AppException mapDioException(DioException e) {
  if (e.error case final AppException inner) return inner;
  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => const NetworkException(),
    DioExceptionType.badResponse => _fromResponse(e.response),
    _ => const UnknownException(),
  };
}

AppException _fromResponse(Response<dynamic>? response) {
  final status = response?.statusCode ?? 0;
  return switch (status) {
    401 => const UnauthorizedException(),
    404 => const NotFoundException(),
    409 => const ConflictException(),
    400 || 422 => ValidationException(_message(response?.data)),
    >= 500 => ServerException(status),
    _ => const UnknownException(),
  };
}

String? _message(Object? body) =>
    body is Map && body['message'] is String ? body['message'] as String : null;
