import '../../../profile/domain/entities/user_profile.dart';
import '../entities/game_stats.dart';

/// The streak from the learner's stats (`GET /me`); a day counts as
/// practised when it earned XP.
class GetStreakStats {
  const GetStreakStats();

  StreakStats call(UserProfile profile) {
    final stats = profile.stats;
    return StreakStats(
      days: stats.streakDays,
      longestDays: stats.longestStreakDays,
      freezes: stats.streakFreezes,
      practisedDays: stats.practisedDays,
      todayIndex: stats.todayIndex,
    );
  }
}
