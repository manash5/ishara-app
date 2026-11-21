import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "16 Profile" — placeholder until the real screen is built.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '16',
      name: 'Profile',
      inShell: true,
      actions: [
        PlaceholderAction(
          'Settings',
          () => const SettingsRoute().push<void>(context),
          primary: true,
        ),
        PlaceholderAction(
          'Streak',
          () => const StreakRoute().push<void>(context),
        ),
      ],
    );
  }
}
