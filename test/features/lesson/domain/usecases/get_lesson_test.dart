import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson.dart';
import 'package:ishara_app/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:ishara_app/features/lesson/domain/usecases/get_lesson.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements LessonRepository {}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  test('GetLesson streams the repository lesson', () async {
    const lesson = Lesson(id: 'l-1', exercises: []);
    when(() => repo.watchLesson('l-1'))
        .thenAnswer((_) => Stream.value(const Ok(lesson)));

    final results = await GetLesson(repo)('l-1').toList();
    expect(results.single.valueOrNull, lesson);
  });
}
