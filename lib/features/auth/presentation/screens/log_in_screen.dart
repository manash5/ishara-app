import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/services/connectivity/connectivity_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/auth_form_providers.dart';
import '../widgets/auth_form_scaffold.dart';
import '../widgets/auth_link.dart';
import '../widgets/or_divider.dart';
import '../widgets/password_field.dart';

/// Figma "04 Log in" (7:206).
///
/// "Log in" and Google call the auth use cases through [logInFormProvider];
/// on success the session signs in and the router redirect moves on. Errors
/// (e.g. "Wrong email or password.") show under the password field.
class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  /// Shown while offline (auth needs a connection).
  static const offlineMessage =
      'You’re offline. Logging in needs an internet connection.';

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _logIn() {
    FocusScope.of(context).unfocus();
    ref
        .read(logInFormProvider.notifier)
        .logIn(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(logInFormProvider);
    // Auth needs a connection.
    final offline = ref.watch(isOnlineProvider).value == false;
    return AuthFormScaffold(
      offlineMessage: offline ? LogInScreen.offlineMessage : null,
      title: 'Welcome back',
      subtitle: 'Log in to keep your streak going.',
      footer: AuthLink(
        lead: 'New to Ishara?',
        label: 'Create account',
        onPressed: () => const SignUpRoute().pushReplacement(context),
      ),
      children: [
        AuthFields(
          children: [
            IsharaTextField(
              label: 'Email',
              controller: _email,
              enabled: !form.busy,
              errorText: form.errorFor(AuthField.email),
              prefixIcon: IsharaIcons.mail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
            ),
            PasswordField(
              field: AuthPasswordField.logIn,
              controller: _password,
              enabled: !form.busy,
              errorText: form.errorFor(AuthField.password),
              onSubmitted: (_) => _logIn(),
            ),
          ],
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: AuthLink(
            label: 'Forgot password?',
            onPressed: () => const ForgotPasswordRoute().push<void>(context),
          ),
        ),
        IsharaButton(
          label: form.pending == AuthSubmit.email ? 'Logging in…' : 'Log in',
          onPressed: form.busy || offline ? null : _logIn,
        ),
        const OrDivider(),
        GoogleSignInButton(
          onPressed: form.busy || offline
              ? null
              : ref.read(logInFormProvider.notifier).google,
        ),
      ],
    );
  }
}
