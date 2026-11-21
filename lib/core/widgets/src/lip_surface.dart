import 'package:material_ui/material_ui.dart';

import '../../theme/theme.dart';

/// Internal building block of the gamified roadmap kit (not exported).
///
/// Draws Figma's "lip": an outer shape in [lipColor] with the face inset on
/// top, leaving a darker band of [lipHeight] at the bottom (and an optional
/// uniform [sideWidth] border on the other sides). When [pressed], the face
/// drops into the lip (motion.md: 3D elements press *down*, not scale).
class LipSurface extends StatelessWidget {
  const LipSurface({
    super.key,
    required this.faceColor,
    required this.lipColor,
    required this.lipHeight,
    required this.child,
    this.borderRadius,
    this.sideWidth = 0,
    this.pressed = false,
  });

  final Color faceColor;
  final Color lipColor;
  final double lipHeight;

  /// Null = oval (path nodes); otherwise a rounded rectangle.
  final BorderRadius? borderRadius;

  /// Uniform border on top/left/right (e.g. the UnitHeader guide button).
  final double sideWidth;
  final bool pressed;
  final Widget child;

  ShapeBorder _shape(double inset) => borderRadius == null
      ? const OvalBorder()
      : RoundedRectangleBorder(
          borderRadius: borderRadius!.subtract(BorderRadius.circular(inset)),
        );

  @override
  Widget build(BuildContext context) {
    final duration = IsharaMotion.duration(context, IsharaMotion.instant);
    return DecoratedBox(
      decoration: ShapeDecoration(color: lipColor, shape: _shape(0)),
      child: AnimatedPadding(
        duration: duration,
        curve: IsharaMotion.move,
        padding: EdgeInsets.fromLTRB(
          sideWidth,
          pressed ? lipHeight : sideWidth,
          sideWidth,
          pressed ? sideWidth : lipHeight,
        ),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: faceColor,
            shape: _shape(sideWidth),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Tracks pointer-down so a [LipSurface] can show its pressed state.
class LipPressDetector extends StatefulWidget {
  const LipPressDetector({
    super.key,
    required this.onTap,
    required this.builder,
  });

  final VoidCallback? onTap;
  final Widget Function(BuildContext context, bool pressed) builder;

  @override
  State<LipPressDetector> createState() => _LipPressDetectorState();
}

class _LipPressDetectorState extends State<LipPressDetector> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _set(true) : null,
      onTapUp: enabled ? (_) => _set(false) : null,
      onTapCancel: enabled ? () => _set(false) : null,
      onTap: widget.onTap,
      child: widget.builder(context, _pressed && enabled),
    );
  }
}
