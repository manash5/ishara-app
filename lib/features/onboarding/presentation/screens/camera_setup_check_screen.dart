import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/screen_placeholder.dart';
import '../../../auth/presentation/providers/fake_session_provider.dart';

/// Figma "09 Camera setup check" — placeholder until the real screen is built.
///
/// Finishing onboarding lets the redirect take the learner to /learn.
class CameraSetupCheckScreen extends ConsumerWidget {
  const CameraSetupCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenPlaceholder(
      frame: '09',
      name: 'Camera setup check',
      actions: [
        PlaceholderAction(
          'Finish',
          () => ref.read(fakeSessionProvider.notifier).completeOnboarding(),
          primary: true,
        ),
      ],
    );
  }
}
