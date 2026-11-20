import 'package:material_ui/material_ui.dart';

import '../ishara_motion.dart';

/// Press feedback for flat buttons and tappable cards: scales the child to
/// [IsharaMotion.pressScale] while a pointer is down.
///
/// Only adds the visual; pass [onPressed] to also make it tappable, or wrap an
/// already-tappable child (e.g. a `FilledButton`) and leave [onPressed] null.
/// With reduced motion the scale is skipped entirely.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onPressed,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _set(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && !IsharaMotion.reduced(context);
    final scaled = AnimatedScale(
      scale: active && _pressed ? IsharaMotion.pressScale : 1,
      duration: IsharaMotion.instant,
      curve: IsharaMotion.move,
      child: widget.child,
    );
    return Listener(
      onPointerDown: (_) => _set(widget.enabled),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: widget.onPressed == null
          ? scaled
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.enabled ? widget.onPressed : null,
              child: scaled,
            ),
    );
  }
}
