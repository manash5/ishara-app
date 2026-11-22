import '../error/app_exception.dart';
import '../error/result.dart';
import '../services/api/api_client.dart';
import '../services/api/api_endpoints.dart';
import '../services/api/api_response.dart';
import 'sync_event.dart';
import 'sync_queue.dart';

/// Sends the offline queue through `POST /progress/sync` (oldest first).
/// Applied, duplicate and rejected events leave the queue; on any failure
/// every event stays (never dropped) and is marked failed. Replays are safe:
/// the server is idempotent on `clientEventId`.
class SyncService {
  SyncService(this._queue, this._api);

  final SyncQueue _queue;
  final ApiClient _api;

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

    final sent = await guard(() => _send(events));
    switch (sent) {
      case Err(:final failure):
        await guard(() => _queue.markFailed(events));
        return Err(failure);
      case Ok(:final value):
        return guard(() => _apply(events, value));
    }
  }

  Future<List<Map<String, dynamic>>> _send(List<SyncEvent> events) async {
    final response = await _api.post(
      ApiEndpoints.syncProgress,
      data: {
        'events': [for (final e in events) e.toWire()],
      },
    );
    return ApiEnvelope.fromJson(response.data, (d) {
      final results = (d! as Map<String, dynamic>)['results'];
      if (results is! List) throw const UnknownException();
      return results.cast<Map<String, dynamic>>();
    }).requireData;
  }

  Future<SyncReport> _apply(
    List<SyncEvent> events,
    List<Map<String, dynamic>> results,
  ) async {
    final byId = {for (final e in events) e.clientEventId: e};
    final done = <String>{};
    final applied = <SyncApplied>[];
    var duplicates = 0;
    var rejected = 0;
    for (final r in results) {
      final event = byId[r['clientEventId']];
      if (event == null) continue;
      switch (r['status']) {
        case 'applied':
          done.add(event.clientEventId);
          applied.add(
            SyncApplied(
              clientEventId: event.clientEventId,
              type: event.type,
              result: r['result'] as Map<String, dynamic>?,
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
