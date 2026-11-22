import 'package:material_ui/material_ui.dart';

import '../config/game_rules.dart';
import '../theme/theme.dart';
import 'ishara_button.dart';

/// Shows Figma "28 Out of hearts" as a modal sheet over the lesson player
/// (lesson feature); the `/out-of-hearts` route (gamification) shows the
/// same [OutOfHeartsPanel] full-screen.
/// The learner must pick an action (no drag or tap-outside dismiss).
Future<void> showOutOfHeartsSheet(
  BuildContext context, {
  required VoidCallback onPractise,
  required VoidCallback onEndLesson,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    sheetAnimationStyle: IsharaFeedback.sheetAnimationStyle,
    builder: (_) => PopScope(
      canPop: false,
      child: OutOfHeartsPanel(onPractise: onPractise, onEndLesson: onEndLesson),
    ),
  );
}

/// Figma 28 `OutOfHeartsSheet`: bg/surface panel with 28dp top corners,
/// five empty hearts, title, explanation and two actions.
class OutOfHeartsPanel extends StatelessWidget {
  const OutOfHeartsPanel({
    super.key,
    required this.onPractise,
    required this.onEndLesson,
  });

  final VoidCallback onPractise;
  final VoidCallback onEndLesson;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.bgSurface,
        borderRadius: IsharaRadius.sheetTop,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            IsharaSpacing.screenMargin,
            IsharaSpacing.s8,
            IsharaSpacing.screenMargin,
            IsharaSpacing.s8 + IsharaSpacing.s1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'No hearts left',
                excludeSemantics: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < GameRules.maxHearts; i++) ...[
                      if (i > 0)
                        const SizedBox(width: IsharaSizes.sheetHeartGap),
                      Icon(
                        IsharaIcons.heart,
                        size: IsharaSizes.sheetHeart,
                        color: c.textTertiary,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: IsharaSpacing.s4),
              Semantics(
                header: true,
                liveRegion: true,
                child: Text(
                  'You’re out of hearts',
                  textAlign: TextAlign.center,
                  style: s.titleLarge.copyWith(color: c.textPrimary),
                ),
              ),
              const SizedBox(height: IsharaSpacing.s4),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: IsharaSpacing.s3,
                ),
                child: Text(
                  'Hearts refill every ${GameRules.heartRefillHours} hours — '
                  'or practise a review lesson to earn one back. '
                  'Camera mistakes never cost hearts.',
                  textAlign: TextAlign.center,
                  style: s.bodyMedium.copyWith(color: c.textSecondary),
                ),
              ),
              const SizedBox(height: IsharaSpacing.s4),
              IsharaButton(
                label: 'Practise to earn a heart',
                onPressed: onPractise,
              ),
              const SizedBox(height: IsharaSpacing.s4),
              IsharaButton(
                label: 'End lesson',
                variant: IsharaButtonVariant.outlined,
                onPressed: onEndLesson,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
