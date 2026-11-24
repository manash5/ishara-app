import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// The hand a learner signs with (mirrors the camera, picks reference videos).
enum Hand { left, right }

/// The learner (`GET /me`). Owned by **profile**; also used by auth (the
/// session user), onboarding, learn (StatsBar), lesson (starting hearts),
/// gamification (streak) and settings.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String displayName,
    String? avatarUrl,
    required DateTime joinedAt,
    required bool onboardingDone,
    required int dailyGoalMinutes,
    required Hand dominantHand,
    required String timezone,
    required UserStats stats,
  }) = _UserProfile;
}

/// Progress numbers the server computes (game-rules.md).
@freezed
abstract class UserStats with _$UserStats {
  const UserStats._();

  const factory UserStats({
    required int totalXp,

    /// XP this league week (Monday 00:00 Asia/Kathmandu).
    required int weeklyXp,
    required int streakDays,
    required int longestStreakDays,
    required int streakFreezes,
    required int hearts,
    required int maxHearts,

    /// When the next heart refills; null when hearts are full.
    DateTime? heartsRefillAt,
    required int signsLearned,

    /// 0–1 share of camera exercises signed correctly.
    required double cameraAccuracy,

    /// Monday of the current week, in the learner's timezone.
    required DateTime weekStart,

    /// XP per day this week, Monday first (7 values).
    required List<int> weekXp,

    /// Index into [weekXp] of today (0 = Monday).
    required int todayIndex,
  }) = _UserStats;

  /// Whether the learner practised on each day this week (XP > 0).
  List<bool> get practisedDays => [for (final xp in weekXp) xp > 0];
}
