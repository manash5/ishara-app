import '../../../../core/error/result.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../entities/auth_session.dart';
import '../entities/auth_status.dart';

/// Auth over the REST API (`/auth/*`). A successful sign-in (register, log
/// in, Google, password reset) stores the tokens securely and caches the
/// session's user as the profile.
abstract interface class AuthRepository {
  /// `POST /auth/register`.
  Future<Result<AuthSession>> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// `POST /auth/login`.
  Future<Result<AuthSession>> logIn({
    required String email,
    required String password,
  });

  /// Google account picker, then `POST /auth/google`. `Ok(null)` when the
  /// learner cancels the picker.
  Future<Result<AuthSession?>> signInWithGoogle();

  /// `POST /auth/forgot-password`: emails a 6-digit code.
  Future<Result<void>> requestPasswordReset(String email);

  /// `POST /auth/reset-password`; signs the learner in on success.
  Future<Result<AuthSession>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  /// `POST /auth/logout` (best effort: a failure is ignored), then
  /// [clearSession].
  Future<Result<void>> logOut();

  /// Ends the session on this device: forgets the tokens and every cached
  /// value (privacy). Reports [AuthStatus.signedOut].
  Future<Result<void>> clearSession();

  /// The learner on this device at start-up: null without stored tokens,
  /// else the cached profile, else `GET /me`.
  Future<Result<UserProfile?>> restoreSession();

  /// Session changes (sign-in, logout, failed token refresh).
  Stream<AuthStatus> get statusChanges;
}
