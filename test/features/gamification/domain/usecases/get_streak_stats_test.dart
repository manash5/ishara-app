import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/gamification/domain/entities/game_stats.dart';
import 'package:ishara_app/features/gamification/domain/usecases/get_streak_stats.dart';

import '../../test_profile.dart';

void main() {
  test('maps the profile stats to the streak', () {
    final stats = const GetStreakStats()(testProfile());
    expect(
      stats,
      const StreakStats(
        days: 12,
        longestDays: 21,
        freezes: 1,
        practisedDays: [true, true, true, true, true, true, true],
        todayIndex: 6,
      ),
    );
  });

  test('a day with no XP is not practised', () {
    final stats = const GetStreakStats()(
      testProfile(weekXp: const [10, 0, 5, 0, 0, 0, 0], todayIndex: 2),
    );
    expect(stats.practisedDays, [
      true,
      false,
      true,
      false,
      false,
      false,
      false,
    ]);
    expect(stats.todayIndex, 2);
  });
}
