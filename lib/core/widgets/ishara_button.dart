import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `IsharaButton` → `variant`.
enum IsharaButtonVariant { filled, outlined, text }

/// Colour of a button (Figma instance overrides): accent (default), success
/// or danger. Filled buttons take it as their fill (e.g. `FeedbackSheet`);
/// text buttons as their label colour (e.g. "Quit" in the quit dialog, 29).
enum IsharaButtonTone { accent, success, danger }

/// Figma `IsharaButton`: flat, 56dp, radius lg, sentence-case label/large.
///
/// `state=disabled` in Figma = [onPressed] is null.
class IsharaButton extends StatelessWidget {
  const IsharaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = IsharaButtonVariant.filled,
    this.icon,
    this.expanded = true,
    this.tone = IsharaButtonTone.accent,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IsharaButtonVariant variant;

  /// Optional leading icon (Figma `showIcon` + `icon`), drawn at 20dp.
  final IconData? icon;

  /// Stretch to the available width (Figma buttons fill the content column).
  final bool expanded;

  /// Fill of a filled button, label colour of a text button; outlined
  /// buttons ignore it.
  final IsharaButtonTone tone;

  /// 48dp instead of 56dp — Figma dialog actions (AlertDialog in 29).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final filled = variant == IsharaButtonVariant.filled;
    final Color? toneFill = !filled
        ? null
        : switch (tone) {
            IsharaButtonTone.accent => null,
            IsharaButtonTone.success => c.successDefault,
            IsharaButtonTone.danger => c.dangerDefault,
          };
    final Color? toneText = variant != IsharaButtonVariant.text
        ? null
        : switch (tone) {
            IsharaButtonTone.accent => null,
            IsharaButtonTone.success => c.successText,
            IsharaButtonTone.danger => c.dangerText,
          };
    final height = compact ? IsharaSizes.minTouch : IsharaSizes.controlHeight;
    final style = ButtonStyle(
      backgroundColor: toneFill == null
          ? null
          : WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.disabled)
                  ? c.bgSurfaceMuted
                  : toneFill,
            ),
      foregroundColor: toneText == null
          ? null
          : WidgetStateProperty.resolveWith(
              (s) =>
                  s.contains(WidgetState.disabled) ? c.textTertiary : toneText,
            ),
      minimumSize: WidgetStatePropertyAll(
        Size(expanded ? double.infinity : IsharaSizes.minTouch, height),
      ),
      padding: compact
          ? const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: IsharaSpacing.s3),
            )
          : null,
      iconSize: const WidgetStatePropertyAll(IsharaSizes.iconMd),
    );
    final child = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
    final iconWidget = icon == null ? null : Icon(icon);

    final Widget button = switch (variant) {
      IsharaButtonVariant.filled =>
        iconWidget == null
            ? FilledButton(onPressed: onPressed, style: style, child: child)
            : FilledButton.icon(
                onPressed: onPressed,
                style: style,
                icon: iconWidget,
                label: child,
              ),
      IsharaButtonVariant.outlined =>
        iconWidget == null
            ? OutlinedButton(onPressed: onPressed, style: style, child: child)
            : OutlinedButton.icon(
                onPressed: onPressed,
                style: style,
                icon: iconWidget,
                label: child,
              ),
      IsharaButtonVariant.text =>
        iconWidget == null
            ? TextButton(onPressed: onPressed, style: style, child: child)
            : TextButton.icon(
                onPressed: onPressed,
                style: style,
                icon: iconWidget,
                label: child,
              ),
    };

    return PressableScale(enabled: onPressed != null, child: button);
  }
}
