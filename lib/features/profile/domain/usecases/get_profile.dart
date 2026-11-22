import '../../../../core/error/result.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Loads the signed-in learner's profile and stats.
class GetProfile {
  const GetProfile(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile>> call() => _repository.getProfile();
}
