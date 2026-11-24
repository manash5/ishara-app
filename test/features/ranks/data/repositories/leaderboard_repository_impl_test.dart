import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';
import 'package:ishara_app/features/ranks/data/datasources/leaderboard_local_data_source.dart';
import 'package:ishara_app/features/ranks/data/datasources/leaderboard_remote_data_source.dart';
import 'package:ishara_app/features/ranks/data/models/weekly_leaderboard_dto.dart';
import 'package:ishara_app/features/ranks/data/repositories/leaderboard_repository_impl.dart';
import 'package:ishara_app/features/ranks/domain/entities/weekly_leaderboard.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

class _MockRemote extends Mock implements LeaderboardRemoteDataSource {}

class _MockLocal extends Mock implements LeaderboardLocalDataSource {}

WeeklyLeaderboardDto _board(int week) => WeeklyLeaderboardDto(
  leagueName: 'Bronze',
  nextLeagueName: 'Silver',
  weekNumber: week,
  learnerCount: 1,
  endsAt: DateTime.utc(2026, 11, 23),
  promotionCount: 5,
  xpToPromotion: 10,
  entries: const [
    LeaderboardEntryDto(rank: 1, userId: 'u', displayName: 'A', xp: 5),
  ],
);

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late LeaderboardRepositoryImpl repo;

  setUpAll(() => registerFallbackValue(_board(0)));

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repo = LeaderboardRepositoryImpl(remote, local);
    when(() => local.writeWeekly(any())).thenAnswer((_) async {});
  });

  group('lastUpdated', () {
    test('when the cached league was fetched', () {
      when(() => local.readWeekly())
          .thenReturn(CacheEntry(_board(1), DateTime.utc(2026)));
      expect(repo.lastUpdated().valueOrNull, DateTime.utc(2026));
    });

    test('an unreadable cache is an Err', () {
      when(() => local.readWeekly()).thenThrow(const CacheException());
      expect(repo.lastUpdated().isOk, isFalse);
    });
  });

  List<int> weeks(List<Result<WeeklyLeaderboard>> results) => [
    for (final r in results) r.getOrThrow().weekNumber,
  ];

  test('cache hit: emits the cache, then refreshes and rewrites it', () async {
    when(() => local.readWeekly())
        .thenReturn(CacheEntry(_board(11), DateTime.utc(2026)));
    when(() => remote.fetchWeekly()).thenAnswer((_) async => _board(12));

    final results = await repo.watchWeekly().toList();

    expect(weeks(results), [11, 12]);
    verify(() => local.writeWeekly(_board(12))).called(1);
  });

  test('cache miss: emits only the fresh league', () async {
    when(() => local.readWeekly()).thenReturn(null);
    when(() => remote.fetchWeekly()).thenAnswer((_) async => _board(12));

    expect(weeks(await repo.watchWeekly().toList()), [12]);
  });

  test('remote error with cache: keeps the cache, no error', () async {
    when(() => local.readWeekly())
        .thenReturn(CacheEntry(_board(11), DateTime.utc(2026)));
    when(() => remote.fetchWeekly()).thenThrow(const NetworkException());

    final results = await repo.watchWeekly().toList();

    expect(weeks(results), [11]);
    verifyNever(() => local.writeWeekly(any()));
  });

  test('remote error without cache: emits the failure', () async {
    when(() => local.readWeekly()).thenThrow(const CacheException());
    when(() => remote.fetchWeekly()).thenThrow(const ServerException());

    final results = await repo.watchWeekly().toList();

    expect((results.single as Err).failure, isA<ServerFailure>());
  });

  group('with the mock API and Hive', () {
    LeaderboardRepositoryImpl real([MockApiSimulation? s]) =>
        LeaderboardRepositoryImpl(
          LeaderboardRemoteDataSource(
            mockApiClient(simulation: s == null ? null : () => s),
          ),
          LeaderboardLocalDataSource(TestHive.instance),
        );

    test('maps the weekly league and caches it', () async {
      final board = (await real().watchWeekly().last).getOrThrow();
      expect(board.leagueName, 'Bronze');
      expect(board.entries.map((e) => e.rank), List.generate(10, (i) => i + 1));
      final me = board.entries.singleWhere((e) => e.isMe);
      expect((me.userId, me.xp), (FixtureIds.user, 480));
      expect(board.endsAt.isAfter(DateTime.now()), isTrue);
      expect(TestHive.instance.cache.containsKey('ranks.weekly'), isTrue);
    });

    test('offline after a fetch: serves the cached league', () async {
      await real().watchWeekly().last;

      final results = await real(MockApiSimulation.offline)
          .watchWeekly()
          .toList();

      expect(results.single.getOrThrow().leagueName, 'Bronze');
    });

    test('a 500 with nothing cached is a ServerFailure', () async {
      final result = await real(MockApiSimulation.serverError)
          .watchWeekly()
          .last;
      expect((result as Err).failure, isA<ServerFailure>());
    });
  });
}
