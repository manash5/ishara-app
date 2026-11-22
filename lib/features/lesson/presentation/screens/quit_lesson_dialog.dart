import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
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

/// The dialog body of Figma 29: bg/surface-raised, 28dp corners, 312 wide,
/// title/large + body/medium, and right-aligned 48dp text actions.
class QuitLessonDialog extends StatelessWidget {
  const QuitLessonDialog({
    super.key,
    required this.onQuit,
    required this.onKeepLearning,
  });

  final VoidCallback onQuit;
  final VoidCallback onKeepLearning;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Dialog(
      backgroundColor: c.bgSurfaceRaised,
      shape: const RoundedRectangleBorder(borderRadius: IsharaRadius.brSheet),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: IsharaSizes.dialogWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            IsharaSpacing.s6,
            IsharaSpacing.s6,
            IsharaSpacing.s6,
            IsharaSpacing.s5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Quit this lesson?',
                  style: s.titleLarge.copyWith(color: c.textPrimary),
                ),
              ),
              const SizedBox(height: IsharaSpacing.s4),
              Text(
                'Your progress in this lesson won’t be saved. '
                'Your streak is safe.',
                style: s.bodyMedium.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: IsharaSpacing.s4),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: IsharaSpacing.s2,
                children: [
                  IsharaButton(
                    label: 'Quit',
                    variant: IsharaButtonVariant.text,
                    tone: IsharaButtonTone.danger,
                    compact: true,
                    expanded: false,
                    onPressed: onQuit,
                  ),
                  IsharaButton(
                    label: 'Keep learning',
                    variant: IsharaButtonVariant.text,
                    compact: true,
                    expanded: false,
                    onPressed: onKeepLearning,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
