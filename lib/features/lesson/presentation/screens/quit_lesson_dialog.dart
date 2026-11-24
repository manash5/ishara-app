import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/widgets.dart';

/// Figma "29 Quit lesson dialog": shown on Android back or the close button
/// in a lesson. Quitting discards the lesson's progress (the streak is safe)
/// and returns to Learn.
Future<void> showQuitLessonDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => QuitLessonDialog(
      onKeepLearning: () => Navigator.of(dialogContext).pop(),
      onQuit: () {
        Navigator.of(dialogContext).pop();
        const LearnRoute().go(context);
      },
    ),
  );
}

/// Figma 29 content in the shared [ConfirmDialog].
class QuitLessonDialog extends StatelessWidget {
  const QuitLessonDialog({
    super.key,
    required this.onQuit,
    required this.onKeepLearning,
  });

  final VoidCallback onQuit;
  final VoidCallback onKeepLearning;

  @override
  Widget build(BuildContext context) => ConfirmDialog(
    title: 'Quit this lesson?',
    body: 'Your progress in this lesson won’t be saved. Your streak is safe.',
    confirmLabel: 'Quit',
    cancelLabel: 'Keep learning',
    onConfirm: onQuit,
    onCancel: onKeepLearning,
  );
}
