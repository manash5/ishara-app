import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'ishara_button.dart';

/// Asks before an action that can't be undone (Figma "29 Quit lesson" dialog
/// style). Resolves true when the learner confirms, false otherwise
/// (cancel, tap outside, back).
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = true,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => ConfirmDialog(
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      destructive: destructive,
      onConfirm: () => Navigator.of(dialogContext).pop(true),
      onCancel: () => Navigator.of(dialogContext).pop(false),
    ),
  );
  return confirmed ?? false;
}

/// The dialog body of Figma 29: bg/surface-raised, 28dp corners, 312 wide,
/// title/large + body/medium, and right-aligned 48dp text actions — the
/// confirm action first, in danger when [destructive].
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
    this.destructive = true,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Dialog(
      backgroundColor: c.bgSurfaceRaised,
      shape: const RoundedRectangleBorder(borderRadius: IsharaRadius.brSheet),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: IsharaSizes.dialogWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            IsharaSpacing.s6,
            IsharaSpacing.s6,
            IsharaSpacing.s6,
            IsharaSpacing.s5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: s.titleLarge.copyWith(color: c.textPrimary),
                ),
              ),
              const SizedBox(height: IsharaSpacing.s4),
              Text(body, style: s.bodyMedium.copyWith(color: c.textSecondary)),
              const SizedBox(height: IsharaSpacing.s4),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: IsharaSpacing.s2,
                children: [
                  IsharaButton(
                    label: confirmLabel,
                    variant: IsharaButtonVariant.text,
                    tone: destructive
                        ? IsharaButtonTone.danger
                        : IsharaButtonTone.accent,
                    compact: true,
                    expanded: false,
                    onPressed: onConfirm,
                  ),
                  IsharaButton(
                    label: cancelLabel,
                    variant: IsharaButtonVariant.text,
                    compact: true,
                    expanded: false,
                    onPressed: onCancel,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
