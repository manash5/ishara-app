import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';

/// Titled block used by every gallery section.
class GallerySection extends StatelessWidget {
  const GallerySection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: text.headlineSmall),
        if (subtitle != null) ...[
          const SizedBox(height: IsharaSpacing.s1),
          Text(
            subtitle!,
            style: text.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: IsharaSpacing.s4),
        ...children,
      ],
    );
  }
}

/// Small caption heading inside a section.
class GalleryCaption extends StatelessWidget {
  const GalleryCaption(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: IsharaSpacing.s4,
        bottom: IsharaSpacing.s2,
      ),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: context.colors.textSecondary),
      ),
    );
  }
}

/// `#RRGGBB` for a colour (alpha omitted when opaque).
String hexOf(Color color) {
  final argb = color.toARGB32();
  final rgb = (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();
  final a = argb >> 24;
  return a == 0xFF ? '#$rgb' : '#$rgb · ${(a / 255 * 100).round()}%';
}
