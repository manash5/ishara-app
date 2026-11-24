import '../error/result.dart';
import 'sync_event.dart';
import 'sync_queue.dart';
import 'sync_remote_data_source.dart';
import 'sync_result_dto.dart';

/// Sends the offline queue through `POST /progress/sync` (oldest first).
/// Applied, duplicate and rejected events leave the queue; on any failure
/// every event stays (never dropped) and is marked failed. Replays are safe:
/// the server is idempotent on `clientEventId`.
class SyncService {
  SyncService(this._queue, this._remote);

  final SyncQueue _queue;
  final SyncRemoteDataSource _remote;

  /// The flush in progress, shared by concurrent callers.
  Future<Result<SyncReport>>? _flushing;

  /// First retry after a failed flush; doubles per failure.
  static const firstRetryDelay = Duration(seconds: 30);

  /// Longest wait between retries.
  static const maxRetryDelay = Duration(minutes: 30);

  /// How long to wait before retrying after [failures] failed flushes in a
  /// row (1 → 30 s, 2 → 1 min, 3 → 2 min … capped at 30 min).
  static Duration retryDelay(int failures) {
    if (failures <= 1) return firstRetryDelay;
    final shift = failures - 1 > 16 ? 16 : failures - 1;
    final delay = firstRetryDelay * (1 << shift);
    return delay > maxRetryDelay ? maxRetryDelay : delay;
  }

  Future<Result<SyncReport>> flush() =>
      _flushing ??= _flush().whenComplete(() => _flushing = null);

  Future<Result<SyncReport>> _flush() async {
    final read = await guard(() async => _queue.pending());
    final List<SyncEvent> events;
    switch (read) {
      case Ok(:final value):
        events = value;
      case Err(:final failure):
        return Err(failure);
    }
    if (events.isEmpty) return const Ok(SyncReport());

    final sent = await guard(() => _remote.sync(events));
    switch (sent) {
      case Err(:final failure):
        await guard(() => _queue.markFailed(events));
        return Err(failure);
      case Ok(:final value):
        return guard(() => _apply(events, value));
    }
  }

  Future<SyncReport> _apply(
    List<SyncEvent> events,
    List<SyncResultDto> results,
  ) async {
    final byId = {for (final e in events) e.clientEventId: e};
    final done = <String>{};
    final applied = <SyncApplied>[];
    var duplicates = 0;
    var rejected = 0;
    for (final r in results) {
      final event = byId[r.clientEventId];
      if (event == null) continue;
      switch (r.status) {
        case 'applied':
          done.add(event.clientEventId);
          applied.add(
            SyncApplied(
              clientEventId: event.clientEventId,
              type: event.type,
              result: r.result,
            ),
          );
        case 'duplicate':
          done.add(event.clientEventId);
          duplicates++;
        case 'rejected':
          done.add(event.clientEventId);
          rejected++;
        default:
          // A status this app doesn't know: keep it queued.
          break;
      }
    }
    await _queue.remove(done);
    return SyncReport(
      applied: applied,
      duplicates: duplicates,
      rejected: rejected,
      remaining: events.length - done.length,
    );
  }
}
