import '../../../../core/error/result.dart';
import '../entities/weekly_leaderboard.dart';
import '../repositories/leaderboard_repository.dart';

/// This week's league, cached first then refreshed (works offline).
class WatchWeeklyLeaderboard {
  const WatchWeeklyLeaderboard(this._repository);

  final LeaderboardRepository _repository;

  Stream<Result<WeeklyLeaderboard>> call() => _repository.watchWeekly();
}
