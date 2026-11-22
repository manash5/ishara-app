import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_summary.freezed.dart';

enum LessonKind { lesson, review }

enum LessonState { locked, available, current, completed }

/// A lesson as the path and the lesson sheet show it. Owned by **learn**;
/// also used by lesson (`GET /lessons/:id` returns it with the exercises).
@freezed
abstract class LessonSummary with _$LessonSummary {
  const factory LessonSummary({
    required String id,
    required String unitId,
    required String title,
    required LessonKind kind,
    required LessonState state,
    required int signCount,
    required int minutes,
  }) = _LessonSummary;
}
