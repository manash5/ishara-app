import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `SelectionCard` (`state` default | selected): an icon, title,
/// description and radio, using the shared [SelectionHighlight] decoration
/// (1.5px border/default → 2px fun/lavender on fun/lavender-subtle).
class SelectionCard extends StatelessWidget {
  const SelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final duration = IsharaMotion.duration(context, IsharaMotion.fast);
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      enabled: onTap != null,
      label: '$title, $description',
      onTap: onTap,
      excludeSemantics: true,
      child: PressableScale(
        enabled: onTap != null,
        onPressed: onTap,
        child: SelectionHighlight(
          selected: selected,
          child: Padding(
            padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: duration,
                  curve: IsharaMotion.move,
                  width: IsharaSizes.iconBoxMd,
                  height: IsharaSizes.iconBoxMd,
                  decoration: BoxDecoration(
                    color: selected ? c.bgSurface : c.funLavenderSubtle,
                    borderRadius: IsharaRadius.brMd,
                  ),
                  child: Icon(
                    icon,
                    size: IsharaSizes.iconMd,
                    // Figma screens 06/07: accent on the white box.
                    color: selected ? c.accentDefault : c.textPrimary,
                  ),
                ),
                const SizedBox(width: IsharaSpacing.s4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: s.titleMedium.copyWith(color: c.textPrimary),
                      ),
                      const SizedBox(height: IsharaSizes.titleGap),
                      Text(
                        description,
                        style: s.bodySmall.copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: IsharaSpacing.s4),
                AnimatedContainer(
                  key: const ValueKey('selection-radio'),
                  duration: duration,
                  curve: IsharaMotion.move,
                  width: IsharaSizes.radio,
                  height: IsharaSizes.radio,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? c.funLavenderLip : null,
                    border: selected
                        ? null
                        : Border.all(
                            color: c.borderStrong,
                            width: IsharaSizes.selectedBorder,
                          ),
                  ),
                  child: selected
                      ? Icon(
                          IsharaIcons.check,
                          size: IsharaSizes.iconXs,
                          color: c.staticWhite,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
