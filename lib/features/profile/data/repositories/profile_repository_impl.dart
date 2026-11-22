import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

part 'profile_repository_impl.g.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remote);

  final ProfileRemoteDataSource _remote;

  @override
  Future<Result<UserProfile>> getProfile() =>
      guard(() async => (await _remote.fetchProfile()).toEntity());
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepositoryImpl(
  ProfileRemoteDataSource(ref.watch(apiClientProvider)),
);
