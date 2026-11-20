import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `IsharaChip` → `tone`.
enum IsharaChipTone { accent, neutral, success, danger }

/// Figma `IsharaChip`: a 24dp status pill (non-interactive).
class IsharaChip extends StatelessWidget {
  const IsharaChip({
    super.key,
    required this.label,
    this.tone = IsharaChipTone.accent,
    this.icon,
  });

  final String label;
  final IsharaChipTone tone;

  /// Figma `showIcon` + `icon` (14dp).
  final IconData? icon;

  /// (background, foreground) for [tone].
  static (Color, Color) colorsFor(IsharaColors c, IsharaChipTone tone) =>
      switch (tone) {
        IsharaChipTone.accent => (c.accentSubtle, c.accentText),
        IsharaChipTone.neutral => (c.bgSurfaceMuted, c.textSecondary),
        IsharaChipTone.success => (c.successSubtle, c.successText),
        IsharaChipTone.danger => (c.dangerSubtle, c.dangerText),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = colorsFor(context.colors, tone);
    return Semantics(
      container: true,
      label: label,
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: IsharaSizes.chipHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: IsharaSizes.chipPaddingX,
          vertical: IsharaSpacing.s1,
        ),
        decoration: BoxDecoration(color: bg, borderRadius: IsharaRadius.brFull),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: IsharaSizes.iconXs, color: fg),
              const SizedBox(width: IsharaSpacing.s1),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.labelMedium.copyWith(color: fg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
