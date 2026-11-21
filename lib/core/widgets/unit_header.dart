import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'src/lip_surface.dart';

/// Figma `UnitHeader` → `color`.
enum UnitColor { teal, mint, lavender, lime }

/// Figma `UnitHeader` (roadmap kit — 3D lip): the coloured banner at the top
/// of each unit on the Learn path, with an outlined "Guidebook" button.
///
/// Text on teal is white; on mint / lavender / lime it is fun/teal-hero
/// (ui.md: text and icons on light fills use funTealHero).
class UnitHeader extends StatelessWidget {
  const UnitHeader({
    super.key,
    required this.unit,
    required this.title,
    required this.learned,
    required this.total,
    required this.onGuide,
    this.color = UnitColor.teal,
    this.guideLabel = 'Guidebook',
  });

  final int unit;
  final String title;
  final int learned;
  final int total;
  final UnitColor color;
  final VoidCallback? onGuide;
  final String guideLabel;

  /// (face, lip, foreground) for [color].
  static (Color, Color, Color) colorsFor(IsharaColors c, UnitColor color) =>
      switch (color) {
        UnitColor.teal => (c.funTealHero, c.funTealHeroLip, c.staticWhite),
        UnitColor.mint => (c.funMint, c.funMintLip, c.funTealHero),
        UnitColor.lavender => (c.funLavender, c.funLavenderLip, c.funTealHero),
        UnitColor.lime => (c.funLime, c.funLimeLip, c.funTealHero),
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final (face, lip, fg) = colorsFor(c, color);
    final subtitle = '$learned of $total signs learned';

    return LipSurface(
      faceColor: face,
      lipColor: lip,
      lipHeight: IsharaSizes.lipCard,
      borderRadius: IsharaRadius.brLg,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          IsharaSizes.unitHeaderPaddingLeft,
          IsharaSpacing.s4,
          IsharaSpacing.s4,
          // Figma: the 4px lip sits below the 20px padding (104 tall).
          IsharaSizes.unitHeaderPaddingBottom,
        ),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                container: true,
                header: true,
                label: 'Unit $unit: $title, $subtitle',
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Unit $unit'.toUpperCase(),
                      style: s.labelSmall.copyWith(color: fg),
                    ),
                    const SizedBox(height: IsharaSizes.titleGap),
                    Text(title, style: s.titleLarge.copyWith(color: fg)),
                    const SizedBox(height: IsharaSizes.titleGap),
                    Text(
                      subtitle,
                      style: s.bodySmall.copyWith(
                        color: fg.withValues(
                          alpha: IsharaSizes.subtitleOpacity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: IsharaSpacing.s3),
            Semantics(
              container: true,
              button: true,
              label: guideLabel,
              onTap: onGuide,
              excludeSemantics: true,
              child: LipPressDetector(
                onTap: onGuide,
                builder: (context, pressed) => LipSurface(
                  key: const ValueKey('unit-guide'),
                  faceColor: face,
                  lipColor: fg,
                  lipHeight: IsharaSizes.lipCard,
                  sideWidth: IsharaSizes.selectedBorder,
                  borderRadius: IsharaRadius.brMd,
                  pressed: pressed,
                  child: Padding(
                    // Figma guide (97×64): 2px border + 8 top, 10 bottom
                    // + 4px lip; LipSurface adds the border and lip.
                    padding: const EdgeInsets.fromLTRB(
                      IsharaSizes.guidePaddingX,
                      IsharaSpacing.s2,
                      IsharaSizes.guidePaddingX,
                      IsharaSizes.guidePaddingX,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IsharaIcons.bookOpen,
                          size: IsharaSizes.iconLg,
                          color: fg,
                        ),
                        const SizedBox(height: IsharaSizes.titleGap),
                        Text(
                          guideLabel.toUpperCase(),
                          style: s.labelSmall.copyWith(color: fg),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
