import '../../../../core/error/result.dart';
import '../entities/weekly_leaderboard.dart';

abstract interface class LeaderboardRepository {
  /// The learner's league this week (`GET /leaderboard/weekly`).
  Future<Result<WeeklyLeaderboard>> getWeeklyLeaderboard();
}
