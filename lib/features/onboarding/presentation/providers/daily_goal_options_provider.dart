import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

/// Fake goal options (Figma 9:225) until the backend serves them.
@riverpod
List<DailyGoalOption> dailyGoalOptions(Ref ref) => const [
  DailyGoalOption(
    id: 'casual',
    title: 'Casual',
    minutes: 5,
    lessons: 1,
    icon: IsharaIcons.clock,
  ),
  DailyGoalOption(
    id: 'regular',
    title: 'Regular',
    minutes: 10,
    lessons: 2,
    icon: IsharaIcons.target,
  ),
  DailyGoalOption(
    id: 'serious',
    title: 'Serious',
    minutes: 15,
    lessons: 3,
    icon: IsharaIcons.flame,
  ),
  DailyGoalOption(
    id: 'intense',
    title: 'Intense',
    minutes: 20,
    lessons: 4,
    icon: IsharaIcons.zap,
  ),
];
