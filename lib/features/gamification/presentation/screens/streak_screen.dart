import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "27 Streak" — placeholder until the real screen is built.
class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '27',
      name: 'Streak',
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
