import 'package:material_ui/material_ui.dart';

import '../ishara_motion.dart';
import '../ishara_radius.dart';
import '../ishara_sizes.dart';
import '../theme_extensions.dart';

/// Selection state for options and cards: 2px `funLavender` border on a
/// `funLavenderSubtle` fill when [selected], otherwise a 1.5px `borderDefault`
/// hairline on `bgSurface`. Animates in [IsharaMotion.fast].
class SelectionHighlight extends StatelessWidget {
  const SelectionHighlight({
    super.key,
    required this.selected,
    required this.child,
    this.borderRadius = IsharaRadius.brLg,
  });

  static const double selectedBorderWidth = IsharaSizes.selectedBorder;
  static const double borderWidth = IsharaSizes.outline;

  final bool selected;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnimatedContainer(
      duration: IsharaMotion.duration(context, IsharaMotion.fast),
      curve: IsharaMotion.move,
      decoration: BoxDecoration(
        color: selected ? c.funLavenderSubtle : c.bgSurface,
        borderRadius: borderRadius,
        border: Border.all(
          color: selected ? c.funLavender : c.borderDefault,
          width: selected ? selectedBorderWidth : borderWidth,
        ),
      ),
      child: child,
    );
  }
}
