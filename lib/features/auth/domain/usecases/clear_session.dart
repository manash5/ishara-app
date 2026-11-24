import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

/// Forgets the session on this device without calling the API (e.g. after
/// the account was deleted, which already revoked it).
class ClearSession {
  const ClearSession(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.clearSession();
}
