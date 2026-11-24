import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

/// Sets a new password with the emailed code and signs in (Figma "05 Forgot
/// password", step 2).
class ResetPassword {
  const ResetPassword(this._repository);

  final AuthRepository _repository;

  static final _sixDigits = RegExp(r'^\d{6}$');

  Future<Result<AuthSession>> call({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final trimmedCode = code.trim();
    if (!_sixDigits.hasMatch(trimmedCode)) {
      return const Err(
        ValidationFailure('Enter the 6-digit code from the email.'),
      );
    }
    return _repository.resetPassword(
      email: email.trim(),
      code: trimmedCode,
      newPassword: newPassword,
    );
  }
}
