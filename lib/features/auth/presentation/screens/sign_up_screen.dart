import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';
import '../providers/fake_session_provider.dart';

/// Figma "03 Sign up" — placeholder until the real screen is built.
class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenPlaceholder(
      frame: '03',
      name: 'Sign up',
      actions: [
        PlaceholderAction(
          'Create account',
          () => ref.read(fakeSessionProvider.notifier).signUp(),
          primary: true,
        ),
        PlaceholderAction(
          'I already have an account',
          () => const LogInRoute().pushReplacement(context),
        ),
      ],
    );
  }
}
