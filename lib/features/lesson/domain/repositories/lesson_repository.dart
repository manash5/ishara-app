import '../../../../core/error/result.dart';
import '../entities/lesson.dart';
import '../entities/lesson_result.dart';

abstract interface class LessonRepository {
  /// A lesson and its exercises (`GET /lessons/:id`), cache first: the cached
  /// lesson (if any), then the fresh one. A failed refresh emits nothing more
  /// when a cached lesson was shown, else an `Err`.
  Stream<Result<Lesson>> watchLesson(String lessonId);

  /// Records a finished lesson (`POST /lessons/:id/complete`). Idempotent on
  /// [LessonAttempt.clientEventId]: a repeat returns the same result. When
  /// the request fails in a way worth retrying (offline, timeout, 5xx) the
  /// attempt is queued in the core sync queue (`lib/core/sync`) and the
  /// failure is returned.
  Future<Result<LessonResult>> completeLesson(LessonAttempt attempt);
}
