import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson_result.dart';
import 'package:ishara_app/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:ishara_app/features/lesson/domain/usecases/complete_lesson.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements LessonRepository {}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  final attempt = LessonAttempt(
    clientEventId: 'e-1',
    lessonId: 'l-1',
    mistakes: 0,
    duration: Duration.zero,
    completedAt: DateTime.utc(2026),
  );

  test('CompleteLesson forwards the attempt and its failure', () async {
    when(() => repo.completeLesson(attempt))
        .thenAnswer((_) async => const Err(NetworkFailure()));

    final result = await CompleteLesson(repo)(attempt);
    expect((result as Err).failure, isA<NetworkFailure>());
    verify(() => repo.completeLesson(attempt)).called(1);
  });
}
