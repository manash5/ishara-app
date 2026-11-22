import 'dart:convert';

import '../../../../core/error/app_exception.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../models/lesson_attempt_dto.dart';
import '../models/lesson_dto.dart';

/// Lessons cached in Hive (`lesson.<id>`) and the offline queue of finished
/// lessons (the `syncQueue` box, keyed by `clientEventId`). Throws
/// [CacheException].
///
/// A lesson carries no video URLs (videos load by sign id), so caching it
/// never stores a short-lived signed URL.
class LessonLocalDataSource {
  const LessonLocalDataSource(this._hive);

  final HiveService _hive;

  static String lessonKey(String lessonId) => 'lesson.$lessonId';

  CacheEntry<LessonDto>? readLesson(String lessonId) => _hive.readCache(
    lessonKey(lessonId),
    (json) => LessonDto.fromJson(json! as Map<String, dynamic>),
  );

  Future<void> writeLesson(String lessonId, LessonDto lesson) =>
      _hive.putCache(lessonKey(lessonId), lesson.toJson());

  /// Every queued attempt, oldest first (by `completedAt`, then `queuedAt`).
  List<QueuedAttemptDto> readQueue() {
    try {
      final queue = [
        for (final raw in _hive.syncQueue.values)
          QueuedAttemptDto.fromJson(
            jsonDecode(raw['value'] as String) as Map<String, dynamic>,
          ),
      ];
      return queue..sort((a, b) {
        final byCompleted = a.attempt.completedAt.compareTo(
          b.attempt.completedAt,
        );
        return byCompleted != 0
            ? byCompleted
            : a.queuedAt.compareTo(b.queuedAt);
      });
    } catch (_) {
      throw const CacheException();
    }
  }

  /// Queues [entry] unless its `clientEventId` is already queued (a retry of
  /// the same attempt keeps its first entry).
  Future<void> enqueue(QueuedAttemptDto entry) async {
    final key = entry.attempt.clientEventId;
    if (_hive.syncQueue.containsKey(key)) return;
    await _put(entry);
  }

  /// Drops the attempts with these `clientEventId`s from the queue.
  Future<void> removeQueued(Iterable<String> clientEventIds) async {
    try {
      await _hive.syncQueue.deleteAll(clientEventIds);
    } catch (_) {
      throw const CacheException();
    }
  }

  /// Counts one more failed flush on each of [entries] (kept in the queue).
  Future<void> markFailed(Iterable<QueuedAttemptDto> entries) async {
    for (final e in entries) {
      await _put(e.copyWith(failedFlushes: e.failedFlushes + 1));
    }
  }

  Future<void> _put(QueuedAttemptDto entry) async {
    try {
      await _hive.syncQueue.put(entry.attempt.clientEventId, {
        'value': jsonEncode(entry.toJson()),
      });
    } catch (_) {
      throw const CacheException();
    }
  }
}
