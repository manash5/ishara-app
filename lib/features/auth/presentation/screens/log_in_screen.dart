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

/// Figma "04 Log in" (7:206).
///
/// UI-only phase: "Log in" and Google log the fake session in; the router
/// redirect then moves on to Learn. The password error comes from
/// [logInPasswordErrorProvider] (always null until the data layer lands).
class LogInScreen extends ConsumerWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordError = ref.watch(logInPasswordErrorProvider);
    return AuthFormScaffold(
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
            const IsharaTextField(
              label: 'Email',
              prefixIcon: IsharaIcons.mail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: [AutofillHints.email],
            ),
            PasswordField(
              field: AuthPasswordField.logIn,
              errorText: passwordError,
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
          label: 'Log in',
          onPressed: () => ref.read(fakeSessionProvider.notifier).logIn(),
        ),
        const OrDivider(),
        GoogleSignInButton(
          onPressed: () => ref.read(fakeSessionProvider.notifier).logIn(),
        ),
      ],
    );
  }
}
