import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_profile.dart';

part 'user_profile_dto.freezed.dart';
part 'user_profile_dto.g.dart';

/// `/me` profile JSON (docs/api-contract.md → Profile).
@freezed
abstract class UserProfileDto with _$UserProfileDto {
  const UserProfileDto._();

  const factory UserProfileDto({
    required String id,
    required String email,
    required String displayName,
    String? avatarUrl,
    required DateTime joinedAt,
    required bool onboardingDone,
    required int dailyGoalMinutes,
    required String dominantHand,
    required String timezone,
    required UserStatsDto stats,
  }) = _UserProfileDto;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  UserProfile toEntity() => UserProfile(
    id: id,
    email: email,
    displayName: displayName,
    avatarUrl: avatarUrl,
    joinedAt: joinedAt,
    onboardingDone: onboardingDone,
    dailyGoalMinutes: dailyGoalMinutes,
    dominantHand: dominantHand == 'left' ? Hand.left : Hand.right,
    timezone: timezone,
    stats: stats.toEntity(),
  );
}

@freezed
abstract class UserStatsDto with _$UserStatsDto {
  const UserStatsDto._();

  const factory UserStatsDto({
    required int totalXp,
    required int weeklyXp,
    required int streakDays,
    required int longestStreakDays,
    required int streakFreezes,
    required int hearts,
    required int maxHearts,
    DateTime? heartsRefillAt,
    required int signsLearned,
    required double cameraAccuracy,
    required DateTime weekStart,
    required List<int> weekXp,
    required int todayIndex,
  }) = _UserStatsDto;

  factory UserStatsDto.fromJson(Map<String, dynamic> json) =>
      _$UserStatsDtoFromJson(json);

  UserStats toEntity() => UserStats(
    totalXp: totalXp,
    weeklyXp: weeklyXp,
    streakDays: streakDays,
    longestStreakDays: longestStreakDays,
    streakFreezes: streakFreezes,
    hearts: hearts,
    maxHearts: maxHearts,
    heartsRefillAt: heartsRefillAt,
    signsLearned: signsLearned,
    cameraAccuracy: cameraAccuracy,
    weekStart: weekStart,
    weekXp: weekXp,
    todayIndex: todayIndex,
  );
}
