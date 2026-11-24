import '../../../../core/error/result.dart';
import '../entities/lesson.dart';
import '../repositories/lesson_repository.dart';

/// Loads a lesson for the player: the cached copy first, then the fresh one.
class GetLesson {
  const GetLesson(this._repository);

  final LessonRepository _repository;

  Stream<Result<Lesson>> call(String lessonId) =>
      _repository.watchLesson(lessonId);
}
