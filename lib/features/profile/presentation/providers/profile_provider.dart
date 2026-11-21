import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

/// What Figma "16 Profile" shows about the learner (UI-only phase).
@immutable
class ProfileSummary {
  const ProfileSummary({
    required this.name,
    required this.joined,
    required this.streakDays,
    required this.totalXp,
    required this.signsLearned,
    required this.cameraAccuracy,
    required this.weeklyXp,
    required this.todayIndex,
  });

  final String name;
  final DateTime joined;
  final int streakDays;
  final int totalXp;
  final int signsLearned;

  /// 0–1 share of camera exercises signed correctly.
  final double cameraAccuracy;

  /// XP earned per day this week, Monday first (7 values).
  final List<int> weeklyXp;

  /// Index into [weeklyXp] of today (0 = Monday).
  final int todayIndex;
}

/// Hard-coded profile matching the Figma frame; a repository-backed
/// provider replaces it when the data layer lands.
@riverpod
ProfileSummary profileSummary(Ref ref) => ProfileSummary(
  name: 'Manash Lamichhane',
  joined: DateTime(2026, 11),
  streakDays: 12,
  totalXp: 1240,
  signsLearned: 18,
  cameraAccuracy: 0.87,
  weeklyXp: const [30, 55, 20, 70, 45, 4, 62],
  todayIndex: 6,
);
