import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';
import 'gallery_section.dart';

/// The 12 Figma text styles with their specs.
class TypeSection extends StatelessWidget {
  const TypeSection({super.key});

  static const _sample = 'Sign with confidence';
  static const _glyphSample = 'क ख ग';

  static String specOf(TextStyle s) {
    final size = s.fontSize!;
    final line = (s.height! * size).round();
    final weight = s.fontWeight!.value;
    final tracking = (s.letterSpacing ?? 0) / size * 100;
    final trackingLabel = tracking == 0
        ? ''
        : ' · ${tracking > 0 ? '+' : ''}${tracking.toStringAsFixed(1)}%';
    return '${size.round()}/$line · w$weight · ${s.fontFamily}$trackingLabel';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return GallerySection(
      title: 'Typography',
      subtitle: 'Plus Jakarta Sans · custom/glyph = Anek Devanagari',
      children: [
        for (final MapEntry(key: name, value: style)
            in context.textStyles.byFigmaName.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: IsharaSpacing.listGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: text.labelMedium),
                Text(
                  specOf(style),
                  style: text.bodySmall?.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: IsharaSpacing.s1),
                Text(switch (name) {
                  'custom/glyph' => _glyphSample,
                  'label/small' => _sample.toUpperCase(),
                  _ => _sample,
                }, style: style.copyWith(color: c.textPrimary)),
              ],
            ),
          ),
      ],
    );
  }
}
