import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/auth_form_providers.dart';
import '../widgets/auth_form_scaffold.dart';
import '../widgets/reset_link_sent_notice.dart';

/// Figma "05 Forgot password" (7:281).
///
/// Figma shows the sent state (success notice + "Resend link"); before
/// sending, the primary button reads "Send reset link" and there is no
/// notice. "Back to log in" returns to Log in.
class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  void _backToLogIn(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      const LogInRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sent = ref.watch(resetLinkSentProvider);
    return AuthFormScaffold(
      title: 'Reset your password',
      subtitle:
          'Enter the email you signed up with and we’ll send you a '
          'reset link.',
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IsharaButton(
            label: sent ? 'Resend link' : 'Send reset link',
            onPressed: () => ref.read(resetLinkSentProvider.notifier).send(),
          ),
          const SizedBox(height: IsharaSpacing.s3),
          IsharaButton(
            label: 'Back to log in',
            variant: IsharaButtonVariant.text,
            onPressed: () => _backToLogIn(context),
          ),
        ],
      ),
      children: [
        const IsharaTextField(
          label: 'Email',
          prefixIcon: IsharaIcons.mail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.send,
          autofillHints: [AutofillHints.email],
        ),
        if (sent) const ResetLinkSentNotice(),
      ],
    );
  }
}
