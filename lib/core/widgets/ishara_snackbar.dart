import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `IsharaSnackbar`: floating, bg/inverse, radius lg, elevation/2.
///
/// Use [IsharaSnackbar.show] to display it; the widget itself is the content
/// row (icon · message · optional action) so it can also be embedded.
class IsharaSnackbar extends StatelessWidget {
  const IsharaSnackbar({
    super.key,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData? icon;

  /// Figma `action` + `showAction`. Shown only when [onAction] is set too.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// How long the snackbar stays visible (reading time, not an animation).
  static const Duration displayDuration = Duration(seconds: 4);

  /// Shows the snackbar via the nearest [ScaffoldMessenger].
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = displayDuration,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    return messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        duration: duration,
        content: IsharaSnackbar(
          message: message,
          icon: icon,
          actionLabel: actionLabel,
          onAction: onAction == null
              ? null
              : () {
                  messenger.hideCurrentSnackBar(
                    reason: SnackBarClosedReason.action,
                  );
                  onAction();
                },
        ),
        dismissDirection: DismissDirection.down,
        clipBehavior: Clip.none,
      ),
      snackBarAnimationStyle: AnimationStyle(
        duration: IsharaMotion.standard,
        reverseDuration: IsharaMotion.exitDuration(IsharaMotion.standard),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Semantics(
      liveRegion: true,
      container: true,
      // Figma: 14 vertical padding around the 22px message (50 tall). The
      // padding sits on the message so the 48dp action target fits inside
      // that height instead of stretching the bar.
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: IsharaSpacing.s4),
        decoration: BoxDecoration(
          color: c.bgInverse,
          borderRadius: IsharaRadius.brLg,
          boxShadow: IsharaElevation.level2,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: IsharaSizes.iconMd, color: c.textInverse),
              const SizedBox(width: IsharaSpacing.s3),
            ],
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: IsharaSizes.snackbarPaddingY,
                ),
                child: Text(
                  message,
                  style: s.bodyMedium.copyWith(color: c.textInverse),
                ),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(width: IsharaSpacing.s3),
              Semantics(
                container: true,
                button: true,
                label: actionLabel,
                excludeSemantics: true,
                child: InkWell(
                  onTap: onAction,
                  borderRadius: IsharaRadius.brSm,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: IsharaSizes.minTouch,
                      minWidth: IsharaSizes.minTouch,
                    ),
                    child: Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: Text(
                        actionLabel!,
                        style: s.labelLarge.copyWith(
                          color: c.textInverse,
                          decoration: TextDecoration.underline,
                          decorationColor: c.textInverse,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
