import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/dictionary/domain/entities/sign.dart';
import 'package:ishara_app/features/dictionary/domain/repositories/sign_repository.dart';
import 'package:ishara_app/features/dictionary/domain/usecases/search_signs.dart';
import 'package:ishara_app/features/dictionary/domain/usecases/watch_sign.dart';
import 'package:ishara_app/features/dictionary/domain/usecases/watch_signs.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignRepository extends Mock implements SignRepository {}

const _namaste = Sign(
  id: 'id-1',
  name: 'Namaste',
  category: SignCategory.greetings,
  status: SignStatus.learned,
);

void main() {
  late _MockSignRepository repository;

  setUp(() => repository = _MockSignRepository());

  test('WatchSigns streams the repository list', () async {
    when(() => repository.watchSigns()).thenAnswer(
      (_) => Stream.fromIterable([
        const Ok([_namaste]),
        const Ok(<Sign>[]),
      ]),
    );
    final results = await WatchSigns(repository)().toList();
    expect(results.map((r) => r.valueOrNull), [
      [_namaste],
      <Sign>[],
    ]);
  });

  test('SearchSigns trims the query and passes the category', () async {
    when(
      () => repository.searchSigns(
        query: any(named: 'query'),
        category: any(named: 'category'),
      ),
    ).thenAnswer((_) async => const Ok([_namaste]));

    final result = await SearchSigns(repository)(
      query: '  nam ',
      category: SignCategory.greetings,
    );

    expect(result.valueOrNull, [_namaste]);
    verify(
      () => repository.searchSigns(
        query: 'nam',
        category: SignCategory.greetings,
      ),
    ).called(1);
  });

  test('WatchSign streams one sign, failures included', () async {
    when(() => repository.watchSign('id-1')).thenAnswer(
      (_) => Stream.fromIterable([
        const Ok(_namaste),
        const Err(NotFoundFailure()),
      ]),
    );
    final results = await WatchSign(repository)('id-1').toList();
    expect(results.first.valueOrNull, _namaste);
    expect((results.last as Err).failure, isA<NotFoundFailure>());
  });
}
