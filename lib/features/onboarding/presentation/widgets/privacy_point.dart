import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// Figma `privacyList` row (9:386): a 44dp fun/lavender-subtle icon square
/// and a body/medium line.
class PrivacyPoint extends StatelessWidget {
  const PrivacyPoint({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  /// Figma `iconSquare` 55:3734. TODO(ui): no IsharaSizes token for 44dp.
  static const double iconSquare = 44;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: Row(
        children: [
          Container(
            width: iconSquare,
            height: iconSquare,
            decoration: BoxDecoration(
              color: c.funLavenderSubtle,
              borderRadius: IsharaRadius.brMd,
            ),
            child: Icon(icon, size: IsharaSizes.iconMd, color: c.accentText),
          ),
          const SizedBox(width: IsharaSpacing.s4),
          Expanded(
            child: Text(
              text,
              style: context.textStyles.bodyMedium.copyWith(
                color: c.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
