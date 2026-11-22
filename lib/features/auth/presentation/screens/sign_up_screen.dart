import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/auth_form_providers.dart';
import '../widgets/auth_form_scaffold.dart';
import '../widgets/auth_link.dart';
import '../widgets/or_divider.dart';
import '../widgets/password_field.dart';

/// Figma "03 Sign up" (7:107).
///
/// "Create account" registers through [signUpFormProvider]; the new session
/// has onboarding to do, so the router redirect moves on to onboarding. A
/// taken email shows under Email, other errors under Password.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _register() {
    FocusScope.of(context).unfocus();
    ref
        .read(signUpFormProvider.notifier)
        .register(
          displayName: _name.text,
          email: _email.text,
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(signUpFormProvider);
    return AuthFormScaffold(
      title: 'Create your account',
      subtitle: 'Save your streak and progress across devices.',
      footer: AuthLink(
        lead: 'Already have an account?',
        label: 'Log in',
        onPressed: () => const LogInRoute().pushReplacement(context),
      ),
      children: [
        AuthFields(
          children: [
            IsharaTextField(
              label: 'Full name',
              controller: _name,
              enabled: !form.busy,
              prefixIcon: IsharaIcons.user,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
            ),
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
              field: AuthPasswordField.signUp,
              controller: _password,
              enabled: !form.busy,
              hint: 'At least 8 characters',
              errorText: form.errorFor(AuthField.password),
              isNewPassword: true,
              onSubmitted: (_) => _register(),
            ),
          ],
        ),
        IsharaButton(
          label: form.pending == AuthSubmit.email
              ? 'Creating account…'
              : 'Create account',
          onPressed: form.busy ? null : _register,
        ),
        const OrDivider(),
        GoogleSignInButton(
          onPressed: form.busy
              ? null
              : ref.read(signUpFormProvider.notifier).google,
        ),
      ],
    );
  }
}
