import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../learn/domain/entities/lesson_summary.dart';
import 'exercise.dart';

part 'lesson.freezed.dart';

/// A lesson as the player receives it (`GET /lessons/:id`). Owned by
/// **lesson**.
@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required List<Exercise> exercises,

    /// Title, kind and size, as on the path.
    LessonSummary? summary,
  }) = _Lesson;
}
