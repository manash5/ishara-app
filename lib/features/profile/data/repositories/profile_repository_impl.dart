import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../domain/entities/profile_update.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_update_dto.dart';

part 'profile_repository_impl.g.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remote, this._local);

  final ProfileRemoteDataSource _remote;
  final ProfileLocalDataSource _local;

  @override
  Result<DateTime?> lastUpdated() => guardSync(() => _local.read()?.fetchedAt);

  @override
  Stream<Result<UserProfile>> watchProfile() async* {
    final cached = _readCache();
    if (cached != null) yield Ok(cached);

    final fresh = await getProfile();
    switch (fresh) {
      case Ok():
        yield fresh;
      case Err() when cached == null:
        yield fresh;
        return;
      case Err():
        break;
    }
    yield* _local.changes().map((dto) => Ok(dto.toEntity()));
  }

  @override
  Future<Result<UserProfile>> getProfile() => guard(() async {
    final dto = await _remote.fetchProfile();
    await _local.write(dto);
    return dto.toEntity();
  });

  @override
  Future<Result<UserProfile?>> cachedProfile() =>
      guard(() async => _local.read()?.value.toEntity());

  @override
  Future<Result<UserProfile>> updateProfile(ProfileUpdate update) =>
      guard(() async {
        final dto = await _remote.updateProfile(
          ProfileUpdateDto.fromEntity(update),
        );
        await _local.write(dto);
        return dto.toEntity();
      });

  @override
  Future<Result<void>> deleteAccount() => guard(() async {
    await _remote.deleteAccount();
    await _local.clear();
  });

  /// The cached profile; an unreadable cache counts as none.
  UserProfile? _readCache() {
    try {
      return _local.read()?.value.toEntity();
    } on CacheException {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepositoryImpl(
  ProfileRemoteDataSource(ref.watch(apiClientProvider)),
  ProfileLocalDataSource(ref.watch(hiveServiceProvider)),
);
