import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `IsharaIconButton` → `variant`.
enum IsharaIconButtonVariant { standard, tonal, onCamera }

/// Figma `IsharaIconButton`: 48dp circular icon button (24dp icon).
///
/// [tooltip] is required — it is the accessible label.
class IsharaIconButton extends StatelessWidget {
  const IsharaIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.variant = IsharaIconButtonVariant.standard,
    this.color,
    this.compact = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final IsharaIconButtonVariant variant;

  /// Icon colour override (Figma instance override), e.g. text/secondary.
  final Color? color;

  /// 20dp icon inside a text field (Figma I7:167;3:54); still a 48dp target.
  final bool compact;

  /// (background, foreground) for [variant].
  static (Color, Color) colorsFor(
    IsharaColors c,
    IsharaIconButtonVariant variant,
  ) => switch (variant) {
    IsharaIconButtonVariant.standard => (Colors.transparent, c.textPrimary),
    IsharaIconButtonVariant.tonal => (c.bgSurfaceMuted, c.textPrimary),
    IsharaIconButtonVariant.onCamera => (
      c.overlayScrim.withValues(alpha: IsharaSizes.cameraScrimOpacity),
      c.staticWhite,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, variantFg) = colorsFor(c, variant);
    final fg = color ?? variantFg;
    return PressableScale(
      enabled: onPressed != null,
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon),
        iconSize: compact ? IsharaSizes.iconMd : IsharaSizes.iconLg,
        style: IconButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg,
          disabledForegroundColor: c.textTertiary,
          fixedSize: const Size.square(IsharaSizes.minTouch),
          minimumSize: const Size.square(IsharaSizes.minTouch),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
