import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Signs in or up with Google. `Ok(null)` means the learner cancelled.
class SignInWithGoogle {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession?>> call() => _repository.signInWithGoogle();
}
