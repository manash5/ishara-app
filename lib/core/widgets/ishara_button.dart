import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `IsharaButton` → `variant`.
enum IsharaButtonVariant { filled, outlined, text }

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
  });

  final String label;
  final VoidCallback? onPressed;
  final IsharaButtonVariant variant;

  /// Optional leading icon (Figma `showIcon` + `icon`), drawn at 20dp.
  final IconData? icon;

  /// Stretch to the available width (Figma buttons fill the content column).
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(
          expanded ? double.infinity : IsharaSizes.minTouch,
          IsharaSizes.controlHeight,
        ),
      ),
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
