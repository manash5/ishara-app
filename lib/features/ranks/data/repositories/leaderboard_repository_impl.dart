import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../domain/entities/weekly_leaderboard.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_local_data_source.dart';
import '../datasources/leaderboard_remote_data_source.dart';

part 'leaderboard_repository_impl.g.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  const LeaderboardRepositoryImpl(this._remote, this._local);

  final LeaderboardRemoteDataSource _remote;
  final LeaderboardLocalDataSource _local;

  @override
  Stream<Result<WeeklyLeaderboard>> watchWeekly() async* {
    final cached = (await guard(() async => _local.readWeekly()?.value))
        .valueOrNull;
    if (cached != null) yield Ok(cached.toEntity());

    final fresh = await guard(_remote.fetchWeekly);
    switch (fresh) {
      case Ok(:final value):
        // A failed cache write must not hide fresh data.
        await guard(() => _local.writeWeekly(value));
        yield Ok(value.toEntity());
      case Err(:final failure):
        if (cached == null) yield Err(failure);
    }
  }
}

@Riverpod(keepAlive: true)
LeaderboardRepository leaderboardRepository(Ref ref) =>
    LeaderboardRepositoryImpl(
      LeaderboardRemoteDataSource(ref.watch(apiClientProvider)),
      LeaderboardLocalDataSource(ref.watch(hiveServiceProvider)),
    );
