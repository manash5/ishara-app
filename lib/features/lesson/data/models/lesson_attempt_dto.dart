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

  String get _completedAtUtc => completedAt.toUtc().toIso8601String();

  /// The `POST /lessons/:id/complete` body (the lesson id is in the path).
  Map<String, Object> toCompleteBody() => {
    'clientEventId': clientEventId,
    'mistakes': mistakes,
    'durationSeconds': durationSeconds,
    'completedAt': _completedAtUtc,
  };

  /// The `lessonComplete` event's fields for `POST /progress/sync` (besides
  /// `clientEventId` and `type`, which the core `SyncEvent` adds).
  Map<String, Object> toSyncPayload() => {
    'lessonId': lessonId,
    'mistakes': mistakes,
    'durationSeconds': durationSeconds,
    'completedAt': _completedAtUtc,
  };
}
