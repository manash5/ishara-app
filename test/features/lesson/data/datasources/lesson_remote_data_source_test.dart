import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/lesson/data/datasources/lesson_remote_data_source.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_attempt_dto.dart';

import '../../../../helpers/mock_api.dart';

LessonAttemptDto _attempt(String id) => LessonAttemptDto(
  clientEventId: id,
  lessonId: FixtureIds.currentLesson,
  mistakes: 0,
  durationSeconds: 252,
  completedAt: DateTime.utc(2026, 11, 22, 9),
);

void main() {
  test('fetchLesson parses GET /lessons/:id', () async {
    final dto = await LessonRemoteDataSource(mockApiClient())
        .fetchLesson(FixtureIds.currentLesson);
    expect(dto.lesson.id, FixtureIds.currentLesson);
    expect(dto.exercises, hasLength(6));
  });

  test(
    'completeLesson echoes the clientEventId; a replay is the same',
    () async {
      final remote = LessonRemoteDataSource(mockApiClient());
      final first = await remote.completeLesson(_attempt('e-1'));
      final replay = await remote.completeLesson(_attempt('e-1'));
      expect(first.clientEventId, 'e-1');
      expect(first.lessonId, FixtureIds.currentLesson);
      expect(replay, first);
    },
  );

  test('offline throws NetworkException', () async {
    final remote = LessonRemoteDataSource(
      mockApiClient(simulation: () => MockApiSimulation.offline),
    );
    await expectLater(
      remote.completeLesson(_attempt('a')),
      throwsA(isA<NetworkException>()),
    );
  });
}
