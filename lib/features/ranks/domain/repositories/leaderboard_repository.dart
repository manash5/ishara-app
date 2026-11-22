import '../../../../core/error/result.dart';
import '../entities/weekly_leaderboard.dart';

abstract interface class LeaderboardRepository {
  /// The learner's league this week (`GET /leaderboard/weekly`).
  /// Cache-first: emits the cached league (if any), then the fresh one. If
  /// the refresh fails it emits the failure only when nothing was cached.
  Stream<Result<WeeklyLeaderboard>> watchWeekly();

  /// When the cached league was fetched, or null if nothing is cached.
  Result<DateTime?> lastUpdated();
}
