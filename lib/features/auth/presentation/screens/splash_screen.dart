import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "01 Splash" — placeholder until the real screen is built.
///
/// Continue asks for /learn and lets the session redirect decide.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '01',
      name: 'Splash',
      actions: [
        PlaceholderAction(
          'Continue',
          () => const LearnRoute().go(context),
          primary: true,
        ),
      ],
    );
  }
}
