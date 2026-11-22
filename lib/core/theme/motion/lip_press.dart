import 'package:material_ui/material_ui.dart';

import '../ishara_motion.dart';
import '../ishara_sizes.dart';

/// Lip heights of the gamified roadmap kit (Figma: 4px buttons/cards, 6px path nodes).
abstract final class IsharaLip {
  static const double standard = IsharaSizes.lipCard;
  static const double pathNode = IsharaSizes.lipNode;
}

/// Press feedback for 3D roadmap elements: the face drops into its lip by
/// [lipHeight] while [pressed], instead of scaling.
///
/// The caller owns the pressed state (it also hides the lip when pressed).
/// With reduced motion the change is instant.
class LipPress extends StatelessWidget {
  const LipPress({
    super.key,
    required this.pressed,
    required this.child,
    this.lipHeight = IsharaLip.standard,
  });

  final bool pressed;
  final double lipHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: pressed ? lipHeight : 0),
      duration: IsharaMotion.duration(context, IsharaMotion.instant),
      curve: IsharaMotion.move,
      builder: (context, dy, child) =>
          Transform.translate(offset: Offset(0, dy), child: child),
      child: child,
    );
  }
}
