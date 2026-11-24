import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/gamification/domain/entities/game_stats.dart';
import 'package:ishara_app/features/gamification/domain/usecases/get_progress_stats.dart';

import '../../test_profile.dart';

void main() {
  test('takes total XP (not weekly), streak and hearts from the profile', () {
    final stats = const GetProgressStats()(
      testProfile(streakDays: 3, totalXp: 90, hearts: 2),
    );
    expect(
      stats,
      const ProgressStats(streakDays: 3, totalXp: 90, hearts: 2, maxHearts: 5),
    );
  });
}
