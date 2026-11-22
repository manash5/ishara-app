import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/async_value_x.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile.dart';

part 'profile_provider.g.dart';

/// The signed-in learner (`GET /me`). Learn, lesson and gamification read
/// their stats from here; invalidate it to refetch.
@Riverpod(keepAlive: true)
Future<UserProfile> userProfile(Ref ref) async =>
    (await GetProfile(ref.watch(profileRepositoryProvider))()).getOrThrow();

/// What Figma "16 Profile" shows about the learner.
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

  factory ProfileSummary.fromProfile(UserProfile p) => ProfileSummary(
    name: p.displayName,
    joined: p.joinedAt.toLocal(),
    streakDays: p.stats.streakDays,
    totalXp: p.stats.totalXp,
    signsLearned: p.stats.signsLearned,
    cameraAccuracy: p.stats.cameraAccuracy,
    weeklyXp: p.stats.weekXp,
    todayIndex: p.stats.todayIndex,
  );

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

/// Derived synchronously so an error shows at once, even while Riverpod
/// retries [userProfile].
@riverpod
AsyncValue<ProfileSummary> profileSummary(Ref ref) =>
    ref.watch(userProfileProvider).mapKeepingError(ProfileSummary.fromProfile);
