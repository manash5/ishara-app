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
  }) : selected = false,
       onTap = null,
       _filter = false;

  /// Figma filter chips (Dictionary 12:846): 32dp, tappable, selected =
  /// accent/subtle + accent/text, otherwise surface-muted + text/secondary.
  /// The tap target is padded to 48dp.
  const IsharaChip.filter({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : tone = IsharaChipTone.neutral,
       icon = null,
       _filter = true;

  final String label;

  /// Filter chips only.
  final bool selected;
  final VoidCallback? onTap;

  final bool _filter;
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
    if (_filter) return _buildFilter(context);
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

  Widget _buildFilter(BuildContext context) {
    final (bg, fg) = colorsFor(
      context.colors,
      selected ? IsharaChipTone.accent : IsharaChipTone.neutral,
    );
    final duration = IsharaMotion.duration(context, IsharaMotion.fast);
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: IsharaSizes.minTouch),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: AnimatedContainer(
              duration: duration,
              curve: IsharaMotion.move,
              height: IsharaSizes.filterChipHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: IsharaSizes.filterChipPaddingX,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: IsharaRadius.brFull,
              ),
              child: Text(
                label,
                maxLines: 1,
                style: context.textStyles.labelMedium.copyWith(color: fg),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
