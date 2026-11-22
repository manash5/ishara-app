import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/gamification/domain/entities/game_stats.dart';
import 'package:ishara_app/features/gamification/domain/usecases/apply_lesson_result.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson_result.dart';

void main() {
  const stats = StreakStats(
    days: 20,
    longestDays: 21,
    freezes: 1,
    practisedDays: [true, true, false, false, false, false, false],
    todayIndex: 2,
  );

  LessonResult result(int streakDays) => LessonResult(
    lessonId: 'l',
    clientEventId: 'e',
    xpEarned: 15,
    accuracy: 1,
    duration: const Duration(minutes: 3),
    newSignCount: 2,
    signs: const [],
    streakExtended: true,
    streakDays: streakDays,
    hearts: 5,
    completedAt: DateTime.utc(2026, 11, 22),
  );

  test('no lesson yet: the profile streak as it is', () {
    expect(const ApplyLessonResult()(stats, null), stats);
  });

  test('the lesson response sets the streak and ticks today', () {
    final applied = const ApplyLessonResult()(stats, result(21));
    expect(applied.days, 21);
    expect(applied.longestDays, 21);
    expect(applied.practisedDays, [
      true,
      true,
      true,
      false,
      false,
      false,
      false,
    ]);
    expect(applied.freezes, 1);
  });

  test('a new record raises the longest streak', () {
    expect(const ApplyLessonResult()(stats, result(22)).longestDays, 22);
  });
}
