import '../../../../core/error/result.dart';
import '../entities/weekly_leaderboard.dart';
import '../repositories/leaderboard_repository.dart';

/// Loads this week's league.
class GetWeeklyLeaderboard {
  const GetWeeklyLeaderboard(this._repository);

  final LeaderboardRepository _repository;

  Future<Result<WeeklyLeaderboard>> call() =>
      _repository.getWeeklyLeaderboard();
}
