import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

/// Signs out: revokes the session (best effort) and clears this device.
class LogOut {
  const LogOut(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.logOut();
}
