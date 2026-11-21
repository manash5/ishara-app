import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'ishara_icon_button.dart';

/// Figma `LessonProgressHeader` (flat): close button, a 10dp progress pill
/// (border/default track, accent/default value) and remaining hearts.
///
/// Progress changes animate in `standard`/`move` (motion.md).
class LessonProgressHeader extends StatelessWidget {
  const LessonProgressHeader({
    super.key,
    required this.progress,
    required this.hearts,
    required this.onClose,
  });

  /// 0–1.
  final double progress;
  final int hearts;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final value = progress.clamp(0.0, 1.0);
    return SizedBox(
      height: IsharaSizes.lessonHeaderHeight,
      child: Padding(
        padding: const EdgeInsets.only(
          left: IsharaSpacing.s1,
          right: IsharaSpacing.s5,
        ),
        child: Row(
          children: [
            IsharaIconButton(
              icon: IsharaIcons.close,
              tooltip: 'Close lesson',
              color: c.textSecondary,
              onPressed: onClose,
            ),
            const SizedBox(width: IsharaSpacing.s2),
            Expanded(
              child: Semantics(
                container: true,
                label: 'Lesson progress',
                value: '${(value * 100).round()}%',
                excludeSemantics: true,
                child: ClipRRect(
                  borderRadius: IsharaRadius.brFull,
                  child: SizedBox(
                    height: IsharaSizes.progressBarHeight,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: value),
                      duration: IsharaMotion.duration(
                        context,
                        IsharaMotion.standard,
                      ),
                      curve: IsharaMotion.move,
                      builder: (context, v, _) => Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(color: c.borderDefault),
                          FractionallySizedBox(
                            key: const ValueKey('lesson-progress-value'),
                            alignment: Alignment.centerLeft,
                            widthFactor: v,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: c.accentDefault,
                                borderRadius: IsharaRadius.brFull,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: IsharaSpacing.s2),
            Semantics(
              container: true,
              label: '$hearts hearts left',
              excludeSemantics: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IsharaFilledIcon(
                    IsharaFilledIconKind.heart,
                    size: IsharaSizes.iconLg,
                    color: c.dangerDefault,
                  ),
                  const SizedBox(width: IsharaSizes.statsIconGap),
                  Text(
                    '$hearts',
                    style: context.textStyles.titleMedium.copyWith(
                      color: c.dangerDefault,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
