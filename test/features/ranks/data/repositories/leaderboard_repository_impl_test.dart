import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/ranks/data/datasources/leaderboard_remote_data_source.dart';
import 'package:ishara_app/features/ranks/data/repositories/leaderboard_repository_impl.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  LeaderboardRepositoryImpl repo([MockApiSimulation? s]) =>
      LeaderboardRepositoryImpl(
        LeaderboardRemoteDataSource(
          mockApiClient(simulation: s == null ? null : () => s),
        ),
      );

  test('maps the weekly league', () async {
    final board = (await repo().getWeeklyLeaderboard()).getOrThrow();
    expect(board.leagueName, 'Bronze');
    expect(board.entries.map((e) => e.rank), List.generate(10, (i) => i + 1));
    final me = board.entries.singleWhere((e) => e.isMe);
    expect((me.userId, me.xp), (FixtureIds.user, 480));
    expect(board.endsAt.isAfter(DateTime.now()), isTrue);
  });

  test('a 500 is a ServerFailure', () async {
    final result = await repo(MockApiSimulation.serverError)
        .getWeeklyLeaderboard();
    expect((result as Err).failure, isA<ServerFailure>());
  });
}
