import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';

void main() {
  test('guard wraps a value in Ok', () async {
    final result = await guard(() async => 42);
    expect(result, isA<Ok<int>>());
    expect(result.valueOrNull, 42);
    expect(result.isOk, isTrue);
  });

  test('guard maps each AppException to its Failure', () async {
    final cases = <AppException, Type>{
      const NetworkException(): NetworkFailure,
      const UnauthorizedException(): UnauthorizedFailure,
      const NotFoundException(): NotFoundFailure,
      const ConflictException(): ConflictFailure,
      const ValidationException('Bad'): ValidationFailure,
      const ServerException(500): ServerFailure,
      const CacheException(): CacheFailure,
      const UnknownException(): UnknownFailure,
    };
    for (final MapEntry(key: exception, value: type) in cases.entries) {
      final result = await guard<int>(() async => throw exception);
      expect(result.fold((f) => f.runtimeType, (_) => null), type);
    }
  });

  test('guard turns any other error into UnknownFailure', () async {
    final result = await guard<int>(() async => throw StateError('boom'));
    final failure = (result as Err<int>).failure;
    expect(failure, isA<UnknownFailure>());
    // Users never see raw exception text.
    expect(failure.message, isNot(contains('boom')));
  });

  test('a validation failure shows the server message or a fallback', () {
    expect(const ValidationFailure('Email is taken').message, 'Email is taken');
    expect(const ValidationFailure().message, isNotEmpty);
  });

  test('fold picks the matching branch', () {
    const Result<int> ok = Ok(1);
    const Result<int> err = Err(NetworkFailure());
    expect(ok.fold((_) => 'err', (v) => 'ok $v'), 'ok 1');
    expect(err.fold((f) => f.runtimeType, (_) => null), NetworkFailure);
    expect(err.valueOrNull, isNull);
  });
}
