import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "13 Dictionary" — placeholder until the real screen is built.
class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '13',
      name: 'Dictionary',
      inShell: true,
      actions: [
        PlaceholderAction(
          'Namaste',
          () => const SignDetailRoute(signId: 'namaste').go(context),
        ),
        PlaceholderAction(
          'Thank you',
          () => const SignDetailRoute(signId: 'thank-you').go(context),
        ),
      ],
    );
  }
}
