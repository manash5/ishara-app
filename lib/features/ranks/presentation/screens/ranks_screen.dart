import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "15 Ranks" — placeholder until the real screen is built.
class RanksScreen extends StatelessWidget {
  const RanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '15',
      name: 'Ranks',
      inShell: true,
      actions: [
        PlaceholderAction('My profile', () => const ProfileRoute().go(context)),
      ],
    );
  }
}
