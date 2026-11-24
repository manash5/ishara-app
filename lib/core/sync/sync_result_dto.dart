import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_result_dto.freezed.dart';
part 'sync_result_dto.g.dart';

/// `POST /progress/sync` response data (docs/api-contract.md → Progress).
@freezed
abstract class SyncResponseDto with _$SyncResponseDto {
  const factory SyncResponseDto({required List<SyncResultDto> results}) =
      _SyncResponseDto;

  factory SyncResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseDtoFromJson(json);
}

/// One event's outcome. [status] stays a string: "applied", "duplicate" or
/// "rejected" today; an unknown status keeps the event queued.
@freezed
abstract class SyncResultDto with _$SyncResultDto {
  const factory SyncResultDto({
    required String clientEventId,
    required String status,
    String? message,

    /// The event's result (a `LessonResult` for `lessonComplete`), passed on
    /// as JSON to the feature that owns it.
    Map<String, dynamic>? result,
  }) = _SyncResultDto;

  factory SyncResultDto.fromJson(Map<String, dynamic> json) =>
      _$SyncResultDtoFromJson(json);
}
