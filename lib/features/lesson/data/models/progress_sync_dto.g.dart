// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_sync_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgressSyncDto _$ProgressSyncDtoFromJson(Map<String, dynamic> json) =>
    _ProgressSyncDto(
      results: (json['results'] as List<dynamic>)
          .map((e) => SyncEventResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProgressSyncDtoToJson(_ProgressSyncDto instance) =>
    <String, dynamic>{'results': instance.results};

_SyncEventResultDto _$SyncEventResultDtoFromJson(Map<String, dynamic> json) =>
    _SyncEventResultDto(
      clientEventId: json['clientEventId'] as String,
      status: $enumDecode(
        _$SyncEventStatusEnumMap,
        json['status'],
        unknownValue: SyncEventStatus.unknown,
      ),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : LessonResultDto.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SyncEventResultDtoToJson(_SyncEventResultDto instance) =>
    <String, dynamic>{
      'clientEventId': instance.clientEventId,
      'status': _$SyncEventStatusEnumMap[instance.status]!,
      'message': instance.message,
      'result': instance.result,
    };

const _$SyncEventStatusEnumMap = {
  SyncEventStatus.applied: 'applied',
  SyncEventStatus.duplicate: 'duplicate',
  SyncEventStatus.rejected: 'rejected',
  SyncEventStatus.unknown: 'unknown',
};
