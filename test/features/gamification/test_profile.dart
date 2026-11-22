import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';

/// A learner like `assets/mock_api/me/get_200.json`, with overridable stats.
UserProfile testProfile({
  int streakDays = 12,
  int longestStreakDays = 21,
  int streakFreezes = 1,
  int totalXp = 1240,
  int hearts = 5,
  List<int> weekXp = const [30, 55, 20, 70, 45, 4, 62],
  int todayIndex = 6,
}) => UserProfile(
  id: 'c1f404b1-361e-5a17-9c75-ec33753089dc',
  email: 'learner@ishara.test',
  displayName: 'Test Learner',
  joinedAt: DateTime.utc(2026, 11),
  onboardingDone: true,
  dailyGoalMinutes: 10,
  dominantHand: Hand.right,
  timezone: 'Asia/Kathmandu',
  stats: UserStats(
    totalXp: totalXp,
    weeklyXp: weekXp.fold(0, (a, b) => a + b),
    streakDays: streakDays,
    longestStreakDays: longestStreakDays,
    streakFreezes: streakFreezes,
    hearts: hearts,
    maxHearts: 5,
    signsLearned: 18,
    cameraAccuracy: 0.87,
    weekStart: DateTime.utc(2026, 11, 16),
    weekXp: weekXp,
    todayIndex: todayIndex,
  ),
);
