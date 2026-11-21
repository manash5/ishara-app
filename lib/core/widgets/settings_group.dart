import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `SettingsGroup` (named in the SettingsTile description; Settings
/// 12:1482, 12:1528, 12:1567): a label/small uppercase caption over a
/// bg/surface card (hairline border/subtle, radius lg, 4dp vertical padding)
/// holding [SettingsTile]s.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.title, required this.tiles});

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(
            title.toUpperCase(),
            style: s.labelSmall.copyWith(color: c.textSecondary),
          ),
        ),
        const SizedBox(height: IsharaSpacing.stackGap),
        Material(
          color: c.bgSurface,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: IsharaRadius.brLg,
            side: BorderSide(color: c.borderSubtle),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: IsharaSpacing.s1),
            child: Column(mainAxisSize: MainAxisSize.min, children: tiles),
          ),
        ),
      ],
    );
  }
}
