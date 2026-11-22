import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_leaderboard.freezed.dart';

/// This week's league (`GET /leaderboard/weekly`, Figma "15 Ranks"). Owned by
/// **ranks**. [entries] are sorted by XP, rank 1 first; the top
/// [promotionCount] move up to [nextLeagueName].
@freezed
abstract class WeeklyLeaderboard with _$WeeklyLeaderboard {
  const factory WeeklyLeaderboard({
    required String leagueName,
    required String nextLeagueName,
    required int weekNumber,
    required int learnerCount,

    /// Monday 00:00 Asia/Kathmandu, in UTC.
    required DateTime endsAt,
    required int promotionCount,

    /// XP the learner still needs, as computed by the backend.
    required int xpToPromotion,
    required List<LeaderboardEntry> entries,
  }) = _WeeklyLeaderboard;
}

/// One leaderboard row.
@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required int rank,
    required String userId,
    required String displayName,
    String? avatarUrl,
    required int xp,

    /// The signed-in learner (shown as "You").
    @Default(false) bool isMe,
  }) = _LeaderboardEntry;
}
