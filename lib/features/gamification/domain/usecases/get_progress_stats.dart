import '../../../profile/domain/entities/user_profile.dart';
import '../entities/game_stats.dart';

/// The StatsBar numbers from the learner's stats (`GET /me`); the server
/// computes them, so there is no endpoint of its own.
class GetProgressStats {
  const GetProgressStats();

  ProgressStats call(UserProfile profile) {
    final stats = profile.stats;
    return ProgressStats(
      streakDays: stats.streakDays,
      totalXp: stats.totalXp,
      hearts: stats.hearts,
      maxHearts: stats.maxHearts,
    );
  }
}
