import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "06 Daily goal" — placeholder until the real screen is built.
class DailyGoalScreen extends StatelessWidget {
  const DailyGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '06',
      name: 'Daily goal',
      actions: [
        PlaceholderAction(
          'Continue',
          () => const DominantHandRoute().push<void>(context),
          primary: true,
        ),
      ],
    );
  }
}
