import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/sync/sync_controller.dart';
import '../../../../core/sync/sync_event.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/models/lesson_result_dto.dart';
import 'lesson_providers.dart';

part 'lesson_sync_listener.g.dart';

/// Reacts when lessons finished offline reach the server (core
/// `SyncController`): the newest one becomes the latest lesson result and
/// the profile is refetched, so XP, hearts and streak match the server.
/// Kept alive from the app root.
@Riverpod(keepAlive: true)
void lessonSyncListener(Ref ref) {
  ref.listen(syncControllerProvider, (previous, next) {
    final report = next.lastReport;
    if (report == null || identical(report, previous?.lastReport)) return;
    final lessons = [
      for (final a in report.applied)
        if (a.type == SyncEvent.lessonComplete) a,
    ];
    if (lessons.isEmpty) return;
    final latest = lessons.last.result;
    if (latest != null) {
      try {
        ref
            .read(latestLessonResultProvider.notifier)
            .record(LessonResultDto.fromJson(latest).toEntity());
        return;
      } on Object {
        // A result this app can't read: still refresh the stats below.
      }
    }
    ref.invalidate(userProfileProvider);
  });
}
