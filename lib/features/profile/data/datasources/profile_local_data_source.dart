import '../../../../core/services/storage/hive_service.dart';
import '../models/user_profile_dto.dart';

/// The signed-in learner's profile cached in Hive under [cacheKey], so
/// Profile, streak and stats work offline. Auth writes it on sign-in and
/// onboarding after `POST /me/onboarding`. Throws `CacheException`.
class ProfileLocalDataSource {
  const ProfileLocalDataSource(this._hive);

  static const cacheKey = 'profile.me';

  final HiveService _hive;

  CacheEntry<UserProfileDto>? read() => _hive.readCache(
    cacheKey,
    (json) => UserProfileDto.fromJson(json! as Map<String, dynamic>),
  );

  Future<void> write(UserProfileDto profile) =>
      _hive.putCache(cacheKey, profile.toJson());

  Future<void> clear() => _hive.removeCache(cacheKey);

  /// The cached profile each time it is written (deletions are skipped).
  Stream<UserProfileDto> changes() => _hive.cache
      .watch(key: cacheKey)
      .where((event) => !event.deleted)
      .map((_) => read()?.value)
      .where((dto) => dto != null)
      .cast<UserProfileDto>();
}
