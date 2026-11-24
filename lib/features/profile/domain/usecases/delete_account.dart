import '../../../../core/error/result.dart';
import '../repositories/profile_repository.dart';

/// Deletes the learner's account and all its data (`DELETE /me`).
class DeleteAccount {
  const DeleteAccount(this._repository);

  final ProfileRepository _repository;

  Future<Result<void>> call() => _repository.deleteAccount();
}
