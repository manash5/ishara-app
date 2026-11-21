import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_form_providers.g.dart';

/// Which form a password field belongs to, so each screen keeps its own
/// show/hide state.
enum AuthPasswordField { signUp, logIn }

/// Whether the password in [field] is shown as plain text (Figma
/// `trailingIcon` eye toggle). Local UI state only.
@riverpod
class PasswordVisible extends _$PasswordVisible {
  @override
  bool build(AuthPasswordField field) => false;

  void toggle() => state = !state;
}

/// Error under the Log in password field (Figma "04 Log in" error state).
///
/// UI-only phase: there is no real auth yet, so this is always null; the
/// data layer will surface "Incorrect password. Try again." here.
@riverpod
String? logInPasswordError(Ref ref) => null;

/// Whether the reset link has been sent (Figma "05 Forgot password" shows the
/// sent state: success notice + "Resend link").
@riverpod
class ResetLinkSent extends _$ResetLinkSent {
  @override
  bool build() => false;

  /// Fake send: no network in the UI-only phase.
  void send() => state = true;
}
