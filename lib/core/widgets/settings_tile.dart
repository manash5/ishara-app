import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'ishara_switch.dart';

/// Figma `SettingsTile` → `trailing`.
enum SettingsTrailing { chevron, toggle, value }

/// Figma `SettingsTile`: 56dp row with a lavender icon box, body/large label
/// and a trailing chevron, switch or value + chevron.
///
/// For [SettingsTrailing.toggle] the whole row toggles [switchValue].
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.trailing = SettingsTrailing.chevron,
    this.value,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final SettingsTrailing trailing;

  /// Shown for [SettingsTrailing.value], e.g. "7:00 PM".
  final String? value;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final isToggle = trailing == SettingsTrailing.toggle;
    final VoidCallback? tap = isToggle
        ? (onSwitchChanged == null
              ? null
              : () => onSwitchChanged!(!switchValue))
        : onTap;
    final chevron = Icon(
      IsharaIcons.chevronRight,
      size: IsharaSizes.iconMd,
      color: c.textTertiary,
    );

    final Widget trailingWidget = switch (trailing) {
      SettingsTrailing.chevron => chevron,
      SettingsTrailing.toggle => ExcludeSemantics(
        child: IsharaSwitch(
          value: switchValue,
          onChanged: onSwitchChanged,
          semanticLabel: label,
        ),
      ),
      SettingsTrailing.value => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value!, style: s.bodyMedium.copyWith(color: c.textSecondary)),
          const SizedBox(width: IsharaSpacing.s1),
          chevron,
        ],
      ),
    };

    return Semantics(
      container: true,
      button: !isToggle && tap != null,
      toggled: isToggle ? switchValue : null,
      enabled: tap != null,
      label: [label, if (trailing == SettingsTrailing.value) ?value].join(', '),
      onTap: tap,
      excludeSemantics: true,
      child: InkWell(
        onTap: tap,
        borderRadius: IsharaRadius.brLg,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: IsharaSizes.settingsTileHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: IsharaSpacing.s4,
              vertical: IsharaSpacing.s2,
            ),
            child: Row(
              children: [
                Container(
                  width: IsharaSizes.iconBoxSm,
                  height: IsharaSizes.iconBoxSm,
                  decoration: BoxDecoration(
                    color: c.funLavenderSubtle,
                    borderRadius: IsharaRadius.brSm,
                  ),
                  child: Icon(
                    icon,
                    size: IsharaSizes.settingsIcon,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(width: IsharaSpacing.s3),
                Expanded(
                  child: Text(
                    label,
                    style: s.bodyLarge.copyWith(color: c.textPrimary),
                  ),
                ),
                const SizedBox(width: IsharaSpacing.s3),
                trailingWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
