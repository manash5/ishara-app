import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `StatCard`: lavender-tinted card with an icon, a custom/stat value
/// and a body/small caption.
///
/// Pass either a filled icon [kind] (Figma uses `Icon/flame-fill`) or a
/// Lucide [icon]. The icon defaults to fun/gold (XP & streak).
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.caption,
    this.kind = IsharaFilledIconKind.flame,
    this.icon,
    this.iconColor,
  });

  final String value;
  final String caption;
  final IsharaFilledIconKind kind;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final color = iconColor ?? c.funGold;
    return Semantics(
      container: true,
      label: '$value $caption',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
        decoration: BoxDecoration(
          color: c.funLavenderSubtle,
          borderRadius: IsharaRadius.brLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, size: IsharaSizes.iconMd, color: color)
            else
              IsharaFilledIcon(kind, size: IsharaSizes.iconMd, color: color),
            const SizedBox(height: IsharaSpacing.stackGap),
            Text(value, style: s.stat.copyWith(color: c.textPrimary)),
            const SizedBox(height: IsharaSpacing.stackGap),
            Text(caption, style: s.bodySmall.copyWith(color: c.textSecondary)),
          ],
        ),
      ),
    );
  }
}
