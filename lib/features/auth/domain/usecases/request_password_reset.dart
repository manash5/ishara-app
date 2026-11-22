import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

/// Emails a 6-digit reset code (Figma "05 Forgot password", step 1).
class RequestPasswordReset {
  const RequestPasswordReset(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call(String email) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return const Err(
        ValidationFailure('Enter the email you signed up with.'),
      );
    }
    return _repository.requestPasswordReset(trimmed);
  }
}
