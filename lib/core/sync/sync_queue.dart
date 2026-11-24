import 'dart:convert';

import '../error/app_exception.dart';
import '../services/storage/hive_service.dart';
import 'sync_event.dart';

/// The offline queue: [SyncEvent]s in the Hive `syncQueue` box, keyed by
/// `clientEventId`. Events leave only when the server has applied, already
/// recorded or rejected them — never because a send failed. Throws
/// [CacheException].
class SyncQueue {
  const SyncQueue(this._hive);

  final HiveService _hive;

  int get count => _hive.syncQueue.length;

  bool contains(String clientEventId) =>
      _hive.syncQueue.containsKey(clientEventId);

  /// The number of queued events, now and after every change.
  Stream<int> watchCount() async* {
    yield count;
    yield* _hive.syncQueue.watch().map((_) => count);
  }

  /// Every queued event, oldest first (by `occurredAt`, then `queuedAt`).
  List<SyncEvent> pending() {
    try {
      final events = [
        for (final raw in _hive.syncQueue.values)
          SyncEvent.fromJson(
            jsonDecode(raw['value'] as String) as Map<String, dynamic>,
          ),
      ];
      return events..sort((a, b) {
        final byOccurred = a.occurredAt.compareTo(b.occurredAt);
        return byOccurred != 0 ? byOccurred : a.queuedAt.compareTo(b.queuedAt);
      });
    } catch (_) {
      throw const CacheException();
    }
  }

  /// Queues [event] unless its `clientEventId` is already queued (a retry of
  /// the same change keeps its first entry).
  Future<void> enqueue(SyncEvent event) async {
    if (contains(event.clientEventId)) return;
    await _put(event);
  }

  /// Drops these events (the server has them).
  Future<void> remove(Iterable<String> clientEventIds) async {
    try {
      await _hive.syncQueue.deleteAll(clientEventIds);
    } catch (_) {
      throw const CacheException();
    }
  }

  /// Counts one more failed flush on each of [events]; they stay queued.
  Future<void> markFailed(Iterable<SyncEvent> events) async {
    for (final e in events) {
      await _put(e.withFailedFlush());
    }
  }

  Future<void> _put(SyncEvent event) async {
    try {
      await _hive.syncQueue.put(event.clientEventId, {
        'value': jsonEncode(event.toJson()),
      });
    } catch (_) {
      throw const CacheException();
    }
  }
}
