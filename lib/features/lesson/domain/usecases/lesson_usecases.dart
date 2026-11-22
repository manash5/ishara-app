import '../../../../core/error/result.dart';
import '../entities/lesson.dart';
import '../entities/lesson_result.dart';
import '../repositories/lesson_repository.dart';

/// Loads a lesson for the player.
class GetLesson {
  const GetLesson(this._repository);

  final LessonRepository _repository;

  Future<Result<Lesson>> call(String lessonId) =>
      _repository.getLesson(lessonId);
}

/// Sends a finished lesson and returns what the server awarded.
class CompleteLesson {
  const CompleteLesson(this._repository);

  final LessonRepository _repository;

  Future<Result<LessonResult>> call(LessonAttempt attempt) =>
      _repository.completeLesson(attempt);
}
