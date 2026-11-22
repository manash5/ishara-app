import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_provider.g.dart';

/// What Figma "27 Streak" shows (UI-only phase).
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

/// Hard-coded streak matching the Figma frame; the server replaces it.
@riverpod
StreakSummary streakSummary(Ref ref) => const StreakSummary(
  days: 12,
  longest: 21,
  freezes: 1,
  week: [true, true, true, true, true, false, false],
  todayIndex: 4,
);
