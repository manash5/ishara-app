import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/dictionary/data/repositories/sign_repository_impl.dart';
import 'package:ishara_app/features/dictionary/domain/repositories/sign_repository.dart';
import 'package:ishara_app/features/dictionary/presentation/providers/dictionary_models.dart';
import 'package:ishara_app/features/dictionary/presentation/providers/dictionary_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignRepository extends Mock implements SignRepository {}

const _namaste = Sign(
  id: 'id-namaste',
  name: 'Namaste',
  category: SignCategory.greetings,
  status: SignStatus.learned,
);
const _ka = Sign(
  id: 'id-ka',
  name: 'Ka',
  category: SignCategory.alphabet,
  status: SignStatus.newSign,
);

void main() {
  late _MockSignRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockSignRepository();
    container = ProviderContainer(
      overrides: [signRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  /// Listens to [provider] and lets its stream deliver.
  Future<void> settle<T>(ProviderListenable<T> provider) async {
    container.listen(provider, (_, _) {});
    await pumpEventQueue();
  }

  group('dictionarySigns', () {
    test('shows the cache, then the fresh list', () async {
      final controller = StreamController<Result<List<Sign>>>();
      addTearDown(controller.close);
      when(() => repository.watchSigns()).thenAnswer((_) => controller.stream);
      await settle(dictionarySignsProvider);

      controller.add(const Ok([_namaste]));
      await pumpEventQueue();
      expect(container.read(dictionarySignsProvider).value, [_namaste]);

      controller.add(const Ok([_namaste, _ka]));
      await pumpEventQueue();
      expect(container.read(dictionarySignsProvider).value, [_namaste, _ka]);
    });

    test('a failure becomes an AsyncError carrying the Failure', () async {
      when(() => repository.watchSigns())
          .thenAnswer((_) => Stream.value(const Err(NetworkFailure())));
      await settle(dictionarySignsProvider);

      expect(
        container.read(dictionarySignsProvider).error,
        isA<NetworkFailure>(),
      );
      expect(
        container.read(filteredDictionarySignsProvider).error,
        isA<NetworkFailure>(),
      );
    });
  });

  group('filteredDictionarySigns', () {
    setUp(() {
      when(() => repository.watchSigns())
          .thenAnswer((_) => Stream.value(const Ok([_namaste, _ka])));
    });

    List<String> names() => [
      for (final s in container.read(filteredDictionarySignsProvider).value!)
        s.name,
    ];

    test('searches, filters and sorts locally', () async {
      await settle(filteredDictionarySignsProvider);
      expect(names(), ['Namaste', 'Ka']);

      container.read(dictionarySortAlphabeticalProvider.notifier).toggle();
      expect(names(), ['Ka', 'Namaste']);

      container.read(dictionaryQueryProvider.notifier).setQuery(' NAM ');
      expect(names(), ['Namaste']);

      container.read(dictionaryQueryProvider.notifier).setQuery('');
      container
          .read(dictionaryCategoryProvider.notifier)
          .select(SignCategory.alphabet);
      expect(names(), ['Ka']);

      // Local only: one load, no search requests.
      verify(() => repository.watchSigns()).called(1);
      verifyNever(
        () => repository.searchSigns(
          query: any(named: 'query'),
          category: any(named: 'category'),
        ),
      );
    });

    test('is loading while the list loads', () {
      when(() => repository.watchSigns())
          .thenAnswer((_) => const Stream.empty());
      expect(container.read(filteredDictionarySignsProvider).isLoading, true);
    });
  });

  group('signDetail', () {
    test('maps the sign, then its fresher detail', () async {
      when(() => repository.watchSign('id-namaste')).thenAnswer(
        (_) => Stream.fromIterable([
          const Ok(_namaste),
          Ok(_namaste.copyWith(etiquetteTip: 'Tip')),
        ]),
      );
      await settle(signDetailProvider('id-namaste'));

      final detail = container.read(signDetailProvider('id-namaste')).value!;
      expect(detail.sign.name, 'Namaste');
      expect(detail.etiquetteTip, 'Tip');
    });

    test('NotFoundFailure is data null ("Sign not found")', () async {
      when(() => repository.watchSign('x'))
          .thenAnswer((_) => Stream.value(const Err(NotFoundFailure())));
      await settle(signDetailProvider('x'));

      final value = container.read(signDetailProvider('x'));
      expect(value.hasValue, isTrue);
      expect(value.value, isNull);
    });

    test('other failures are errors', () async {
      when(() => repository.watchSign('x'))
          .thenAnswer((_) => Stream.value(const Err(ServerFailure())));
      await settle(signDetailProvider('x'));

      expect(
        container.read(signDetailProvider('x')).error,
        isA<ServerFailure>(),
      );
    });
  });
}
