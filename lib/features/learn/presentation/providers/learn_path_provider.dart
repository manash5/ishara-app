import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../gamification/domain/entities/game_stats.dart';
import '../../../gamification/presentation/providers/progress_stats_provider.dart';
import '../../data/repositories/path_repository_impl.dart';
import '../../domain/entities/lesson_summary.dart';
import '../../domain/entities/path_unit.dart' as domain;
import '../../domain/usecases/watch_path.dart';

part 'learn_path_provider.g.dart';

/// One stop on the roadmap, ready for [PathNode] (from `GET /path`).
@immutable
class PathStop {
  const PathStop({
    required this.state,
    required this.title,
    required this.signs,
    required this.minutes,
    this.lessonId,
  });

  final PathNodeState state;

  /// Shown to screen readers and in the lesson sheet, e.g. "Namaste".
  final String title;

  /// Lessons open the lesson sheet; chests and checkpoints have none.
  final String? lessonId;

  /// Lesson size shown on the current-lesson card.
  final int signs;
  final int minutes;
}

/// One stage of the climb: its banner and its stops, first lesson first.
@immutable
class PathUnit {
  const PathUnit({
    required this.number,
    required this.title,
    required this.color,
    required this.learned,
    required this.total,
    required this.stops,
  });

  final int number;
  final String title;
  final UnitColor color;
  final int learned;
  final int total;
  final List<PathStop> stops;
}

/// Domain path → roadmap view models.
PathUnit pathUnitFromDomain(domain.PathUnit u) => PathUnit(
  number: u.number,
  title: u.title,
  color: UnitColor.values.byName(u.tint.name),
  learned: u.learnedCount,
  total: u.totalCount,
  stops: [
    for (final s in u.stops)
      PathStop(
        state: switch ((s.type, s.state)) {
          (domain.StopType.chest, _) => PathNodeState.chest,
          (domain.StopType.checkpoint, _) => PathNodeState.checkpoint,
          (_, LessonState.locked) => PathNodeState.locked,
          (domain.StopType.review, _) => PathNodeState.review,
          (_, LessonState.current) => PathNodeState.current,
          (_, LessonState.completed) => PathNodeState.completed,
          (_, LessonState.available) => PathNodeState.current,
        },
        title: s.title,
        lessonId: s.lesson?.id,
        signs: s.lesson?.signCount ?? 0,
        minutes: s.lesson?.minutes ?? 0,
      ),
  ],
);

/// The roadmap (`GET /path`): the cached path first (so Learn works
/// offline), then the fresh one. Errors only when nothing is cached; retry
/// with `ref.invalidate(learnPathProvider)`.
@riverpod
Stream<List<PathUnit>> learnPath(Ref ref) =>
    WatchPath(ref.watch(pathRepositoryProvider))().map(
      (result) => [for (final u in result.getOrThrow()) pathUnitFromDomain(u)],
    );

/// Header stats on the Learn tab (Figma StatsBar 10:466), from the
/// learner's profile (`GET /me`).
@riverpod
AsyncValue<ProgressStats> learnStats(Ref ref) =>
    ref.watch(progressStatsProvider);
