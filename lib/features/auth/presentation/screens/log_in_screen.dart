import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';
import '../providers/fake_session_provider.dart';

/// Figma "04 Log in" — placeholder until the real screen is built.
class LogInScreen extends ConsumerWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenPlaceholder(
      frame: '04',
      name: 'Log in',
      actions: [
        PlaceholderAction(
          'Log in',
          () => ref.read(fakeSessionProvider.notifier).logIn(),
          primary: true,
        ),
        PlaceholderAction(
          'Forgot password?',
          () => const ForgotPasswordRoute().push<void>(context),
        ),
      ],
    );
  }
}
