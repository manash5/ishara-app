import '../../../../core/error/result.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// The profile saved on the device, without a network call.
class GetCachedProfile {
  const GetCachedProfile(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile?>> call() => _repository.cachedProfile();
}
