import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/async_value_x.dart';

import '../../../profile/presentation/providers/profile_provider.dart';

part 'streak_provider.g.dart';

/// What Figma "27 Streak" shows.
@immutable
class StreakSummary {
  const StreakSummary({
    required this.days,
    required this.longest,
    required this.freezes,
    required this.week,
    required this.todayIndex,
  });

  /// Current streak in days.
  final int days;
  final int longest;

  /// Streak freezes ready to use.
  final int freezes;

  /// Practised on each day this week, Monday first (7 values).
  final List<bool> week;

  /// Index into [week] of today (0 = Monday).
  final int todayIndex;
}

/// The learner's streak from their stats (`GET /me`); a day counts as
/// practised when it earned XP.
@riverpod
AsyncValue<StreakSummary> streakSummary(Ref ref) =>
    ref.watch(userProfileProvider).mapKeepingError((profile) {
      final stats = profile.stats;
      return StreakSummary(
        days: stats.streakDays,
        longest: stats.longestStreakDays,
        freezes: stats.streakFreezes,
        week: stats.practisedDays,
        todayIndex: stats.todayIndex,
      );
    });
