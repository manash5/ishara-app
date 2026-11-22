import '../../../../core/error/result.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../repositories/auth_repository.dart';

/// The learner already signed in on this device, or null (app start).
class RestoreSession {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  Future<Result<UserProfile?>> call() => _repository.restoreSession();
}
