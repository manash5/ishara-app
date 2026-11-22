import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/lesson_result.dart';
import '../../domain/entities/progress_sync_report.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_local_data_source.dart';
import '../datasources/lesson_remote_data_source.dart';
import '../models/lesson_attempt_dto.dart';
import '../models/lesson_dto.dart';
import '../models/progress_sync_dto.dart';

part 'lesson_repository_impl.g.dart';

/// Failures worth retrying later: no connection, a timeout, or a server
/// fault (5xx). Others (404, 409, 400/422, 401 after a failed refresh) won't
/// succeed by resending, so they are not queued.
bool isRetryable(Failure failure) =>
    failure is NetworkFailure || failure is ServerFailure;

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl(this._remote, this._local, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final LessonRemoteDataSource _remote;
  final LessonLocalDataSource _local;
  final DateTime Function() _clock;

  /// The flush in progress, shared by concurrent callers.
  Future<Result<ProgressSyncReport>>? _flushing;

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
        await guard(() => _local.removeQueued([dto.clientEventId]));
      case Err(:final failure) when isRetryable(failure):
        // Never drop a finished lesson: flushQueue sends it later.
        await guard(
          () => _local.enqueue(
            QueuedAttemptDto(attempt: dto, queuedAt: _clock().toUtc()),
          ),
        );
      case Err():
        break;
    }
    return result;
  }

  @override
  Future<Result<ProgressSyncReport>> flushQueue() =>
      _flushing ??= _flush().whenComplete(() => _flushing = null);

  Future<Result<ProgressSyncReport>> _flush() async {
    final read = await guard(() async => _local.readQueue());
    final List<QueuedAttemptDto> queue;
    switch (read) {
      case Ok(:final value):
        queue = value;
      case Err(:final failure):
        return Err(failure);
    }
    if (queue.isEmpty) return const Ok(ProgressSyncReport());

    final sent = await guard(
      () => _remote.syncProgress([for (final q in queue) q.attempt]),
    );
    switch (sent) {
      case Err(:final failure):
        await guard(() => _local.markFailed(queue));
        return Err(failure);
      case Ok(:final value):
        return guard(() => _applyResults(queue, value));
    }
  }

  Future<ProgressSyncReport> _applyResults(
    List<QueuedAttemptDto> queue,
    ProgressSyncDto response,
  ) async {
    final queued = {for (final q in queue) q.attempt.clientEventId};
    final done = <String>{};
    final applied = <LessonResult>[];
    var duplicates = 0;
    var rejected = 0;
    for (final r in response.results) {
      if (!queued.contains(r.clientEventId)) continue;
      switch (r.status) {
        case SyncEventStatus.applied:
          done.add(r.clientEventId);
          if (r.result case final result?) applied.add(result.toEntity());
        case SyncEventStatus.duplicate:
          done.add(r.clientEventId);
          duplicates++;
        case SyncEventStatus.rejected:
          done.add(r.clientEventId);
          rejected++;
        case SyncEventStatus.unknown:
          break;
      }
    }
    await _local.removeQueued(done);
    return ProgressSyncReport(
      applied: applied,
      duplicates: duplicates,
      rejected: rejected,
      remaining: queue.length - done.length,
    );
  }
}

@Riverpod(keepAlive: true)
LessonRepository lessonRepository(Ref ref) => LessonRepositoryImpl(
  LessonRemoteDataSource(ref.watch(apiClientProvider)),
  LessonLocalDataSource(ref.watch(hiveServiceProvider)),
);
