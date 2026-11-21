import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "07 Dominant hand" — placeholder until the real screen is built.
class DominantHandScreen extends StatelessWidget {
  const DominantHandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '07',
      name: 'Dominant hand',
      actions: [
        PlaceholderAction(
          'Continue',
          () => const CameraPermissionRoute().push<void>(context),
          primary: true,
        ),
      ],
    );
  }
}
