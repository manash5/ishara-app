// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_attempt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonAttemptDto _$LessonAttemptDtoFromJson(Map<String, dynamic> json) =>
    _LessonAttemptDto(
      clientEventId: json['clientEventId'] as String,
      lessonId: json['lessonId'] as String,
      mistakes: (json['mistakes'] as num).toInt(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$LessonAttemptDtoToJson(_LessonAttemptDto instance) =>
    <String, dynamic>{
      'clientEventId': instance.clientEventId,
      'lessonId': instance.lessonId,
      'mistakes': instance.mistakes,
      'durationSeconds': instance.durationSeconds,
      'completedAt': instance.completedAt.toIso8601String(),
    };
