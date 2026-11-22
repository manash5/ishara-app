import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';
import 'package:ishara_app/features/lesson/data/datasources/lesson_local_data_source.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_dto.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson_result.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_providers.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';
import 'package:ishara_app/features/profile/presentation/providers/profile_provider.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

void main() {
  const id = FixtureIds.currentLesson;
  late MockApiSimulation simulation;
  late int profileBuilds;

  ProviderContainer makeContainer() {
    final c = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWith(
          (ref) => mockApiClient(simulation: () => simulation),
        ),
        hiveServiceProvider.overrideWithValue(TestHive.instance),
        userProfileProvider.overrideWith((ref) {
          profileBuilds++;
          return const Stream<UserProfile>.empty();
        }),
      ],
      retry: (_, _) => null,
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() {
    simulation = MockApiSimulation.none;
    profileBuilds = 0;
  });

  group('lessonProvider', () {
    test('shows the cached lesson, then the fresh one', () async {
      final full = LessonDto.fromJson(fixtureData('lessons/get_200'));
      await LessonLocalDataSource(TestHive.instance).writeLesson(
        id,
        full.copyWith(exercises: full.exercises.take(2).toList()),
      );
      final c = makeContainer();
      final lessons = <Lesson>[];
      final fresh = Completer<void>();
      c.listen(lessonProvider(id), (_, next) {
        if (next.value case final lesson?) {
          lessons.add(lesson);
          if (lesson.exercises.length == 6) fresh.complete();
        }
      });

      await fresh.future.timeout(const Duration(seconds: 5));

      expect(lessons.map((l) => l.exercises.length), [2, 6]);
    });

    test('offline with nothing cached is a NetworkFailure', () async {
      simulation = MockApiSimulation.offline;
      final c = makeContainer();
      c.listen(lessonProvider(id), (_, _) {});

      await expectLater(
        c.read(lessonProvider(id).future),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('offline with a cached lesson still plays it', () async {
      await LessonLocalDataSource(TestHive.instance)
          .writeLesson(id, LessonDto.fromJson(fixtureData('lessons/get_200')));
      simulation = MockApiSimulation.offline;
      final c = makeContainer();
      c.listen(lessonProvider(id), (_, _) {});

      final lesson = await c.read(lessonProvider(id).future);
      expect(lesson.exercises, hasLength(6));
    });
  });

  group('lessonResultProvider', () {
    final attempt = LessonAttempt(
      clientEventId: 'c3d4e5f6-0000-4000-8000-0000000000aa',
      lessonId: id,
      mistakes: 0,
      duration: const Duration(minutes: 4, seconds: 12),
      completedAt: DateTime.utc(2026, 11, 22, 9),
    );

    test('sends the recorded attempt, exposes it as the latest result and '
        'refreshes the profile', () async {
      final c = makeContainer();
      c.listen(userProfileProvider, (_, _) {});
      c.read(lessonAttemptsProvider.notifier).record(attempt);
      expect(c.read(latestLessonResultProvider), isNull);
      expect(profileBuilds, 1);

      c.listen(lessonResultProvider(id), (_, _) {});
      final result = await c.read(lessonResultProvider(id).future);
      await Future<void>.delayed(Duration.zero);

      expect(result.clientEventId, attempt.clientEventId);
      expect(result.xpEarned, 15);
      expect(result.streakDays, 12);
      expect(result.hearts, 5);
      expect(c.read(latestLessonResultProvider), result);
      expect(profileBuilds, 2);
    });

    test('offline: an error, the attempt is queued; Try again resends the '
        'same clientEventId and clears the queue', () async {
      simulation = MockApiSimulation.offline;
      final c = makeContainer();
      c.read(lessonAttemptsProvider.notifier).record(attempt);
      c.listen(lessonResultProvider(id), (_, _) {});

      await expectLater(
        c.read(lessonResultProvider(id).future),
        throwsA(isA<NetworkFailure>()),
      );
      expect(TestHive.instance.syncQueue.keys, [attempt.clientEventId]);
      expect(c.read(latestLessonResultProvider), isNull);

      simulation = MockApiSimulation.none;
      c.invalidate(lessonResultProvider(id));
      final result = await c.read(lessonResultProvider(id).future);

      expect(result.clientEventId, attempt.clientEventId);
      expect(TestHive.instance.syncQueue.isEmpty, isTrue);
      expect(c.read(latestLessonResultProvider), result);
    });

    test('opened without playing: a stable clientEventId per lesson', () async {
      final c = makeContainer();
      c.listen(lessonResultProvider(id), (_, _) {});
      final first = await c.read(lessonResultProvider(id).future);
      c.invalidate(lessonResultProvider(id));
      final again = await c.read(lessonResultProvider(id).future);
      expect(again.clientEventId, first.clientEventId);
    });
  });
}
