import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "14 Sign detail" — placeholder until the real screen is built.
class SignDetailScreen extends StatelessWidget {
  const SignDetailScreen({super.key, required this.signId});

  final String signId;

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '14',
      name: 'Sign detail',
      inShell: true,
      extras: [Text('Sign: $signId')],
      actions: [
        PlaceholderAction(
          'Practise signing',
          () => const PracticeRoute().push<void>(context),
        ),
      ],
    );
  }
}
