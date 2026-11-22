import '../../../../core/error/result.dart';
import '../entities/lesson.dart';
import '../entities/lesson_result.dart';

abstract interface class LessonRepository {
  /// A lesson and its exercises (`GET /lessons/:id`).
  Future<Result<Lesson>> getLesson(String lessonId);

  /// Records a finished lesson (`POST /lessons/:id/complete`). Idempotent on
  /// [LessonAttempt.clientEventId]: a repeat returns the same result.
  Future<Result<LessonResult>> completeLesson(LessonAttempt attempt);
}
