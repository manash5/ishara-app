import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';
import 'package:ishara_app/features/learn/data/datasources/path_local_data_source.dart';
import 'package:ishara_app/features/learn/data/datasources/path_remote_data_source.dart';
import 'package:ishara_app/features/learn/data/models/path_dto.dart';
import 'package:ishara_app/features/learn/data/repositories/path_repository_impl.dart';
import 'package:ishara_app/features/learn/domain/entities/lesson_summary.dart';
import 'package:ishara_app/features/learn/domain/entities/path_unit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

class MockRemote extends Mock implements PathRemoteDataSource {}

class MockLocal extends Mock implements PathLocalDataSource {}

PathDto unitDto(String title) => PathDto(
  units: [
    PathUnitDto(
      id: 'u-$title',
      number: 1,
      title: title,
      color: 'teal',
      learnedCount: 0,
      totalCount: 0,
      stops: const [],
    ),
  ],
);

void main() {
  setUpAll(() => registerFallbackValue(unitDto('fallback')));

  group('cache first (mocked data sources)', () {
    late MockRemote remote;
    late MockLocal local;
    late PathRepositoryImpl repository;

    setUp(() {
      remote = MockRemote();
      local = MockLocal();
      repository = PathRepositoryImpl(remote, local);
      when(() => local.savePath(any())).thenAnswer((_) async {});
      when(local.clear).thenAnswer((_) async {});
    });

    List<String?> titles(List<Result<List<PathUnit>>> results) => [
      for (final r in results) r.valueOrNull?.single.title,
    ];

    test('cache hit: the cached path, then the fresh one (saved)', () async {
      when(local.readPath)
          .thenReturn(CacheEntry(unitDto('cached'), DateTime.utc(2026)));
      when(remote.fetchPath).thenAnswer((_) async => unitDto('fresh'));

      final results = await repository.watchPath().toList();

      expect(titles(results), ['cached', 'fresh']);
      verify(() => local.savePath(unitDto('fresh'))).called(1);
    });

    test('cache miss: only the fresh path, which is saved', () async {
      when(local.readPath).thenReturn(null);
      when(remote.fetchPath).thenAnswer((_) async => unitDto('fresh'));

      final results = await repository.watchPath().toList();

      expect(titles(results), ['fresh']);
      verify(() => local.savePath(unitDto('fresh'))).called(1);
    });

    test('remote error with a cache: the cache only, no error', () async {
      when(local.readPath)
          .thenReturn(CacheEntry(unitDto('cached'), DateTime.utc(2026)));
      when(remote.fetchPath).thenThrow(const NetworkException());

      final results = await repository.watchPath().toList();

      expect(titles(results), ['cached']);
      expect(results.every((r) => r.isOk), isTrue);
      verifyNever(() => local.savePath(any()));
    });

    test('remote error without a cache: the Failure', () async {
      when(local.readPath).thenReturn(null);
      when(remote.fetchPath).thenThrow(const NetworkException());

      final results = await repository.watchPath().toList();

      expect(results, hasLength(1));
      expect((results.single as Err).failure, isA<NetworkFailure>());
    });

    test('an unreadable cache counts as a miss and is dropped', () async {
      when(local.readPath).thenThrow(const CacheException());
      when(remote.fetchPath).thenThrow(const ServerException());

      final results = await repository.watchPath().toList();

      expect((results.single as Err).failure, isA<ServerFailure>());
      verify(local.clear).called(1);
    });

    test('a failed cache write still returns the fresh path', () async {
      when(local.readPath).thenReturn(null);
      when(remote.fetchPath).thenAnswer((_) async => unitDto('fresh'));
      when(() => local.savePath(any())).thenThrow(const CacheException());

      final results = await repository.watchPath().toList();

      expect(titles(results), ['fresh']);
    });
  });

  group('over the mock API and test Hive', () {
    PathRepositoryImpl repo([MockApiSimulation? s]) => PathRepositoryImpl(
      PathRemoteDataSource(
        mockApiClient(simulation: s == null ? null : () => s),
      ),
      PathLocalDataSource(TestHive.instance),
    );

    test('maps /path to units and stops, and caches it', () async {
      final units = (await repo().watchPath().last).getOrThrow();
      expect(units.map((u) => u.tint), [
        UnitTint.teal,
        UnitTint.lavender,
        UnitTint.mint,
        UnitTint.lime,
      ]);
      final current = units.first.stops.singleWhere(
        (s) => s.state == LessonState.current,
      );
      expect(current.lesson!.id, FixtureIds.currentLesson);
      expect(current.title, 'Thank you');
      final chest = units.first.stops.firstWhere(
        (s) => s.type == StopType.chest,
      );
      expect(chest.lesson, isNull);

      // Offline afterwards: the cached path, and no error.
      final offline = await repo(MockApiSimulation.offline)
          .watchPath()
          .toList();
      expect(offline, hasLength(1));
      expect(offline.single.getOrThrow(), units);
    });

    test('a 404 is a NotFoundFailure', () async {
      final result = await repo(MockApiSimulation.notFound).watchPath().last;
      expect((result as Err).failure, isA<NotFoundFailure>());
    });
  });
}
