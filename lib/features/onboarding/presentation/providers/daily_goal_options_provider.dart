import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/game_rules.dart';
import '../../../../core/theme/theme.dart';

part 'daily_goal_options_provider.g.dart';

/// One daily-goal choice on "06 Daily goal".
@immutable
class DailyGoalOption {
  const DailyGoalOption({
    required this.id,
    required this.title,
    required this.minutes,
    required this.lessons,
    required this.icon,
  });

  final String id;
  final String title;
  final int minutes;
  final int lessons;
  final IconData icon;

  /// e.g. "10 min a day · 2 lessons".
  String get description =>
      '$minutes min a day · $lessons ${lessons == 1 ? 'lesson' : 'lessons'}';
}

/// The daily-goal choices on "06 Daily goal" (Figma 9:225): one per goal
/// the API accepts ([GameRules.dailyGoalMinutes]), named and drawn as in
/// Figma.
@riverpod
List<DailyGoalOption> dailyGoalOptions(Ref ref) => [
  for (final (i, minutes) in GameRules.dailyGoalMinutes.indexed)
    DailyGoalOption(
      id: _names[i % _names.length].id,
      title: _names[i % _names.length].title,
      minutes: minutes,
      lessons: (minutes / GameRules.minutesPerLesson).ceil(),
      icon: _names[i % _names.length].icon,
    ),
];

/// Figma's name and icon for each goal, lightest first.
const _names = [
  (id: 'casual', title: 'Casual', icon: IsharaIcons.clock),
  (id: 'regular', title: 'Regular', icon: IsharaIcons.target),
  (id: 'serious', title: 'Serious', icon: IsharaIcons.flame),
  (id: 'intense', title: 'Intense', icon: IsharaIcons.zap),
];
