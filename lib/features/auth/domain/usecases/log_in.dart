import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Signs in with email and password (Figma "04 Log in").
class LogIn {
  const LogIn(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required String email,
    required String password,
  }) => _repository.logIn(email: email.trim(), password: password);
}
