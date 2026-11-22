import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/api_exception_mapper.dart';

void main() {
  final request = RequestOptions(path: '/me');

  DioException withStatus(int status, [Object? body]) => DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: request, statusCode: status, data: body),
  );

  test('timeouts and connection errors are network failures', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ]) {
      expect(
        mapDioException(DioException(requestOptions: request, type: type)),
        isA<NetworkException>(),
        reason: type.name,
      );
    }
  });

  test('status codes map to typed exceptions', () {
    expect(mapDioException(withStatus(401)), isA<UnauthorizedException>());
    expect(mapDioException(withStatus(404)), isA<NotFoundException>());
    expect(mapDioException(withStatus(409)), isA<ConflictException>());
    expect(mapDioException(withStatus(500)), isA<ServerException>());
    expect(
      (mapDioException(withStatus(503)) as ServerException).statusCode,
      503,
    );
    expect(mapDioException(withStatus(418)), isA<UnknownException>());
  });

  test('422 and 400 carry the envelope message', () {
    final e = mapDioException(
      withStatus(422, {
        'status': 422,
        'success': false,
        'message': 'Pick a daily goal',
      }),
    );
    expect((e as ValidationException).message, 'Pick a daily goal');
    expect(
      (mapDioException(
        withStatus(400, 'not json'),
      ) as ValidationException).message,
      isNull,
    );
  });

  test('cancel and unknown types are unknown', () {
    expect(
      mapDioException(
        DioException(requestOptions: request, type: DioExceptionType.cancel),
      ),
      isA<UnknownException>(),
    );
    expect(
      mapDioException(DioException(requestOptions: request)),
      isA<UnknownException>(),
    );
  });

  test('an AppException wrapped in the error is passed through', () {
    expect(
      mapDioException(
        DioException(requestOptions: request, error: const CacheException()),
      ),
      isA<CacheException>(),
    );
  });
}
