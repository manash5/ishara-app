import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../domain/entities/weekly_leaderboard.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_remote_data_source.dart';

part 'leaderboard_repository_impl.g.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  const LeaderboardRepositoryImpl(this._remote);

  final LeaderboardRemoteDataSource _remote;

  @override
  Future<Result<WeeklyLeaderboard>> getWeeklyLeaderboard() =>
      guard(() async => (await _remote.fetchWeekly()).toEntity());
}

@Riverpod(keepAlive: true)
LeaderboardRepository leaderboardRepository(Ref ref) =>
    LeaderboardRepositoryImpl(
      LeaderboardRemoteDataSource(ref.watch(apiClientProvider)),
    );
