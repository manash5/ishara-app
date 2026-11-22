import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/lesson_result.dart';

part 'lesson_attempt_dto.freezed.dart';
part 'lesson_attempt_dto.g.dart';

/// A finished lesson as the API receives it: the
/// `POST /lessons/:id/complete` body, or one `lessonComplete` event of
/// `POST /progress/sync` (docs/api-contract.md).
@freezed
abstract class LessonAttemptDto with _$LessonAttemptDto {
  const LessonAttemptDto._();

  const factory LessonAttemptDto({
    required String clientEventId,
    required String lessonId,
    required int mistakes,
    required int durationSeconds,
    required DateTime completedAt,
  }) = _LessonAttemptDto;

  factory LessonAttemptDto.fromJson(Map<String, dynamic> json) =>
      _$LessonAttemptDtoFromJson(json);

  factory LessonAttemptDto.fromEntity(LessonAttempt attempt) =>
      LessonAttemptDto(
        clientEventId: attempt.clientEventId,
        lessonId: attempt.lessonId,
        mistakes: attempt.mistakes,
        durationSeconds: attempt.duration.inSeconds,
        completedAt: attempt.completedAt.toUtc(),
      );

  /// `event.type` in `POST /progress/sync`.
  static const syncEventType = 'lessonComplete';

  String get _completedAtUtc => completedAt.toUtc().toIso8601String();

  /// The `POST /lessons/:id/complete` body (the lesson id is in the path).
  Map<String, Object> toCompleteBody() => {
    'clientEventId': clientEventId,
    'mistakes': mistakes,
    'durationSeconds': durationSeconds,
    'completedAt': _completedAtUtc,
  };

  /// One event of the `POST /progress/sync` body.
  Map<String, Object> toSyncEvent() => {
    'clientEventId': clientEventId,
    'type': syncEventType,
    'lessonId': lessonId,
    'mistakes': mistakes,
    'durationSeconds': durationSeconds,
    'completedAt': _completedAtUtc,
  };
}

/// An attempt waiting in the `syncQueue` Hive box (keyed by its
/// `clientEventId`) until `POST /progress/sync` accepts it.
@freezed
abstract class QueuedAttemptDto with _$QueuedAttemptDto {
  const factory QueuedAttemptDto({
    required LessonAttemptDto attempt,

    /// When it was queued (breaks ties when ordering oldest first).
    required DateTime queuedAt,

    /// Flushes that failed while it was queued.
    @Default(0) int failedFlushes,
  }) = _QueuedAttemptDto;

  factory QueuedAttemptDto.fromJson(Map<String, dynamic> json) =>
      _$QueuedAttemptDtoFromJson(json);
}
