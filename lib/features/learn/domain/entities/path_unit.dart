import 'package:freezed_annotation/freezed_annotation.dart';

import 'lesson_summary.dart';

part 'path_unit.freezed.dart';

/// Banner colour of a unit on the roadmap.
enum UnitTint { teal, mint, lavender, lime }

enum StopType { lesson, review, chest, checkpoint }

/// One stage of the climb (`GET /path`): its banner and stops, first first.
@freezed
abstract class PathUnit with _$PathUnit {
  const factory PathUnit({
    required String id,
    required int number,
    required String title,
    required UnitTint tint,
    required int learnedCount,
    required int totalCount,
    required List<PathStop> stops,
  }) = _PathUnit;
}

/// One stop on the roadmap. Lessons and reviews carry a [lesson]; chests and
/// checkpoints don't.
@freezed
abstract class PathStop with _$PathStop {
  const factory PathStop({
    required String id,
    required StopType type,
    required LessonState state,
    required String title,
    LessonSummary? lesson,
  }) = _PathStop;
}
