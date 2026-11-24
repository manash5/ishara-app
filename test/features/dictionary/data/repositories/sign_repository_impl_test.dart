import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';
import 'package:ishara_app/features/dictionary/data/datasources/sign_local_data_source.dart';
import 'package:ishara_app/features/dictionary/data/datasources/sign_remote_data_source.dart';
import 'package:ishara_app/features/dictionary/data/models/sign_dto.dart';
import 'package:ishara_app/features/dictionary/data/repositories/sign_repository_impl.dart';
import 'package:ishara_app/features/dictionary/domain/entities/sign.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

class _MockRemote extends Mock implements SignRemoteDataSource {}

class _MockLocal extends Mock implements SignLocalDataSource {}

const _namaste = SignDto(
  id: 'id-namaste',
  name: 'Namaste',
  category: 'greetings',
  status: 'learned',
);
const _ka = SignDto(
  id: 'id-ka',
  name: 'Ka',
  category: 'alphabet',
  status: 'new',
);
const _thanks = SignDto(
  id: 'id-thanks',
  name: 'Thank you',
  category: 'greetings',
  status: 'learned',
);

CacheEntry<List<SignDto>> _entry(List<SignDto> signs) =>
    CacheEntry(signs, DateTime.utc(2026));

List<String> _names(Result<List<Sign>> r) => [
  for (final s in r.valueOrNull ?? const <Sign>[]) s.name,
];

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late SignRepositoryImpl repo;

  setUpAll(() => registerFallbackValue(<SignDto>[]));

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repo = SignRepositoryImpl(remote, local);
    when(() => local.writeSigns(any())).thenAnswer((_) async {});
  });

  void remoteSearchThrows(AppException e) => when(
    () => remote.fetchAll(
      category: any(named: 'category'),
      search: any(named: 'search'),
    ),
  ).thenThrow(e);

  group('watchSigns', () {
    test(
      'cache hit: emits the cache, then refreshes and rewrites it',
      () async {
        when(() => local.readSigns()).thenReturn(_entry([_namaste]));
        when(() => remote.fetchAll()).thenAnswer((_) async => [_namaste, _ka]);

        final results = await repo.watchSigns().toList();

        expect(results.map(_names), [
          ['Namaste'],
          ['Namaste', 'Ka'],
        ]);
        verify(() => local.writeSigns([_namaste, _ka])).called(1);
      },
    );

    test('cache miss: emits only the fresh list', () async {
      when(() => local.readSigns()).thenReturn(null);
      when(() => remote.fetchAll()).thenAnswer((_) async => [_ka]);

      final results = await repo.watchSigns().toList();

      expect(results.map(_names), [
        ['Ka'],
      ]);
    });

    test('remote error with cache: keeps the cache, no error', () async {
      when(() => local.readSigns()).thenReturn(_entry([_namaste]));
      when(() => remote.fetchAll()).thenThrow(const NetworkException());

      final results = await repo.watchSigns().toList();

      expect(results, hasLength(1));
      expect(_names(results.single), ['Namaste']);
      verifyNever(() => local.writeSigns(any()));
    });

    test('remote error without cache: emits the failure', () async {
      when(() => local.readSigns()).thenReturn(null);
      when(() => remote.fetchAll()).thenThrow(const ServerException());

      final results = await repo.watchSigns().toList();

      expect((results.single as Err).failure, isA<ServerFailure>());
    });

    test('an unreadable cache counts as a miss', () async {
      when(() => local.readSigns()).thenThrow(const CacheException());
      when(() => remote.fetchAll()).thenAnswer((_) async => [_ka]);

      final results = await repo.watchSigns().toList();

      expect(results.map(_names), [
        ['Ka'],
      ]);
    });

    test('a failed cache write still emits the fresh list', () async {
      when(() => local.readSigns()).thenReturn(null);
      when(() => remote.fetchAll()).thenAnswer((_) async => [_ka]);
      when(() => local.writeSigns(any())).thenThrow(const CacheException());

      final results = await repo.watchSigns().toList();

      expect(_names(results.single), ['Ka']);
    });
  });

  group('searchSigns', () {
    test('online: asks the API with search and category', () async {
      when(() => remote.fetchAll(category: 'greetings', search: 'thank'))
          .thenAnswer((_) async => [_thanks]);

      final result = await repo.searchSigns(
        query: ' thank ',
        category: SignCategory.greetings,
      );

      expect(_names(result), ['Thank you']);
      verifyNever(() => local.readSigns());
    });

    test('offline: filters the cached list', () async {
      remoteSearchThrows(const NetworkException());
      when(() => local.readSigns())
          .thenReturn(_entry([_namaste, _ka, _thanks]));

      expect(_names(await repo.searchSigns(query: 'THANK')), ['Thank you']);
      expect(_names(await repo.searchSigns(category: SignCategory.greetings)), [
        'Namaste',
        'Thank you',
      ]);
      expect(
        _names(
          await repo.searchSigns(query: 'a', category: SignCategory.alphabet),
        ),
        ['Ka'],
      );
    });

    test('offline without a cache: NetworkFailure', () async {
      remoteSearchThrows(const NetworkException());
      when(() => local.readSigns()).thenReturn(null);

      final result = await repo.searchSigns(query: 'x');

      expect((result as Err).failure, isA<NetworkFailure>());
    });

    test('a server error is not hidden behind the cache', () async {
      remoteSearchThrows(const ServerException());

      final result = await repo.searchSigns(query: 'x');

      expect((result as Err).failure, isA<ServerFailure>());
      verifyNever(() => local.readSigns());
    });
  });

  group('watchSign', () {
    const detail = SignDto(
      id: 'id-namaste',
      name: 'Namaste',
      category: 'greetings',
      status: 'learned',
      videoUrl: 'https://cdn.test/namaste.mp4?sig=x',
      etiquetteTip: 'Keep eye contact.',
    );

    test('emits the cached entry, then the detail', () async {
      when(() => local.readSigns()).thenReturn(_entry([_namaste, _ka]));
      when(() => remote.fetchSign('id-namaste'))
          .thenAnswer((_) async => detail);

      final results = await repo.watchSign('id-namaste').toList();

      expect(results, hasLength(2));
      expect(results.first.valueOrNull!.etiquetteTip, isNull);
      expect(results.last.valueOrNull!.etiquetteTip, 'Keep eye contact.');
      expect(results.last.valueOrNull!.videoUrl, detail.videoUrl);
    });

    test('not cached: emits only the detail', () async {
      when(() => local.readSigns()).thenReturn(_entry([_ka]));
      when(() => remote.fetchSign('id-namaste'))
          .thenAnswer((_) async => detail);

      final results = await repo.watchSign('id-namaste').toList();

      expect(results.single.valueOrNull!.name, 'Namaste');
    });

    test('offline with a cached entry: keeps it', () async {
      when(() => local.readSigns()).thenReturn(_entry([_namaste]));
      when(() => remote.fetchSign('id-namaste'))
          .thenThrow(const NetworkException());

      final results = await repo.watchSign('id-namaste').toList();

      expect(results.single.valueOrNull!.name, 'Namaste');
    });

    test('error without a cached entry: emits the failure', () async {
      when(() => local.readSigns()).thenReturn(null);
      when(() => remote.fetchSign('id-namaste'))
          .thenThrow(const ServerException());

      final results = await repo.watchSign('id-namaste').toList();

      expect((results.single as Err).failure, isA<ServerFailure>());
    });

    test('404 is a NotFoundFailure, even after a cached entry', () async {
      when(() => local.readSigns()).thenReturn(_entry([_namaste]));
      when(() => remote.fetchSign('id-namaste'))
          .thenThrow(const NotFoundException());

      final results = await repo.watchSign('id-namaste').toList();

      expect(results, hasLength(2));
      expect((results.last as Err).failure, isA<NotFoundFailure>());
    });
  });

  group('with the mock API and Hive', () {
    SignRepositoryImpl real() => SignRepositoryImpl(
      SignRemoteDataSource(mockApiClient()),
      SignLocalDataSource(TestHive.instance),
    );

    test('fetches every page, in order, and caches them', () async {
      final signs = (await real().watchSigns().last).getOrThrow();

      expect(signs, hasLength(12));
      expect(signs.first.name, 'Namaste');
      expect(signs.last.name, 'Three');
      expect(
        SignLocalDataSource(TestHive.instance).readSigns()!.value,
        hasLength(12),
      );
    });

    test('video URLs are never cached', () async {
      when(remote.fetchAll).thenAnswer(
        (_) async => [
          _namaste.copyWith(videoUrl: 'https://cdn.test/n.mp4?sig=secret'),
        ],
      );
      final withHive = SignRepositoryImpl(
        remote,
        SignLocalDataSource(TestHive.instance),
      );

      final fresh = (await withHive.watchSigns().last).getOrThrow();

      // The fresh list keeps the URL for playback; the cache never does.
      expect(fresh.single.videoUrl, isNotNull);
      final raw = TestHive.instance.cache.get(SignLocalDataSource.cacheKey);
      expect(raw, isNotNull);
      expect('$raw', isNot(contains('cdn.test')));
    });

    test('an unknown sign is a NotFoundFailure', () async {
      final result = await real()
          .watchSign('00000000-0000-4000-8000-000000000000')
          .last;
      expect((result as Err).failure, isA<NotFoundFailure>());
    });

    test('the Namaste detail has its tip and no invented NSL text', () async {
      final namaste = (await real().watchSign(FixtureIds.namaste).last)
          .getOrThrow();
      expect(namaste.category, SignCategory.greetings);
      expect(namaste.etiquetteTip, isNotNull);
      expect(namaste.meaning, isNull);
      expect(namaste.steps, isEmpty);
    });
  });
}
