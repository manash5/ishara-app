import 'package:freezed_annotation/freezed_annotation.dart';

import 'lesson_result.dart';

part 'progress_sync_report.freezed.dart';

/// What one flush of the offline queue (`POST /progress/sync`) did. Owned by
/// **lesson**.
@freezed
abstract class ProgressSyncReport with _$ProgressSyncReport {
  const factory ProgressSyncReport({
    /// What the server awarded for each newly applied completion.
    @Default(<LessonResult>[]) List<LessonResult> applied,

    /// Events the server had already recorded (dropped from the queue).
    @Default(0) int duplicates,

    /// Events the server can't apply (dropped; the contract says never retry).
    @Default(0) int rejected,

    /// Events still waiting in the queue after this flush.
    @Default(0) int remaining,
  }) = _ProgressSyncReport;
}
