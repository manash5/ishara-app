import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "28 Out of hearts" — placeholder until the real screen is built.
class OutOfHeartsScreen extends StatelessWidget {
  const OutOfHeartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '28',
      name: 'Out of hearts',
      actions: [
        PlaceholderAction(
          'Back to Learn',
          () => const LearnRoute().go(context),
          primary: true,
        ),
      ],
    );
  }
}
