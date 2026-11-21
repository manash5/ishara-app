import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';
import '../../../auth/presentation/providers/fake_session_provider.dart';

/// Figma "08 Camera permission" — placeholder until the real screen is built.
class CameraPermissionScreen extends ConsumerWidget {
  const CameraPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenPlaceholder(
      frame: '08',
      name: 'Camera permission',
      actions: [
        PlaceholderAction(
          'Allow camera',
          () => const CameraCheckRoute().push<void>(context),
          primary: true,
        ),
        PlaceholderAction(
          'Not now',
          () => ref.read(fakeSessionProvider.notifier).completeOnboarding(),
        ),
      ],
    );
  }
}
