import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/connectivity/connectivity_service.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import '../../domain/entities/progress_sync_report.dart';
import '../../domain/usecases/flush_progress_queue.dart';

part 'progress_sync_provider.g.dart';

/// Where the offline queue flush stands.
@immutable
class ProgressSyncState {
  const ProgressSyncState({
    this.flushing = false,
    this.failures = 0,
    this.lastReport,
  });

  final bool flushing;

  /// Failed flushes in a row (drives the back-off).
  final int failures;
  final ProgressSyncReport? lastReport;
}

/// Flushes the queue of lessons finished offline (`POST /progress/sync`)
/// whenever the app comes online, and retries a failed flush with
/// exponential back-off ([FlushProgressQueue.retryDelay]). Call [flush] on
/// app resume. Keep it alive by listening to it from the app root.
@Riverpod(keepAlive: true)
class ProgressSync extends _$ProgressSync {
  Timer? _retry;

  @override
  ProgressSyncState build() {
    ref.onDispose(() => _retry?.cancel());
    ref.listen(isOnlineProvider, (previous, next) {
      if (next.value == true && previous?.value != true) {
        // Not during build: flush() writes state.
        scheduleMicrotask(() => unawaited(flush()));
      }
    }, fireImmediately: true);
    return const ProgressSyncState();
  }

  /// Sends the queue now. Returns the report, or null if the flush failed
  /// (a retry is then scheduled) or one is already running.
  Future<ProgressSyncReport?> flush() async {
    if (state.flushing) return null;
    _retry?.cancel();
    _retry = null;
    state = ProgressSyncState(
      flushing: true,
      failures: state.failures,
      lastReport: state.lastReport,
    );
    final result = await FlushProgressQueue(
      ref.read(lessonRepositoryProvider),
    )();
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        state = ProgressSyncState(lastReport: value);
        if (value.applied.isNotEmpty) ref.invalidate(userProfileProvider);
        return value;
      case Err():
        final failures = state.failures + 1;
        state = ProgressSyncState(
          failures: failures,
          lastReport: state.lastReport,
        );
        _retry = Timer(
          FlushProgressQueue.retryDelay(failures),
          () => unawaited(flush()),
        );
        return null;
    }
  }
}
