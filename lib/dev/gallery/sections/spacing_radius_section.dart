import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';
import 'gallery_section.dart';

/// Spacing scale, radius tokens and elevation styles.
class SpacingRadiusSection extends StatelessWidget {
  const SpacingRadiusSection({super.key});

  static const _spacing = {
    'space/1': IsharaSpacing.s1,
    'space/2': IsharaSpacing.s2,
    'space/3': IsharaSpacing.s3,
    'space/4': IsharaSpacing.s4,
    'space/5': IsharaSpacing.s5,
    'space/6': IsharaSpacing.s6,
    'space/8': IsharaSpacing.s8,
    'space/10': IsharaSpacing.s10,
    'space/12': IsharaSpacing.s12,
  };

  static const _layout = {
    'screenMargin': IsharaSpacing.screenMargin,
    'cardPadding': IsharaSpacing.cardPadding,
    'sectionGap': IsharaSpacing.sectionGap,
    'listGap': IsharaSpacing.listGap,
    'stackGap': IsharaSpacing.stackGap,
    'inlineGap': IsharaSpacing.inlineGap,
  };

  static const _radius = {
    'sm': IsharaRadius.sm,
    'md': IsharaRadius.md,
    'lg': IsharaRadius.lg,
    'xl': IsharaRadius.xl,
    'sheet': IsharaRadius.sheet,
    'full': IsharaRadius.full,
  };

  static const double _tile = IsharaSpacing.s12 + IsharaSpacing.s8;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final caption = text.bodySmall?.copyWith(color: c.textSecondary);

    Widget row(String name, double value) => Padding(
      padding: const EdgeInsets.only(bottom: IsharaSpacing.s2),
      child: Row(
        children: [
          SizedBox(
            width: _tile * 1.5,
            child: Text(name, style: text.labelMedium),
          ),
          Container(
            width: value,
            height: IsharaSpacing.s3,
            decoration: BoxDecoration(
              color: c.funLavender,
              borderRadius: IsharaRadius.brFull,
            ),
          ),
          const SizedBox(width: IsharaSpacing.inlineGap),
          Text('${value.round()}dp', style: caption),
        ],
      ),
    );

    return GallerySection(
      title: 'Spacing, shape & elevation',
      subtitle: '4-pt scale · IsharaSpacing · IsharaRadius · IsharaElevation',
      children: [
        const GalleryCaption('Spacing'),
        for (final e in _spacing.entries) row(e.key, e.value),
        const GalleryCaption('Layout aliases'),
        for (final e in _layout.entries) row(e.key, e.value),
        const GalleryCaption('Radius'),
        Wrap(
          spacing: IsharaSpacing.s3,
          runSpacing: IsharaSpacing.s3,
          children: [
            for (final e in _radius.entries)
              Column(
                children: [
                  Container(
                    width: _tile,
                    height: _tile,
                    decoration: BoxDecoration(
                      color: c.accentSubtle,
                      border: Border.all(color: c.accentDefault),
                      borderRadius: BorderRadius.circular(e.value),
                    ),
                  ),
                  const SizedBox(height: IsharaSpacing.s1),
                  Text('radius/${e.key}', style: caption),
                ],
              ),
          ],
        ),
        const GalleryCaption('Elevation'),
        Row(
          children: [
            for (final (name, shadows) in [
              ('elevation/1', IsharaElevation.level1),
              ('elevation/2', IsharaElevation.level2),
            ]) ...[
              Expanded(
                child: Container(
                  height: _tile,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.bgSurfaceRaised,
                    borderRadius: IsharaRadius.brLg,
                    boxShadow: shadows,
                  ),
                  child: Text(name, style: text.labelMedium),
                ),
              ),
              const SizedBox(width: IsharaSpacing.s4),
            ],
          ],
        ),
      ],
    );
  }
}
