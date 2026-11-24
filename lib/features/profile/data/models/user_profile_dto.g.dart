// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileDto _$UserProfileDtoFromJson(Map<String, dynamic> json) =>
    _UserProfileDto(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      onboardingDone: json['onboardingDone'] as bool,
      dailyGoalMinutes: (json['dailyGoalMinutes'] as num).toInt(),
      dominantHand: json['dominantHand'] as String,
      timezone: json['timezone'] as String,
      stats: UserStatsDto.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileDtoToJson(_UserProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'onboardingDone': instance.onboardingDone,
      'dailyGoalMinutes': instance.dailyGoalMinutes,
      'dominantHand': instance.dominantHand,
      'timezone': instance.timezone,
      'stats': instance.stats,
    };

_UserStatsDto _$UserStatsDtoFromJson(Map<String, dynamic> json) =>
    _UserStatsDto(
      totalXp: (json['totalXp'] as num).toInt(),
      weeklyXp: (json['weeklyXp'] as num).toInt(),
      streakDays: (json['streakDays'] as num).toInt(),
      longestStreakDays: (json['longestStreakDays'] as num).toInt(),
      streakFreezes: (json['streakFreezes'] as num).toInt(),
      hearts: (json['hearts'] as num).toInt(),
      maxHearts: (json['maxHearts'] as num).toInt(),
      heartsRefillAt: json['heartsRefillAt'] == null
          ? null
          : DateTime.parse(json['heartsRefillAt'] as String),
      signsLearned: (json['signsLearned'] as num).toInt(),
      cameraAccuracy: (json['cameraAccuracy'] as num).toDouble(),
      weekStart: DateTime.parse(json['weekStart'] as String),
      weekXp: (json['weekXp'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      todayIndex: (json['todayIndex'] as num).toInt(),
    );

Map<String, dynamic> _$UserStatsDtoToJson(_UserStatsDto instance) =>
    <String, dynamic>{
      'totalXp': instance.totalXp,
      'weeklyXp': instance.weeklyXp,
      'streakDays': instance.streakDays,
      'longestStreakDays': instance.longestStreakDays,
      'streakFreezes': instance.streakFreezes,
      'hearts': instance.hearts,
      'maxHearts': instance.maxHearts,
      'heartsRefillAt': instance.heartsRefillAt?.toIso8601String(),
      'signsLearned': instance.signsLearned,
      'cameraAccuracy': instance.cameraAccuracy,
      'weekStart': instance.weekStart.toIso8601String(),
      'weekXp': instance.weekXp,
      'todayIndex': instance.todayIndex,
    };
