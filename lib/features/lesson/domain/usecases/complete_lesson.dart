import '../../../../core/error/result.dart';
import '../entities/lesson_result.dart';
import '../repositories/lesson_repository.dart';

/// Sends a finished lesson and returns what the server awarded. If it fails
/// offline, on a timeout or with a server error (5xx), the attempt is queued
/// (same `clientEventId`) and the failure returned.
class CompleteLesson {
  const CompleteLesson(this._repository);

  final LessonRepository _repository;

  Future<Result<LessonResult>> call(LessonAttempt attempt) =>
      _repository.completeLesson(attempt);
}
