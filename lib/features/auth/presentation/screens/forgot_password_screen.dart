import 'package:material_ui/material_ui.dart';

import '../../../../core/router/screen_placeholder.dart';

/// Figma "05 Forgot password" — placeholder until the real screen is built.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '05',
      name: 'Forgot password',
      actions: [
        PlaceholderAction(
          'Send reset link',
          () => Navigator.of(context).pop(),
          primary: true,
        ),
      ],
    );
  }
}
