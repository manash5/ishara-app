import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'ishara_button.dart';

/// Empty / no-results / error message for a list or screen: centred
/// title/medium + body/medium and an optional outlined action.
///
/// Shared by Dictionary (13–14) and Ranks (15). Figma has no empty/error
/// state component yet; this follows the kit's text and button styles.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;

  /// Shown only together with [onAction] (e.g. "Try again").
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: IsharaSpacing.s8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: s.titleMedium.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: IsharaSpacing.stackGap),
            Text(
              body,
              textAlign: TextAlign.center,
              style: s.bodyMedium.copyWith(color: c.textSecondary),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: IsharaSpacing.s4),
              IsharaButton(
                label: actionLabel!,
                variant: IsharaButtonVariant.outlined,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
