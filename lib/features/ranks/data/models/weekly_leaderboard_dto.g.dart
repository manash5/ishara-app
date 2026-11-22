// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_leaderboard_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyLeaderboardDto _$WeeklyLeaderboardDtoFromJson(
  Map<String, dynamic> json,
) => _WeeklyLeaderboardDto(
  leagueName: json['leagueName'] as String,
  nextLeagueName: json['nextLeagueName'] as String,
  weekNumber: (json['weekNumber'] as num).toInt(),
  learnerCount: (json['learnerCount'] as num).toInt(),
  endsAt: DateTime.parse(json['endsAt'] as String),
  promotionCount: (json['promotionCount'] as num).toInt(),
  xpToPromotion: (json['xpToPromotion'] as num).toInt(),
  entries: (json['entries'] as List<dynamic>)
      .map((e) => LeaderboardEntryDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WeeklyLeaderboardDtoToJson(
  _WeeklyLeaderboardDto instance,
) => <String, dynamic>{
  'leagueName': instance.leagueName,
  'nextLeagueName': instance.nextLeagueName,
  'weekNumber': instance.weekNumber,
  'learnerCount': instance.learnerCount,
  'endsAt': instance.endsAt.toIso8601String(),
  'promotionCount': instance.promotionCount,
  'xpToPromotion': instance.xpToPromotion,
  'entries': instance.entries,
};

_LeaderboardEntryDto _$LeaderboardEntryDtoFromJson(Map<String, dynamic> json) =>
    _LeaderboardEntryDto(
      rank: (json['rank'] as num).toInt(),
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      xp: (json['xp'] as num).toInt(),
      isMe: json['isMe'] as bool? ?? false,
    );

Map<String, dynamic> _$LeaderboardEntryDtoToJson(
  _LeaderboardEntryDto instance,
) => <String, dynamic>{
  'rank': instance.rank,
  'userId': instance.userId,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'xp': instance.xp,
  'isMe': instance.isMe,
};
