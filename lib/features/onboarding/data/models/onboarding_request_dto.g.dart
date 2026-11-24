// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingRequestDto _$OnboardingRequestDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingRequestDto(
  dailyGoalMinutes: (json['dailyGoalMinutes'] as num).toInt(),
  dominantHand: json['dominantHand'] as String,
  timezone: json['timezone'] as String,
);

Map<String, dynamic> _$OnboardingRequestDtoToJson(
  _OnboardingRequestDto instance,
) => <String, dynamic>{
  'dailyGoalMinutes': instance.dailyGoalMinutes,
  'dominantHand': instance.dominantHand,
  'timezone': instance.timezone,
};
