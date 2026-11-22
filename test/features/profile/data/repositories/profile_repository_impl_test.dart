import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:ishara_app/features/profile/data/models/profile_update_dto.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';
import 'package:ishara_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ishara_app/features/profile/domain/entities/profile_update.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

class MockRemote extends Mock implements ProfileRemoteDataSource {}

class MockLocal extends Mock implements ProfileLocalDataSource {}

void main() {
  final fresh = UserProfileDto.fromJson(
    fixtureData<Map<String, dynamic>>('me/get_200'),
  );
  final cached = fresh.copyWith(displayName: 'Cached name');

  late MockRemote remote;
  late MockLocal local;
  late ProfileRepositoryImpl repo;
  late StreamController<UserProfileDto> changes;

  setUpAll(() {
    registerFallbackValue(fresh);
    registerFallbackValue(const ProfileUpdateDto());
  });

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    changes = StreamController<UserProfileDto>.broadcast();
    addTearDown(changes.close);
    when(() => local.write(any())).thenAnswer((_) async {});
    when(() => local.clear()).thenAnswer((_) async {});
    when(() => local.changes()).thenAnswer((_) => changes.stream);
    repo = ProfileRepositoryImpl(remote, local);
  });

  Future<List<Result<UserProfile>>> firstResults(int count) =>
      repo.watchProfile().take(count).toList();

  group('watchProfile (cache-first)', () {
    test('cache hit: cached, then fresh (written to the cache)', () async {
      when(() => local.read())
          .thenReturn(CacheEntry(cached, DateTime.utc(2026)));
      when(() => remote.fetchProfile()).thenAnswer((_) async => fresh);

      final results = await firstResults(2);

      expect(results.map((r) => r.valueOrNull?.displayName), [
        'Cached name',
        'Manash Lamichhane',
      ]);
      verify(() => local.write(fresh)).called(1);
    });

    test('cache miss: only the fresh profile', () async {
      when(() => local.read()).thenReturn(null);
      when(() => remote.fetchProfile()).thenAnswer((_) async => fresh);
      final results = await firstResults(1);
      expect(results.single.valueOrNull?.id, FixtureIds.user);
    });

    test('remote error with cache: the cache only, no error', () async {
      when(() => local.read())
          .thenReturn(CacheEntry(cached, DateTime.utc(2026)));
      when(() => remote.fetchProfile()).thenThrow(const NetworkException());

      final results = <Result<UserProfile>>[];
      final sub = repo.watchProfile().listen(results.add);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(results, hasLength(1));
      expect(results.single.valueOrNull?.displayName, 'Cached name');
    });

    test('remote error without cache: one Err, then done', () async {
      when(() => local.read()).thenReturn(null);
      when(() => remote.fetchProfile()).thenThrow(const ServerException(500));
      final results = await repo.watchProfile().toList();
      expect(results, hasLength(1));
      expect((results.single as Err).failure, isA<ServerFailure>());
    });

    test('an unreadable cache counts as a miss', () async {
      when(() => local.read()).thenThrow(const CacheException());
      when(() => remote.fetchProfile()).thenAnswer((_) async => fresh);
      expect((await firstResults(1)).single.isOk, isTrue);
    });

    test('later cache writes are yielded', () async {
      when(() => local.read()).thenReturn(null);
      when(() => remote.fetchProfile()).thenAnswer((_) async => fresh);
      final future = firstResults(2);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      changes.add(fresh.copyWith(dailyGoalMinutes: 20));
      final results = await future;
      expect(results.last.valueOrNull?.dailyGoalMinutes, 20);
    });
  });

  test('cachedProfile reads the cache', () async {
    when(() => local.read()).thenReturn(CacheEntry(cached, DateTime.utc(2026)));
    expect(
      (await repo.cachedProfile()).valueOrNull?.displayName,
      'Cached name',
    );
  });

  test('updateProfile sends only changed fields and caches', () async {
    when(() => remote.updateProfile(any()))
        .thenAnswer((_) async => fresh.copyWith(dailyGoalMinutes: 15));
    final result = await repo.updateProfile(
      const ProfileUpdate(dailyGoalMinutes: 15, dominantHand: Hand.left),
    );
    expect(result.valueOrNull?.dailyGoalMinutes, 15);
    final sent =
        verify(() => remote.updateProfile(captureAny())).captured.single
            as ProfileUpdateDto;
    expect(sent.toJson(), {'dailyGoalMinutes': 15, 'dominantHand': 'left'});
    verify(() => local.write(any())).called(1);
  });

  test('deleteAccount clears the cached profile', () async {
    when(() => remote.deleteAccount()).thenAnswer((_) async {});
    expect((await repo.deleteAccount()).isOk, isTrue);
    verify(() => local.clear()).called(1);
  });

  test('deleteAccount failure keeps the cache', () async {
    when(() => remote.deleteAccount()).thenThrow(const NetworkException());
    final result = await repo.deleteAccount();
    expect((result as Err).failure, isA<NetworkFailure>());
    verifyNever(() => local.clear());
  });

  group('against the mock API and test Hive', () {
    ProfileRepositoryImpl real([MockApiSimulation? s]) => ProfileRepositoryImpl(
      ProfileRemoteDataSource(
        mockApiClient(simulation: s == null ? null : () => s),
      ),
      ProfileLocalDataSource(TestHive.instance),
    );

    test('maps /me to a UserProfile and caches it', () async {
      final profile = (await real().getProfile()).getOrThrow();
      expect(profile.id, FixtureIds.user);
      expect(profile.displayName, 'Manash Lamichhane');
      expect(profile.dominantHand, Hand.right);
      expect(profile.stats.totalXp, 1240);
      expect(profile.stats.weekXp, [30, 55, 20, 70, 45, 4, 62]);
      expect(profile.stats.todayIndex, 6);
      final cachedProfile = ProfileLocalDataSource(TestHive.instance).read();
      expect(cachedProfile?.value.toEntity(), profile);
    });

    test('PUT /me echoes the change', () async {
      final result = await real().updateProfile(
        const ProfileUpdate(dailyGoalMinutes: 20),
      );
      expect(result.valueOrNull?.dailyGoalMinutes, 20);
    });

    test('failures come back as Err, never thrown', () async {
      final offline = await real(MockApiSimulation.offline).getProfile();
      expect((offline as Err).failure, isA<NetworkFailure>());
      final server = await real(MockApiSimulation.serverError).getProfile();
      expect((server as Err).failure, isA<ServerFailure>());
    });
  });
}
