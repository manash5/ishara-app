import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../dictionary/domain/entities/sign.dart';

part 'lesson_result.freezed.dart';

/// A finished lesson, sent as `POST /lessons/:id/complete` (and queued for
/// `POST /progress/sync` when offline). [clientEventId] makes it idempotent.
@freezed
abstract class LessonAttempt with _$LessonAttempt {
  const factory LessonAttempt({
    required String clientEventId,
    required String lessonId,

    /// Wrong answers (camera "almost" doesn't count).
    required int mistakes,
    required Duration duration,
    required DateTime completedAt,
  }) = _LessonAttempt;
}

/// What the server awarded for a finished lesson (Figma 26). Owned by
/// **lesson**.
@freezed
abstract class LessonResult with _$LessonResult {
  const factory LessonResult({
    required String lessonId,
    required String clientEventId,

    /// Lesson reward + perfect bonus (game-rules.md).
    required int xpEarned,

    /// 0–1 share of answers right first time.
    required double accuracy,
    required Duration duration,

    /// Headline count ("You learned 5 new greetings.").
    required int newSignCount,
    required List<Sign> signs,

    /// Whether this lesson extended the streak (then Figma 27 follows).
    required bool streakExtended,
    required int streakDays,
    required int hearts,
    required DateTime completedAt,
  }) = _LessonResult;
}
