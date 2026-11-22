// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonResultDto _$LessonResultDtoFromJson(Map<String, dynamic> json) =>
    _LessonResultDto(
      lessonId: json['lessonId'] as String,
      clientEventId: json['clientEventId'] as String,
      xpEarned: (json['xpEarned'] as num).toInt(),
      accuracy: (json['accuracy'] as num).toDouble(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      newSignCount: (json['newSignCount'] as num).toInt(),
      signs: (json['signs'] as List<dynamic>)
          .map((e) => SignDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      streakExtended: json['streakExtended'] as bool,
      streakDays: (json['streakDays'] as num).toInt(),
      hearts: (json['hearts'] as num).toInt(),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$LessonResultDtoToJson(_LessonResultDto instance) =>
    <String, dynamic>{
      'lessonId': instance.lessonId,
      'clientEventId': instance.clientEventId,
      'xpEarned': instance.xpEarned,
      'accuracy': instance.accuracy,
      'durationSeconds': instance.durationSeconds,
      'newSignCount': instance.newSignCount,
      'signs': instance.signs,
      'streakExtended': instance.streakExtended,
      'streakDays': instance.streakDays,
      'hearts': instance.hearts,
      'completedAt': instance.completedAt.toIso8601String(),
    };
