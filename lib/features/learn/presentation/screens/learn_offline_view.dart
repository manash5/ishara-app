import 'package:material_ui/material_ui.dart';

import '../../../../core/router/screen_placeholder.dart';

/// Figma "12 Learn – offline": the Learn tab's offline state (not a route).
class LearnOfflineView extends StatelessWidget {
  const LearnOfflineView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '12',
      name: 'Learn – offline',
      inShell: true,
      actions: [PlaceholderAction('Try again', onRetry, primary: true)],
    );
  }
}
