import 'package:material_ui/material_ui.dart';

/// Figma `IsharaSwitch` (`selected` true | false): an M3 switch styled by
/// `AppTheme.switchTheme` (52×32; accent track when on, muted track with a
/// 2px border/strong outline when off).
class IsharaSwitch extends StatelessWidget {
  const IsharaSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  /// What the switch controls, e.g. "Daily reminder".
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Switch(value: value, onChanged: onChanged),
    );
  }
}
