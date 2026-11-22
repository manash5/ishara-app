import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/auth_form_providers.dart';
import '../widgets/auth_form_scaffold.dart';
import '../widgets/password_field.dart';
import '../widgets/reset_link_sent_notice.dart';
import '../../../../core/connectivity/is_online.dart';

/// Figma "05 Forgot password" (7:281), in two steps.
///
/// 1. Email + "Send reset code" (`POST /auth/forgot-password`).
/// 2. The sent notice, then the 6-digit code + new password and "Reset
///    password" (`POST /auth/reset-password`); success signs the learner in
///    and the router redirect moves on. "Resend code" sends another.
///
/// Step 2 is composed from the same shared fields as the other auth forms.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  /// Shown while offline (auth needs a connection).
  static const offlineMessage =
      'You’re offline. Resetting your password needs an internet connection.';

  /// Length of the emailed reset code.
  static const codeLength = 6;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  void _backToLogIn() {
    if (context.canPop()) {
      context.pop();
    } else {
      const LogInRoute().go(context);
    }
  }

  void _sendCode() {
    FocusScope.of(context).unfocus();
    ref.read(passwordResetFormProvider.notifier).sendCode(_email.text);
  }

  void _reset() {
    FocusScope.of(context).unfocus();
    ref
        .read(passwordResetFormProvider.notifier)
        .reset(code: _code.text, newPassword: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordResetFormProvider);
    final form = state.form;
    // Auth needs a connection.
    final offline = ref.watch(isOnlineProvider).value == false;
    final sent = state.codeSent;
    return AuthFormScaffold(
      offlineMessage: offline ? ForgotPasswordScreen.offlineMessage : null,
      title: 'Reset your password',
      subtitle: sent
          ? 'Enter the 6-digit code from the email and choose a new '
                'password.'
          : 'Enter the email you signed up with and we’ll send you a '
                'reset code.',
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (sent) ...[
            IsharaButton(
              label: form.pending == AuthSubmit.reset
                  ? 'Resetting…'
                  : 'Reset password',
              onPressed: form.busy || offline ? null : _reset,
            ),
            const SizedBox(height: IsharaSpacing.s3),
            IsharaButton(
              label: form.pending == AuthSubmit.sendCode
                  ? 'Sending…'
                  : 'Resend code',
              variant: IsharaButtonVariant.outlined,
              onPressed: form.busy || offline ? null : _sendCode,
            ),
          ] else
            IsharaButton(
              label: form.pending == AuthSubmit.sendCode
                  ? 'Sending…'
                  : 'Send reset code',
              onPressed: form.busy || offline ? null : _sendCode,
            ),
          const SizedBox(height: IsharaSpacing.s3),
          IsharaButton(
            label: 'Back to log in',
            variant: IsharaButtonVariant.text,
            onPressed: _backToLogIn,
          ),
        ],
      ),
      children: [
        IsharaTextField(
          label: 'Email',
          controller: _email,
          enabled: !form.busy && !sent,
          errorText: form.errorFor(AuthField.email),
          prefixIcon: IsharaIcons.mail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.send,
          autofillHints: const [AutofillHints.email],
          onSubmitted: (_) => _sendCode(),
        ),
        if (sent) ...[
          const ResetLinkSentNotice(),
          AuthFields(
            children: [
              IsharaTextField(
                label: 'Reset code',
                hint: '6-digit code',
                controller: _code,
                enabled: !form.busy,
                errorText: form.errorFor(AuthField.code),
                prefixIcon: IsharaIcons.lock,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    ForgotPasswordScreen.codeLength,
                  ),
                ],
              ),
              PasswordField(
                field: AuthPasswordField.reset,
                label: 'New password',
                hint: 'At least 8 characters',
                controller: _password,
                enabled: !form.busy,
                errorText: form.errorFor(AuthField.password),
                isNewPassword: true,
                onSubmitted: (_) => _reset(),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
