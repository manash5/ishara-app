// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PathDto _$PathDtoFromJson(Map<String, dynamic> json) => _PathDto(
  units: (json['units'] as List<dynamic>)
      .map((e) => PathUnitDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PathDtoToJson(_PathDto instance) => <String, dynamic>{
  'units': instance.units.map((e) => e.toJson()).toList(),
};

_PathUnitDto _$PathUnitDtoFromJson(Map<String, dynamic> json) => _PathUnitDto(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  title: json['title'] as String,
  color: json['color'] as String,
  learnedCount: (json['learnedCount'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  stops: (json['stops'] as List<dynamic>)
      .map((e) => PathStopDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PathUnitDtoToJson(_PathUnitDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'title': instance.title,
      'color': instance.color,
      'learnedCount': instance.learnedCount,
      'totalCount': instance.totalCount,
      'stops': instance.stops.map((e) => e.toJson()).toList(),
    };

_PathStopDto _$PathStopDtoFromJson(Map<String, dynamic> json) => _PathStopDto(
  id: json['id'] as String,
  type: json['type'] as String,
  state: json['state'] as String,
  title: json['title'] as String,
  lesson: json['lesson'] == null
      ? null
      : LessonSummaryDto.fromJson(json['lesson'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PathStopDtoToJson(_PathStopDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'state': instance.state,
      'title': instance.title,
      'lesson': instance.lesson?.toJson(),
    };

_LessonSummaryDto _$LessonSummaryDtoFromJson(Map<String, dynamic> json) =>
    _LessonSummaryDto(
      id: json['id'] as String,
      unitId: json['unitId'] as String,
      title: json['title'] as String,
      kind: json['kind'] as String,
      state: json['state'] as String,
      signCount: (json['signCount'] as num).toInt(),
      minutes: (json['minutes'] as num).toInt(),
    );

Map<String, dynamic> _$LessonSummaryDtoToJson(_LessonSummaryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unitId': instance.unitId,
      'title': instance.title,
      'kind': instance.kind,
      'state': instance.state,
      'signCount': instance.signCount,
      'minutes': instance.minutes,
    };
