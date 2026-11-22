import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/features/lesson/data/datasources/lesson_local_data_source.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_attempt_dto.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_dto.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

QueuedAttemptDto _queued(String id, {required int minute, int queuedAt = 0}) =>
    QueuedAttemptDto(
      attempt: LessonAttemptDto(
        clientEventId: id,
        lessonId: FixtureIds.currentLesson,
        mistakes: 0,
        durationSeconds: 60,
        completedAt: DateTime.utc(2026, 11, 22, 9, minute),
      ),
      queuedAt: DateTime.utc(2026, 11, 22, 10, queuedAt),
    );

void main() {
  late LessonLocalDataSource local;
  setUp(() => local = LessonLocalDataSource(TestHive.instance));

  test('lessons round-trip under lesson.<id>', () async {
    final dto = LessonDto.fromJson(fixtureData('lessons/get_200'));
    expect(local.readLesson(FixtureIds.currentLesson), isNull);

    await local.writeLesson(FixtureIds.currentLesson, dto);

    expect(
      TestHive.instance.cache.containsKey('lesson.${FixtureIds.currentLesson}'),
      isTrue,
    );
    expect(local.readLesson(FixtureIds.currentLesson)!.value, dto);
  });

  test('no video URL is cached with a lesson', () async {
    await local.writeLesson(
      FixtureIds.currentLesson,
      LessonDto.fromJson(fixtureData('lessons/get_200')),
    );
    final raw = TestHive.instance.cache.get(
      'lesson.${FixtureIds.currentLesson}',
    )!;
    expect(raw['value'] as String, isNot(contains('videoUrl')));
    expect(raw['value'] as String, isNot(contains('http')));
  });

  test('the queue reads oldest first, whatever the key order', () async {
    await local.enqueue(_queued('z', minute: 1));
    await local.enqueue(_queued('a', minute: 3));
    await local.enqueue(_queued('m', minute: 1, queuedAt: 5));

    expect(local.readQueue().map((q) => q.attempt.clientEventId), [
      'z',
      'm',
      'a',
    ]);
  });

  test('enqueue keeps the first entry for a clientEventId', () async {
    await local.enqueue(_queued('a', minute: 1));
    await local.enqueue(_queued('a', minute: 1, queuedAt: 30));

    expect(local.readQueue().single.queuedAt, DateTime.utc(2026, 11, 22, 10));
  });

  test('markFailed counts failures; removeQueued drops entries', () async {
    await local.enqueue(_queued('a', minute: 1));
    await local.enqueue(_queued('b', minute: 2));

    await local.markFailed(local.readQueue());
    await local.markFailed(local.readQueue());
    expect(local.readQueue().map((q) => q.failedFlushes), [2, 2]);

    await local.removeQueued(['a']);
    expect(local.readQueue().map((q) => q.attempt.clientEventId), ['b']);
  });

  test('a corrupt queue entry is a CacheException', () async {
    await TestHive.instance.syncQueue.put('bad', {'value': 'not json'});
    expect(local.readQueue, throwsA(isA<CacheException>()));
  });
}
