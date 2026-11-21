import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';
import '../../../auth/presentation/providers/fake_session_provider.dart';

/// Figma "17 Settings" — placeholder.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(fakeSessionProvider.notifier);
    return ScreenPlaceholder(
      frame: '17',
      name: 'Settings',
      actions: [
        PlaceholderAction('Log out', session.logOut, primary: true),
        PlaceholderAction(
          'Redo onboarding',
          () => session.setOnboardingDone(false),
        ),
        if (kDebugMode)
          PlaceholderAction(
            'Widget gallery (debug)',
            () => const GalleryRoute().push<void>(context),
          ),
      ],
    );
  }
}
