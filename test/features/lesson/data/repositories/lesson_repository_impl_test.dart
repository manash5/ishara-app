import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/lesson/data/datasources/lesson_remote_data_source.dart';
import 'package:ishara_app/features/lesson/data/repositories/lesson_repository_impl.dart';
import 'package:ishara_app/features/lesson/domain/entities/exercise.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson_result.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  LessonRepositoryImpl repo([MockApiSimulation? s]) => LessonRepositoryImpl(
    LessonRemoteDataSource(
      mockApiClient(simulation: s == null ? null : () => s),
    ),
  );

  test('maps the lesson and one exercise of each type', () async {
    final lesson = (await repo().getLesson(FixtureIds.currentLesson))
        .getOrThrow();
    expect(lesson.id, FixtureIds.currentLesson);
    expect(lesson.exercises.map((e) => e.runtimeType), [
      WatchExercise,
      RecogniseExercise,
      PickSignExercise,
      MatchPairsExercise,
      SignItExercise,
      FingerspellExercise,
    ]);
    final signIt = lesson.exercises.whereType<SignItExercise>().single;
    expect(signIt.fallback.signId, signIt.signId);
  });

  test(
    'completing twice with one clientEventId returns the same result',
    () async {
      final r = repo();
      final attempt = LessonAttempt(
        clientEventId: 'c3d4e5f6-0000-4000-8000-000000000001',
        lessonId: FixtureIds.currentLesson,
        mistakes: 0,
        duration: const Duration(minutes: 4, seconds: 12),
        completedAt: DateTime.utc(2026, 11, 22, 9),
      );
      final first = (await r.completeLesson(attempt)).getOrThrow();
      final replay = (await r.completeLesson(attempt)).getOrThrow();
      expect(replay, first);
      expect(first.clientEventId, attempt.clientEventId);
      expect(first.xpEarned, 15);
      expect(first.signs.map((s) => s.id), [
        FixtureIds.namaste,
        FixtureIds.thankYou,
      ]);
    },
  );

  test('offline is a NetworkFailure', () async {
    final result = await repo(MockApiSimulation.offline)
        .getLesson(FixtureIds.currentLesson);
    expect((result as Err).failure, isA<NetworkFailure>());
  });
}
