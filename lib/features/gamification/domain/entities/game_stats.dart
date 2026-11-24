import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_stats.freezed.dart';

/// What the Learn StatsBar (Figma 10:466) shows: streak, total XP, hearts.
@freezed
abstract class ProgressStats with _$ProgressStats {
  const factory ProgressStats({
    required int streakDays,
    required int totalXp,
    required int hearts,
    required int maxHearts,
  }) = _ProgressStats;
}

/// What the Streak screen (Figma 27) shows.
@freezed
abstract class StreakStats with _$StreakStats {
  const factory StreakStats({
    /// Current streak in days.
    required int days,
    required int longestDays,

    /// Streak freezes ready to use.
    required int freezes,

    /// Practised (earned XP) on each day this week, Monday first (7 values).
    required List<bool> practisedDays,

    /// Index into [practisedDays] of today (0 = Monday).
    required int todayIndex,
  }) = _StreakStats;
}
