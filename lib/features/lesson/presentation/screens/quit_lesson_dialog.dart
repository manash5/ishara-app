import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/widgets.dart';

/// Figma "29 Quit lesson dialog": shown on Android back or the close button
/// in a lesson. Quitting discards the lesson's progress.
Future<void> showQuitLessonDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('29 · Quit lesson?'),
      content: const Text('You will lose your progress in this lesson.'),
      actions: [
        IsharaButton(
          label: 'Keep learning',
          variant: IsharaButtonVariant.text,
          expanded: false,
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
        IsharaButton(
          label: 'Quit',
          variant: IsharaButtonVariant.text,
          expanded: false,
          onPressed: () {
            Navigator.of(dialogContext).pop();
            const LearnRoute().go(context);
          },
        ),
      ],
    ),
  );
}
