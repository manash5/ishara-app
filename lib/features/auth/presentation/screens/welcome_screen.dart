import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "02 Welcome" — placeholder until the real screen is built.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '02',
      name: 'Welcome',
      actions: [
        PlaceholderAction(
          'Sign up',
          () => const SignUpRoute().push<void>(context),
          primary: true,
        ),
        PlaceholderAction(
          'Log in',
          () => const LogInRoute().push<void>(context),
        ),
      ],
    );
  }
}
