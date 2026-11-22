// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonDto _$LessonDtoFromJson(Map<String, dynamic> json) => _LessonDto(
  lesson: LessonSummaryDto.fromJson(json['lesson'] as Map<String, dynamic>),
  exercises: (json['exercises'] as List<dynamic>)
      .map((e) => ExerciseDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LessonDtoToJson(_LessonDto instance) =>
    <String, dynamic>{
      'lesson': instance.lesson,
      'exercises': instance.exercises,
    };

WatchExerciseDto _$WatchExerciseDtoFromJson(Map<String, dynamic> json) =>
    WatchExerciseDto(
      signId: json['signId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tip: json['tip'] as String,
      verified: json['verified'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$WatchExerciseDtoToJson(WatchExerciseDto instance) =>
    <String, dynamic>{
      'signId': instance.signId,
      'title': instance.title,
      'description': instance.description,
      'tip': instance.tip,
      'verified': instance.verified,
      'type': instance.$type,
    };

RecogniseExerciseDto _$RecogniseExerciseDtoFromJson(
  Map<String, dynamic> json,
) => RecogniseExerciseDto(
  signId: json['signId'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  answerIndex: (json['answerIndex'] as num).toInt(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$RecogniseExerciseDtoToJson(
  RecogniseExerciseDto instance,
) => <String, dynamic>{
  'signId': instance.signId,
  'options': instance.options,
  'answerIndex': instance.answerIndex,
  'type': instance.$type,
};

PickSignExerciseDto _$PickSignExerciseDtoFromJson(Map<String, dynamic> json) =>
    PickSignExerciseDto(
      signId: json['signId'] as String,
      meaning: json['meaning'] as String,
      answerIndex: (json['answerIndex'] as num).toInt(),
      optionCount: (json['optionCount'] as num?)?.toInt() ?? 4,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$PickSignExerciseDtoToJson(
  PickSignExerciseDto instance,
) => <String, dynamic>{
  'signId': instance.signId,
  'meaning': instance.meaning,
  'answerIndex': instance.answerIndex,
  'optionCount': instance.optionCount,
  'type': instance.$type,
};

MatchPairsExerciseDto _$MatchPairsExerciseDtoFromJson(
  Map<String, dynamic> json,
) => MatchPairsExerciseDto(
  signId: json['signId'] as String,
  words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
  videoOrder: (json['videoOrder'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$MatchPairsExerciseDtoToJson(
  MatchPairsExerciseDto instance,
) => <String, dynamic>{
  'signId': instance.signId,
  'words': instance.words,
  'videoOrder': instance.videoOrder,
  'type': instance.$type,
};

SignItExerciseDto _$SignItExerciseDtoFromJson(Map<String, dynamic> json) =>
    SignItExerciseDto(
      signId: json['signId'] as String,
      title: json['title'] as String,
      almostChip: json['almostChip'] as String,
      almostHint: json['almostHint'] as String,
      fallback: ExerciseDto.fromJson(json['fallback'] as Map<String, dynamic>),
      verified: json['verified'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$SignItExerciseDtoToJson(SignItExerciseDto instance) =>
    <String, dynamic>{
      'signId': instance.signId,
      'title': instance.title,
      'almostChip': instance.almostChip,
      'almostHint': instance.almostHint,
      'fallback': instance.fallback,
      'verified': instance.verified,
      'type': instance.$type,
    };

FingerspellExerciseDto _$FingerspellExerciseDtoFromJson(
  Map<String, dynamic> json,
) => FingerspellExerciseDto(
  signId: json['signId'] as String,
  letters: (json['letters'] as List<dynamic>).map((e) => e as String).toList(),
  meaning: json['meaning'] as String,
  fallback: ExerciseDto.fromJson(json['fallback'] as Map<String, dynamic>),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$FingerspellExerciseDtoToJson(
  FingerspellExerciseDto instance,
) => <String, dynamic>{
  'signId': instance.signId,
  'letters': instance.letters,
  'meaning': instance.meaning,
  'fallback': instance.fallback,
  'type': instance.$type,
};
