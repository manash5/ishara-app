import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Creates an account (Figma "03 Sign up").
class Register {
  const Register(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required String displayName,
    required String email,
    required String password,
  }) => _repository.register(
    displayName: displayName.trim(),
    email: email.trim(),
    password: password,
  );
}
