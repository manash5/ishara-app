import 'package:freezed_annotation/freezed_annotation.dart';

import 'lesson_result_dto.dart';

part 'progress_sync_dto.freezed.dart';
part 'progress_sync_dto.g.dart';

/// `POST /progress/sync` data: one result per event, in the same order.
@freezed
abstract class ProgressSyncDto with _$ProgressSyncDto {
  const factory ProgressSyncDto({required List<SyncEventResultDto> results}) =
      _ProgressSyncDto;

  factory ProgressSyncDto.fromJson(Map<String, dynamic> json) =>
      _$ProgressSyncDtoFromJson(json);
}

/// What the server did with one queued event.
enum SyncEventStatus {
  applied,

  /// Already recorded: safe to drop.
  duplicate,

  /// Can't be applied (`message` says why): dropped, never retried.
  rejected,

  /// A status this app doesn't know yet: the event stays queued.
  unknown,
}

@freezed
abstract class SyncEventResultDto with _$SyncEventResultDto {
  const factory SyncEventResultDto({
    required String clientEventId,
    @JsonKey(unknownEnumValue: SyncEventStatus.unknown)
    required SyncEventStatus status,
    String? message,
    LessonResultDto? result,
  }) = _SyncEventResultDto;

  factory SyncEventResultDto.fromJson(Map<String, dynamic> json) =>
      _$SyncEventResultDtoFromJson(json);
}
