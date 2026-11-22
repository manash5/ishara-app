import '../../../../core/error/result.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// The learner's profile, cached first, then fresh, then every change.
class WatchProfile {
  const WatchProfile(this._repository);

  final ProfileRepository _repository;

  Stream<Result<UserProfile>> call() => _repository.watchProfile();
}
