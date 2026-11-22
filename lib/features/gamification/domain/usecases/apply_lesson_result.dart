import 'dart:math' as math;

import '../../../lesson/domain/entities/lesson_result.dart';
import '../entities/game_stats.dart';

/// Brings the streak up to date with a lesson the server just recorded:
/// `/me` can lag until the profile is refetched, but the completion response
/// already has the new streak. Today counts as practised.
class ApplyLessonResult {
  const ApplyLessonResult();

  StreakStats call(StreakStats stats, LessonResult? result) {
    if (result == null) return stats;
    return stats.copyWith(
      days: result.streakDays,
      longestDays: math.max(stats.longestDays, result.streakDays),
      practisedDays: [
        for (final (i, practised) in stats.practisedDays.indexed)
          i == stats.todayIndex || practised,
      ],
    );
  }
}
