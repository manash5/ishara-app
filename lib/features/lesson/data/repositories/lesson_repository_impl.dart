import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../../../core/sync/sync_controller.dart';
import '../../../../core/sync/sync_event.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/lesson_result.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_local_data_source.dart';
import '../datasources/lesson_remote_data_source.dart';
import '../models/lesson_attempt_dto.dart';
import '../models/lesson_dto.dart';

part 'lesson_repository_impl.g.dart';

/// Failures worth retrying later: no connection, a timeout, or a server
/// fault (5xx). Others (404, 409, 400/422, 401 after a failed refresh) won't
/// succeed by resending, so they are not queued.
bool isRetryable(Failure failure) =>
    failure is NetworkFailure || failure is ServerFailure;

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl(
    this._remote,
    this._local,
    this._queue, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final LessonRemoteDataSource _remote;
  final LessonLocalDataSource _local;
  final SyncQueue _queue;
  final DateTime Function() _clock;

  @override
  Stream<Result<Lesson>> watchLesson(String lessonId) async* {
    final cached = _cachedLesson(lessonId);
    if (cached != null) yield Ok(cached);

    final fresh = await guard(() async {
      final dto = await _remote.fetchLesson(lessonId);
      return (dto, dto.toEntity());
    });
    switch (fresh) {
      case Ok(value: (final dto, final lesson)):
        await _writeLesson(lessonId, dto);
        yield Ok(lesson);
      case Err(:final failure):
        if (cached == null) yield Err(failure);
    }
  }

  /// The cached lesson, or null if there is none or it can't be read.
  Lesson? _cachedLesson(String lessonId) {
    try {
      return _local.readLesson(lessonId)?.value.toEntity();
    } catch (_) {
      return null;
    }
  }

  /// A cache write that fails only costs the next offline start.
  Future<void> _writeLesson(String lessonId, LessonDto dto) =>
      guard(() => _local.writeLesson(lessonId, dto));

  @override
  Future<Result<LessonResult>> completeLesson(LessonAttempt attempt) async {
    final dto = LessonAttemptDto.fromEntity(attempt);
    final result = await guard(
      () async => (await _remote.completeLesson(dto)).toEntity(),
    );
    switch (result) {
      case Ok():
        // A queued copy of this attempt is now recorded.
        await guard(() => _queue.remove([dto.clientEventId]));
      case Err(:final failure) when isRetryable(failure):
        // Never drop a finished lesson: the core SyncService sends it later.
        await guard(
          () => _queue.enqueue(
            SyncEvent(
              clientEventId: dto.clientEventId,
              type: SyncEvent.lessonComplete,
              payload: dto.toSyncPayload(),
              occurredAt: dto.completedAt,
              queuedAt: _clock().toUtc(),
            ),
          ),
        );
      case Err():
        break;
    }
    return result;
  }
}

@Riverpod(keepAlive: true)
LessonRepository lessonRepository(Ref ref) => LessonRepositoryImpl(
  LessonRemoteDataSource(ref.watch(apiClientProvider)),
  LessonLocalDataSource(ref.watch(hiveServiceProvider)),
  ref.watch(syncQueueProvider),
);
