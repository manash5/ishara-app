import '../entities/auth_status.dart';
import '../repositories/auth_repository.dart';

/// Session changes: sign-in, logout and failed token refreshes.
class WatchAuthStatus {
  const WatchAuthStatus(this._repository);

  final AuthRepository _repository;

  Stream<AuthStatus> call() => _repository.statusChanges;
}
