import '../../../../core/error/result.dart';
import '../entities/progress_sync_report.dart';
import '../repositories/lesson_repository.dart';

/// Sends the offline queue of finished lessons (`POST /progress/sync`).
class FlushProgressQueue {
  const FlushProgressQueue(this._repository);

  final LessonRepository _repository;

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

  Future<Result<ProgressSyncReport>> call() => _repository.flushQueue();
}
