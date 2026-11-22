// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignDto _$SignDtoFromJson(Map<String, dynamic> json) => _SignDto(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  status: json['status'] as String,
  videoUrl: json['videoUrl'] as String?,
  meaning: json['meaning'] as String?,
  steps:
      (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  etiquetteTip: json['etiquetteTip'] as String?,
);

Map<String, dynamic> _$SignDtoToJson(_SignDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'status': instance.status,
  'videoUrl': instance.videoUrl,
  'meaning': instance.meaning,
  'steps': instance.steps,
  'etiquetteTip': instance.etiquetteTip,
};
