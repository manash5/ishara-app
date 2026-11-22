import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../error/result.dart';
import '../services/api/api_client.dart';
import '../services/storage/hive_service.dart';
import 'sync_event.dart';
import 'sync_queue.dart';
import 'sync_remote_data_source.dart';
import 'sync_service.dart';
import '../connectivity/is_online.dart';

part 'sync_controller.g.dart';

@Riverpod(keepAlive: true)
SyncQueue syncQueue(Ref ref) => SyncQueue(ref.watch(hiveServiceProvider));

@Riverpod(keepAlive: true)
SyncService syncService(Ref ref) => SyncService(
  ref.watch(syncQueueProvider),
  SyncRemoteDataSource(ref.watch(apiClientProvider)),
);

/// How many changes are waiting to sync.
@riverpod
Stream<int> syncPendingCount(Ref ref) =>
    ref.watch(syncQueueProvider).watchCount();

/// Where syncing stands.
@immutable
class SyncState {
  const SyncState({this.flushing = false, this.failures = 0, this.lastReport});

  final bool flushing;

  /// Failed flushes in a row (drives the back-off).
  final int failures;

  /// The last successful flush; features react to its `applied` events.
  final SyncReport? lastReport;
}

/// Flushes the offline queue whenever the app comes online, retries a failed
/// flush with back-off ([SyncService.retryDelay]), and on app resume
/// ([flush], called from `lib/app.dart`). Keep it alive from the app root.
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  Timer? _retry;

  @override
  SyncState build() {
    ref.onDispose(() => _retry?.cancel());
    ref.listen(isOnlineProvider, (previous, next) {
      if (next.value == true && previous?.value != true) {
        // Not during build: flush() writes state.
        scheduleMicrotask(() => unawaited(flush()));
      }
    }, fireImmediately: true);
    return const SyncState();
  }

  /// Sends the queue now. Returns the report, or null if the flush failed
  /// (a retry is then scheduled) or one is already running.
  Future<SyncReport?> flush() async {
    if (state.flushing) return null;
    _retry?.cancel();
    _retry = null;
    state = SyncState(
      flushing: true,
      failures: state.failures,
      lastReport: state.lastReport,
    );
    final result = await ref.read(syncServiceProvider).flush();
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        state = SyncState(lastReport: value);
        return value;
      case Err():
        final failures = state.failures + 1;
        state = SyncState(failures: failures, lastReport: state.lastReport);
        _retry = Timer(
          SyncService.retryDelay(failures),
          () => unawaited(flush()),
        );
        return null;
    }
  }
}
