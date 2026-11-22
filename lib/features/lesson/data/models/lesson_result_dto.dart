import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../dictionary/data/models/sign_dto.dart';
import '../../domain/entities/lesson_result.dart';

part 'lesson_result_dto.freezed.dart';
part 'lesson_result_dto.g.dart';

/// `POST /lessons/:id/complete` data (docs/api-contract.md → LessonResult).
@freezed
abstract class LessonResultDto with _$LessonResultDto {
  const LessonResultDto._();

  const factory LessonResultDto({
    required String lessonId,
    required String clientEventId,
    required int xpEarned,
    required double accuracy,
    required int durationSeconds,
    required int newSignCount,
    required List<SignDto> signs,
    required bool streakExtended,
    required int streakDays,
    required int hearts,
    required DateTime completedAt,
  }) = _LessonResultDto;

  factory LessonResultDto.fromJson(Map<String, dynamic> json) =>
      _$LessonResultDtoFromJson(json);

  LessonResult toEntity() => LessonResult(
    lessonId: lessonId,
    clientEventId: clientEventId,
    xpEarned: xpEarned,
    accuracy: accuracy,
    duration: Duration(seconds: durationSeconds),
    newSignCount: newSignCount,
    signs: [for (final s in signs) s.toEntity()],
    streakExtended: streakExtended,
    streakDays: streakDays,
    hearts: hearts,
    completedAt: completedAt,
  );
}

/// The `POST /lessons/:id/complete` body.
Map<String, Object> lessonAttemptToJson(LessonAttempt attempt) => {
  'clientEventId': attempt.clientEventId,
  'mistakes': attempt.mistakes,
  'durationSeconds': attempt.duration.inSeconds,
  'completedAt': attempt.completedAt.toUtc().toIso8601String(),
};
