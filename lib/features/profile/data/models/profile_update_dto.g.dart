// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileUpdateDto _$ProfileUpdateDtoFromJson(Map<String, dynamic> json) =>
    _ProfileUpdateDto(
      displayName: json['displayName'] as String?,
      dailyGoalMinutes: (json['dailyGoalMinutes'] as num?)?.toInt(),
      dominantHand: json['dominantHand'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$ProfileUpdateDtoToJson(_ProfileUpdateDto instance) =>
    <String, dynamic>{
      'displayName': ?instance.displayName,
      'dailyGoalMinutes': ?instance.dailyGoalMinutes,
      'dominantHand': ?instance.dominantHand,
      'timezone': ?instance.timezone,
    };
