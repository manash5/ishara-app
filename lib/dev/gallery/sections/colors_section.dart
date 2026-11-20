import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';
import 'gallery_section.dart';

/// Every `IsharaColors` token for the current brightness.
class ColorsSection extends StatelessWidget {
  const ColorsSection({super.key});

  static const double _swatchWidth = IsharaSpacing.s12 * 3;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return GallerySection(
      title: 'Colour',
      subtitle:
          'Figma collection “Color” · ${Theme.of(context).brightness.name}',
      children: [
        Wrap(
          spacing: IsharaSpacing.s3,
          runSpacing: IsharaSpacing.s4,
          children: [
            for (final MapEntry(key: name, value: color)
                in c.byFigmaName.entries)
              SizedBox(
                width: _swatchWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: IsharaSpacing.s12,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: IsharaRadius.brSm,
                        border: Border.all(color: c.borderSubtle),
                      ),
                    ),
                    const SizedBox(height: IsharaSpacing.s1),
                    Text(name, style: text.labelMedium),
                    Text(
                      hexOf(color),
                      style: text.bodySmall?.copyWith(color: c.textSecondary),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
