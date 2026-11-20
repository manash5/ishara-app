import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `SectionHeader`: title/medium on the left, optional accent action
/// (label/large) on the right (Figma `showAction`).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: s.titleMedium.copyWith(color: c.textPrimary),
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
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
                  child: Text(
                    actionLabel!,
                    style: s.labelLarge.copyWith(color: c.accentText),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
