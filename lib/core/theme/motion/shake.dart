import 'package:material_ui/material_ui.dart';

import '../ishara_motion.dart';

/// Wrong-answer feedback: one short horizontal shake (±[IsharaMotion.shakeOffset]
/// over [IsharaMotion.shakeDuration]) every time [trigger] changes.
///
/// Increment [trigger] to shake. With reduced motion nothing moves — pair it
/// with a colour change so the feedback is still visible.
class Shake extends StatefulWidget {
  const Shake({super.key, required this.trigger, required this.child});

  final int trigger;
  final Widget child;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: IsharaMotion.shakeDuration,
  );

  // 0 → +1 → −1 → +½ → 0, in units of shakeOffset.
  late final Animation<double> _offset = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1, end: -1), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -1, end: 0.5), weight: 1.5),
    TweenSequenceItem(tween: Tween(begin: 0.5, end: 0), weight: 1),
  ]).animate(CurvedAnimation(parent: _controller, curve: IsharaMotion.move));

  @override
  void didUpdateWidget(Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger && !IsharaMotion.reduced(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) => Transform.translate(
        offset: Offset(_offset.value * IsharaMotion.shakeOffset, 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}
