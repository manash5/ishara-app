import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'src/lip_surface.dart';

/// Figma `StatsBar` (roadmap kit): the Learn tab header — a 3D course badge
/// on the left; streak, XP (fun/gold) and hearts (danger) on the right.
class StatsBar extends StatelessWidget {
  const StatsBar({
    super.key,
    required this.streak,
    required this.xp,
    required this.hearts,
    this.courseLabel = 'NSL',
    this.courseName = 'Nepali Sign Language',
    this.onCourse,
  });

  final int streak;
  final int xp;
  final int hearts;
  final String courseLabel;

  /// Spoken name of the course for screen readers.
  final String courseName;
  final VoidCallback? onCourse;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;

    Widget stat(
      IsharaFilledIconKind kind,
      Color iconColor,
      int value,
      Color fg,
    ) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IsharaFilledIcon(kind, size: IsharaSizes.iconLg, color: iconColor),
        const SizedBox(width: IsharaSizes.statsIconGap),
        Text('$value', style: s.titleMedium.copyWith(color: fg)),
      ],
    );

    return SizedBox(
      height: IsharaSizes.statsBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: IsharaSpacing.screenMargin,
        ),
        child: Row(
          children: [
            Semantics(
              container: true,
              button: onCourse != null,
              label: 'Course: $courseName',
              onTap: onCourse,
              excludeSemantics: true,
              child: LipPressDetector(
                onTap: onCourse,
                builder: (context, pressed) => SizedBox(
                  width: IsharaSizes.courseBadgeWidth,
                  height: IsharaSizes.courseBadgeHeight,
                  child: LipSurface(
                    key: const ValueKey('course-badge'),
                    faceColor: c.accentDefault,
                    lipColor: c.accentLip,
                    lipHeight: IsharaSizes.lipBadge,
                    borderRadius: IsharaRadius.brSm,
                    pressed: pressed,
                    child: Center(
                      child: Text(
                        courseLabel,
                        style: s.labelMedium.copyWith(color: c.textOnAccent),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Semantics(
              container: true,
              label: '$streak day streak, $xp XP, $hearts hearts',
              excludeSemantics: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  stat(
                    IsharaFilledIconKind.flame,
                    c.funGold,
                    streak,
                    c.funGoldLip,
                  ),
                  const SizedBox(width: IsharaSizes.statsGap),
                  stat(IsharaFilledIconKind.zap, c.funGold, xp, c.funGoldLip),
                  const SizedBox(width: IsharaSizes.statsGap),
                  stat(
                    IsharaFilledIconKind.heart,
                    c.dangerDefault,
                    hearts,
                    c.dangerDefault,
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
