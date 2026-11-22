import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/async_value_x.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile_last_updated.dart';
import '../../domain/usecases/watch_profile.dart';

part 'profile_provider.g.dart';

/// The signed-in learner (`GET /me`), cache-first: the cached profile at
/// once, then the fresh one, then every change (settings, onboarding).
/// Learn, lesson and gamification read their stats from here; invalidate it
/// to refetch. A fetch failure without a cached profile is an `AsyncError`
/// carrying a `Failure`.
@Riverpod(keepAlive: true)
Stream<UserProfile> userProfile(Ref ref) => WatchProfile(
  ref.watch(profileRepositoryProvider),
)().map((result) => result.getOrThrow());

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

/// When the profile on screen was fetched; re-read whenever it changes.
@riverpod
DateTime? profileLastUpdated(Ref ref) {
  ref.watch(userProfileProvider);
  return GetProfileLastUpdated(ref.watch(profileRepositoryProvider))();
}
