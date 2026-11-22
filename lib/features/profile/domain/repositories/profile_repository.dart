import '../../../../core/error/result.dart';
import '../entities/profile_update.dart';
import '../entities/user_profile.dart';

/// The signed-in learner (`/me`), cached for offline use under `profile.me`.
abstract interface class ProfileRepository {
  /// Cache-first: the cached profile (if any), then the fresh one from
  /// `GET /me`, then every later change to the cached profile (e.g. after
  /// [updateProfile], onboarding or a new sign-in). If the fetch fails
  /// without a cached value it yields that [Err] and ends; with one it
  /// yields nothing more for the fetch.
  Stream<Result<UserProfile>> watchProfile();

  /// `GET /me`, written to the cache.
  Future<Result<UserProfile>> getProfile();

  /// The cached profile, or null when there is none.
  Future<Result<UserProfile?>> cachedProfile();

  /// `PUT /me`; the updated profile replaces the cached one.
  Future<Result<UserProfile>> updateProfile(ProfileUpdate update);

  /// When the cached profile was fetched, or null if nothing is cached.
  Result<DateTime?> lastUpdated();

  /// `DELETE /me`: deletes the account and revokes every session. The caller
  /// then ends the local session.
  Future<Result<void>> deleteAccount();
}
