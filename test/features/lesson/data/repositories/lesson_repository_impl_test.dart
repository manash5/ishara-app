import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';
import 'package:ishara_app/core/sync/sync_event.dart';
import 'package:ishara_app/core/sync/sync_queue.dart';
import 'package:ishara_app/core/sync/sync_remote_data_source.dart';
import 'package:ishara_app/core/sync/sync_service.dart';
import 'package:ishara_app/features/lesson/data/datasources/lesson_local_data_source.dart';
import 'package:ishara_app/features/lesson/data/datasources/lesson_remote_data_source.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_attempt_dto.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_dto.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_result_dto.dart';
import 'package:ishara_app/features/lesson/data/repositories/lesson_repository_impl.dart';
import 'package:ishara_app/features/lesson/domain/entities/exercise.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson_result.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

class _MockRemote extends Mock implements LessonRemoteDataSource {}

class _MockLocal extends Mock implements LessonLocalDataSource {}

class _MockQueue extends Mock implements SyncQueue {}

const _lessonId = FixtureIds.currentLesson;

LessonDto _lessonDto() => LessonDto.fromJson(fixtureData('lessons/get_200'));

LessonResultDto _resultDto([String event = 'e-1']) => LessonResultDto.fromJson(
  fixtureData<Map<String, dynamic>>('lessons/complete_200'),
).copyWith(clientEventId: event);

LessonAttempt _attempt(String event, {int minute = 0}) => LessonAttempt(
  clientEventId: event,
  lessonId: _lessonId,
  mistakes: 1,
  duration: const Duration(minutes: 4, seconds: 12),
  completedAt: DateTime.utc(2026, 11, 22, 9, minute),
);

void main() {
  setUpAll(() {
    registerFallbackValue(_lessonDto());
    registerFallbackValue(LessonAttemptDto.fromEntity(_attempt('fallback')));
    registerFallbackValue(
      SyncEvent(
        clientEventId: 'fallback',
        type: SyncEvent.lessonComplete,
        payload: const {},
        occurredAt: DateTime.utc(2026),
        queuedAt: DateTime.utc(2026),
      ),
    );
    registerFallbackValue(<String>[]);
  });

  late _MockRemote remote;
  late _MockLocal local;
  late _MockQueue queue;
  late LessonRepositoryImpl repo;

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    queue = _MockQueue();
    repo = LessonRepositoryImpl(
      remote,
      local,
      queue,
      clock: () => DateTime.utc(2026, 11, 22, 10),
    );
    when(() => local.writeLesson(any(), any())).thenAnswer((_) async {});
    when(() => queue.enqueue(any())).thenAnswer((_) async {});
    when(() => queue.remove(any())).thenAnswer((_) async {});
  });

  group('watchLesson (cache first)', () {
    Lesson ok(Result<Lesson> r) => (r as Ok<Lesson>).value;

    test(
      'cache hit: cached lesson, then the fresh one (cached again)',
      () async {
        final cached = _lessonDto().copyWith(
          exercises: [_lessonDto().exercises.first],
        );
        when(() => local.readLesson(_lessonId))
            .thenReturn(CacheEntry(cached, DateTime.utc(2026)));
        when(() => remote.fetchLesson(_lessonId))
            .thenAnswer((_) async => _lessonDto());

        final results = await repo.watchLesson(_lessonId).toList();

        expect(results, hasLength(2));
        expect(ok(results[0]).exercises, hasLength(1));
        expect(ok(results[1]).exercises, hasLength(6));
        verify(() => local.writeLesson(_lessonId, _lessonDto())).called(1);
      },
    );

    test('cache miss: only the fresh lesson', () async {
      when(() => local.readLesson(_lessonId)).thenReturn(null);
      when(() => remote.fetchLesson(_lessonId))
          .thenAnswer((_) async => _lessonDto());

      final results = await repo.watchLesson(_lessonId).toList();

      expect(results, hasLength(1));
      expect(ok(results.single).id, _lessonId);
    });

    test('remote error with a cache: the cached lesson only', () async {
      when(() => local.readLesson(_lessonId))
          .thenReturn(CacheEntry(_lessonDto(), DateTime.utc(2026)));
      when(() => remote.fetchLesson(_lessonId))
          .thenThrow(const NetworkException());

      final results = await repo.watchLesson(_lessonId).toList();

      expect(results, hasLength(1));
      expect(ok(results.single).exercises, hasLength(6));
      verifyNever(() => local.writeLesson(any(), any()));
    });

    test('remote error without a cache: the failure', () async {
      when(() => local.readLesson(_lessonId)).thenReturn(null);
      when(() => remote.fetchLesson(_lessonId))
          .thenThrow(const ServerException(500));

      final results = await repo.watchLesson(_lessonId).toList();

      expect((results.single as Err).failure, isA<ServerFailure>());
    });

    test('an unreadable cache counts as a miss', () async {
      when(() => local.readLesson(_lessonId)).thenThrow(const CacheException());
      when(() => remote.fetchLesson(_lessonId))
          .thenAnswer((_) async => _lessonDto());

      final results = await repo.watchLesson(_lessonId).toList();

      expect(results, hasLength(1));
      expect(results.single.isOk, isTrue);
    });

    test('a failed cache write still yields the fresh lesson', () async {
      when(() => local.readLesson(_lessonId)).thenReturn(null);
      when(() => remote.fetchLesson(_lessonId))
          .thenAnswer((_) async => _lessonDto());
      when(() => local.writeLesson(any(), any()))
          .thenThrow(const CacheException());

      final results = await repo.watchLesson(_lessonId).toList();

      expect(results.single.isOk, isTrue);
    });
  });

  group('completeLesson', () {
    test(
      'sends the attempt with its clientEventId and clears any queued copy',
      () async {
        when(() => remote.completeLesson(any()))
            .thenAnswer((_) async => _resultDto('e-1'));

        final result = await repo.completeLesson(_attempt('e-1'));

        expect(result.valueOrNull?.clientEventId, 'e-1');
        final sent =
            verify(() => remote.completeLesson(captureAny())).captured.single
                as LessonAttemptDto;
        expect(sent.clientEventId, 'e-1');
        expect(sent.durationSeconds, 252);
        verify(() => queue.remove(['e-1'])).called(1);
        verifyNever(() => queue.enqueue(any()));
      },
    );

    test('offline: queues the attempt and returns a NetworkFailure', () async {
      when(() => remote.completeLesson(any()))
          .thenThrow(const NetworkException());

      final result = await repo.completeLesson(_attempt('e-1'));

      expect((result as Err).failure, isA<NetworkFailure>());
      final queued =
          verify(() => queue.enqueue(captureAny())).captured.single
              as SyncEvent;
      expect(queued.clientEventId, 'e-1');
      expect(queued.type, SyncEvent.lessonComplete);
      expect(queued.queuedAt, DateTime.utc(2026, 11, 22, 10));
      expect(queued.occurredAt, DateTime.utc(2026, 11, 22, 9));
      expect(queued.toWire(), {
        'clientEventId': 'e-1',
        'type': 'lessonComplete',
        'lessonId': _lessonId,
        'mistakes': 1,
        'durationSeconds': 252,
        'completedAt': '2026-11-22T09:00:00.000Z',
      });
    });

    test('offline and the queue write fails: still a NetworkFailure', () async {
      when(() => remote.completeLesson(any()))
          .thenThrow(const NetworkException());
      when(() => queue.enqueue(any())).thenThrow(const CacheException());

      final result = await repo.completeLesson(_attempt('e-1'));

      expect((result as Err).failure, isA<NetworkFailure>());
    });

    test(
      'a server error (5xx) is queued too, so the lesson is never lost',
      () async {
        when(() => remote.completeLesson(any()))
            .thenThrow(const ServerException(503));

        final result = await repo.completeLesson(_attempt('e-1'));

        expect((result as Err).failure, isA<ServerFailure>());
        final queued =
            verify(() => queue.enqueue(captureAny())).captured.single
                as SyncEvent;
        expect(queued.clientEventId, 'e-1');
      },
    );

    for (final exception in const <AppException>[
      NotFoundException(),
      ConflictException(),
      ValidationException('Bad attempt'),
      UnauthorizedException(),
    ]) {
      test(
        '${exception.runtimeType} is not queued: resending would not help',
        () async {
          when(() => remote.completeLesson(any())).thenThrow(exception);

          final result = await repo.completeLesson(_attempt('e-1'));

          expect(result, isA<Err<LessonResult>>());
          verifyNever(() => queue.enqueue(any()));
        },
      );
    }

    test('isRetryable: only network and server failures', () {
      expect(isRetryable(const NetworkFailure()), isTrue);
      expect(isRetryable(const ServerFailure()), isTrue);
      expect(isRetryable(const NotFoundFailure()), isFalse);
      expect(isRetryable(const ConflictFailure()), isFalse);
      expect(isRetryable(const ValidationFailure()), isFalse);
      expect(isRetryable(const UnauthorizedFailure()), isFalse);
      expect(isRetryable(const UnknownFailure()), isFalse);
    });
  });

  group('against the mock API and Hive', () {
    LessonRepositoryImpl realRepo([MockApiSimulation Function()? s]) =>
        LessonRepositoryImpl(
          LessonRemoteDataSource(mockApiClient(simulation: s)),
          LessonLocalDataSource(TestHive.instance),
          SyncQueue(TestHive.instance),
        );

    SyncService sync([MockApiSimulation Function()? s]) => SyncService(
      SyncQueue(TestHive.instance),
      SyncRemoteDataSource(mockApiClient(simulation: s)),
    );

    test(
      'maps the lesson and one exercise of each type, and caches it',
      () async {
        final lesson = (await realRepo().watchLesson(_lessonId).last)
            .getOrThrow();
        expect(lesson.id, _lessonId);
        expect(lesson.exercises.map((e) => e.runtimeType), [
          WatchExercise,
          RecogniseExercise,
          PickSignExercise,
          MatchPairsExercise,
          SignItExercise,
          FingerspellExercise,
        ]);
        expect(
          TestHive.instance.cache.containsKey('lesson.$_lessonId'),
          isTrue,
        );

        // Offline next time: the cached lesson only.
        final offline = await realRepo(() => MockApiSimulation.offline)
            .watchLesson(_lessonId)
            .toList();
        expect(offline.single.getOrThrow().exercises, hasLength(6));
      },
    );

    test('offline with nothing cached is a NetworkFailure', () async {
      final result = await realRepo(() => MockApiSimulation.offline)
          .watchLesson(_lessonId)
          .single;
      expect((result as Err).failure, isA<NetworkFailure>());
    });

    test('replay: one clientEventId twice returns the same result', () async {
      final r = realRepo();
      final attempt = _attempt('c3d4e5f6-0000-4000-8000-000000000001');
      final first = (await r.completeLesson(attempt)).getOrThrow();
      final replay = (await r.completeLesson(attempt)).getOrThrow();
      expect(replay, first);
      expect(first.clientEventId, attempt.clientEventId);
      expect(first.xpEarned, 15);
      expect(first.signs.map((s) => s.id), [
        FixtureIds.namaste,
        FixtureIds.thankYou,
      ]);
    });

    test('offline completion is queued, then the core SyncService applies and '
        'removes it; '
        'a second copy is a duplicate', () async {
      var simulation = MockApiSimulation.offline;
      final r = realRepo(() => simulation);
      final service = sync(() => simulation);
      final attempt = _attempt('c3d4e5f6-0000-4000-8000-000000000002');

      final offline = await r.completeLesson(attempt);
      expect((offline as Err).failure, isA<NetworkFailure>());
      // Try again while still offline keeps one entry.
      await r.completeLesson(attempt);
      expect(TestHive.instance.syncQueue.keys, [attempt.clientEventId]);

      // Still offline: the flush fails and keeps it.
      expect((await service.flush()).isOk, isFalse);
      expect(TestHive.instance.syncQueue.length, 1);

      simulation = MockApiSimulation.none;
      final report = (await service.flush()).getOrThrow();
      expect(report.applied.single.clientEventId, attempt.clientEventId);
      expect(report.remaining, 0);
      expect(TestHive.instance.syncQueue.isEmpty, isTrue);

      // Re-queued by a stale retry: the server says duplicate → dropped.
      final dto = LessonAttemptDto.fromEntity(attempt);
      await SyncQueue(TestHive.instance).enqueue(
        SyncEvent(
          clientEventId: dto.clientEventId,
          type: SyncEvent.lessonComplete,
          payload: dto.toSyncPayload(),
          occurredAt: dto.completedAt,
          queuedAt: DateTime.utc(2026),
        ),
      );
      final again = (await service.flush()).getOrThrow();
      expect(again.duplicates, 1);
      expect(again.applied, isEmpty);
      expect(TestHive.instance.syncQueue.isEmpty, isTrue);
    });

    test('a 500 on completion queues the lesson; it syncs once the server '
        'recovers', () async {
      var simulation = MockApiSimulation.serverError;
      final r = realRepo(() => simulation);
      final service = sync(() => simulation);
      final attempt = _attempt('c3d4e5f6-0000-4000-8000-000000000003');

      final failed = await r.completeLesson(attempt);
      expect((failed as Err).failure, isA<ServerFailure>());
      expect(TestHive.instance.syncQueue.keys, [attempt.clientEventId]);

      // Server still failing: the flush keeps it.
      expect((await service.flush()).isOk, isFalse);
      expect(TestHive.instance.syncQueue.length, 1);

      simulation = MockApiSimulation.none;
      final report = (await service.flush()).getOrThrow();
      expect(report.applied.single.clientEventId, attempt.clientEventId);
      expect(TestHive.instance.syncQueue.isEmpty, isTrue);
    });
  });
}
