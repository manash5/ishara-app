import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/learn/domain/entities/path_unit.dart';
import 'package:ishara_app/features/learn/domain/repositories/path_repository.dart';
import 'package:ishara_app/features/learn/domain/usecases/watch_path.dart';
import 'package:mocktail/mocktail.dart';

class MockPathRepository extends Mock implements PathRepository {}

void main() {
  test('passes on every result the repository emits', () async {
    final repository = MockPathRepository();
    const unit = PathUnit(
      id: 'u1',
      number: 1,
      title: 'Greetings',
      tint: UnitTint.teal,
      learnedCount: 0,
      totalCount: 1,
      stops: [],
    );
    when(repository.watchPath).thenAnswer(
      (_) => Stream.fromIterable([
        const Ok([unit]),
        const Err(NetworkFailure()),
      ]),
    );

    final results = await WatchPath(repository)().toList();

    expect(results.first.valueOrNull, [unit]);
    expect((results.last as Err).failure, isA<NetworkFailure>());
    verify(repository.watchPath).called(1);
  });
}
