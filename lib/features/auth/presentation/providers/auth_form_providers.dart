import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/usecases/log_in.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/request_password_reset.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import 'session_provider.dart';

part 'auth_form_providers.g.dart';

/// Which form a password field belongs to, so each screen keeps its own
/// show/hide state.
enum AuthPasswordField { signUp, logIn, reset }

/// Whether the password in [field] is shown as plain text (Figma
/// `trailingIcon` eye toggle). Local UI state only.
@riverpod
class PasswordVisible extends _$PasswordVisible {
  @override
  bool build(AuthPasswordField field) => false;

  void toggle() => state = !state;
}

/// The form field an error is shown under.
enum AuthField { email, password, code }

/// What a form is waiting for.
enum AuthSubmit { email, google, sendCode, reset }

/// A form's request state: what is running and the error to show.
@immutable
class AuthFormState {
  const AuthFormState({this.pending, this.error, this.errorField});

  final AuthSubmit? pending;

  /// User-safe text (never raw exception text).
  final String? error;
  final AuthField? errorField;

  bool get busy => pending != null;

  /// The error for [field], if it is shown there.
  String? errorFor(AuthField field) => errorField == field ? error : null;
}

/// Copy for the auth 401s: the API's message is "Wrong email or password."
/// / the Google one, but a 401 maps to the generic session-ended failure.
const wrongCredentialsMessage = 'Wrong email or password.';
const googleFailedMessage = 'We couldn’t sign you in with Google. Try again.';
const emailTakenMessage = 'An account with this email already exists.';

/// Runs [action]; on success signs the session in. Returns the next form
/// state. `Ok(null)` (Google picker cancelled) is a quiet no-op.
Future<AuthFormState> _authenticate(
  Ref ref,
  Future<Result<AuthSession?>> Function() action, {
  required String Function(Failure failure) message,
  required AuthField Function(Failure failure) field,
}) async {
  final result = await action();
  switch (result) {
    case Ok(value: final session?):
      if (ref.mounted) {
        ref.read(sessionProvider.notifier).signedIn(session.user);
      }
      return const AuthFormState();
    case Ok():
      return const AuthFormState();
    case Err(:final failure):
      return AuthFormState(error: message(failure), errorField: field(failure));
  }
}

String _googleMessage(Failure f) =>
    f is UnauthorizedFailure ? googleFailedMessage : f.message;

/// Figma "04 Log in": email + password or Google.
@riverpod
class LogInForm extends _$LogInForm {
  @override
  AuthFormState build() => const AuthFormState();

  Future<void> logIn({required String email, required String password}) =>
      _submit(
        AuthSubmit.email,
        () => LogIn(ref.read(authRepositoryProvider))(
          email: email,
          password: password,
        ),
        (f) => f is UnauthorizedFailure ? wrongCredentialsMessage : f.message,
      );

  Future<void> google() => _submit(
    AuthSubmit.google,
    SignInWithGoogle(ref.read(authRepositoryProvider)).call,
    _googleMessage,
  );

  Future<void> _submit(
    AuthSubmit kind,
    Future<Result<AuthSession?>> Function() action,
    String Function(Failure) message,
  ) async {
    if (state.busy) return;
    state = AuthFormState(pending: kind);
    final next = await _authenticate(
      ref,
      action,
      message: message,
      field: (_) => AuthField.password,
    );
    if (ref.mounted) state = next;
  }
}

/// Figma "03 Sign up": name, email, password or Google.
@riverpod
class SignUpForm extends _$SignUpForm {
  @override
  AuthFormState build() => const AuthFormState();

  Future<void> register({
    required String displayName,
    required String email,
    required String password,
  }) => _submit(
    AuthSubmit.email,
    () => Register(ref.read(authRepositoryProvider))(
      displayName: displayName,
      email: email,
      password: password,
    ),
    (f) => f is ConflictFailure ? emailTakenMessage : f.message,
  );

  Future<void> google() => _submit(
    AuthSubmit.google,
    SignInWithGoogle(ref.read(authRepositoryProvider)).call,
    _googleMessage,
  );

  Future<void> _submit(
    AuthSubmit kind,
    Future<Result<AuthSession?>> Function() action,
    String Function(Failure) message,
  ) async {
    if (state.busy) return;
    state = AuthFormState(pending: kind);
    final next = await _authenticate(
      ref,
      action,
      message: message,
      field: (f) => f is ConflictFailure ? AuthField.email : AuthField.password,
    );
    if (ref.mounted) state = next;
  }
}

/// Figma "05 Forgot password": step 1 emails a code, step 2 sets a new
/// password with it ([sentTo] is the email once the code is sent).
@immutable
class PasswordResetState {
  const PasswordResetState({this.sentTo, this.form = const AuthFormState()});

  /// Null on step 1; the email the code went to on step 2.
  final String? sentTo;
  final AuthFormState form;

  bool get codeSent => sentTo != null;
}

@riverpod
class PasswordResetForm extends _$PasswordResetForm {
  @override
  PasswordResetState build() => const PasswordResetState();

  /// Step 1 (and "Resend code").
  Future<void> sendCode(String email) async {
    if (state.form.busy) return;
    final sentTo = state.sentTo;
    state = PasswordResetState(
      sentTo: sentTo,
      form: const AuthFormState(pending: AuthSubmit.sendCode),
    );
    final result = await RequestPasswordReset(ref.read(authRepositoryProvider))(
      email,
    );
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => PasswordResetState(sentTo: email.trim()),
      Err(:final failure) => PasswordResetState(
        sentTo: sentTo,
        form: AuthFormState(
          error: failure.message,
          errorField: AuthField.email,
        ),
      ),
    };
  }

  /// Step 2: on success the learner is signed in.
  Future<void> reset({
    required String code,
    required String newPassword,
  }) async {
    final email = state.sentTo;
    if (email == null || state.form.busy) return;
    state = PasswordResetState(
      sentTo: email,
      form: const AuthFormState(pending: AuthSubmit.reset),
    );
    final next = await _authenticate(
      ref,
      () => ResetPassword(ref.read(authRepositoryProvider))(
        email: email,
        code: code,
        newPassword: newPassword,
      ),
      message: (f) => f.message,
      // 422 ("That code is invalid…") goes under the code; anything else
      // (e.g. 400, too-weak password) under the new password.
      field: (f) => f is ValidationFailure && _isAboutCode(f.message)
          ? AuthField.code
          : AuthField.password,
    );
    if (ref.mounted) state = PasswordResetState(sentTo: email, form: next);
  }

  /// Back to step 1 (e.g. to fix the email).
  void changeEmail() => state = const PasswordResetState();

  static bool _isAboutCode(String message) =>
      message.toLowerCase().contains('code');
}
