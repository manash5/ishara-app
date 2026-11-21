import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/auth_form_providers.dart';
import '../providers/fake_session_provider.dart';
import '../widgets/auth_form_scaffold.dart';
import '../widgets/auth_link.dart';
import '../widgets/or_divider.dart';
import '../widgets/password_field.dart';

/// Figma "03 Sign up" (7:107).
///
/// UI-only phase: "Create account" signs up the fake session; the router
/// redirect then moves on to onboarding.
class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthFormScaffold(
      title: 'Create your account',
      subtitle: 'Save your streak and progress across devices.',
      footer: AuthLink(
        lead: 'Already have an account?',
        label: 'Log in',
        onPressed: () => const LogInRoute().pushReplacement(context),
      ),
      children: [
        const AuthFields(
          children: [
            IsharaTextField(
              label: 'Full name',
              prefixIcon: IsharaIcons.user,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: [AutofillHints.name],
            ),
            IsharaTextField(
              label: 'Email',
              prefixIcon: IsharaIcons.mail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: [AutofillHints.email],
            ),
            PasswordField(
              field: AuthPasswordField.signUp,
              hint: 'At least 8 characters',
              isNewPassword: true,
            ),
          ],
        ),
        IsharaButton(
          label: 'Create account',
          onPressed: () => ref.read(fakeSessionProvider.notifier).signUp(),
        ),
        const OrDivider(),
        GoogleSignInButton(
          onPressed: () => ref.read(fakeSessionProvider.notifier).logIn(),
        ),
      ],
    );
  }
}
