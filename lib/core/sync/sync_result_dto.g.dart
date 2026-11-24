// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncResponseDto _$SyncResponseDtoFromJson(Map<String, dynamic> json) =>
    _SyncResponseDto(
      results: (json['results'] as List<dynamic>)
          .map((e) => SyncResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SyncResponseDtoToJson(_SyncResponseDto instance) =>
    <String, dynamic>{'results': instance.results};

_SyncResultDto _$SyncResultDtoFromJson(Map<String, dynamic> json) =>
    _SyncResultDto(
      clientEventId: json['clientEventId'] as String,
      status: json['status'] as String,
      message: json['message'] as String?,
      result: json['result'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SyncResultDtoToJson(_SyncResultDto instance) =>
    <String, dynamic>{
      'clientEventId': instance.clientEventId,
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
