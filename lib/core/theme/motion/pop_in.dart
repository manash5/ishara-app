import 'package:material_ui/material_ui.dart';

import '../ishara_motion.dart';

/// Results-only entrance (motion.md "playful"): [child] pops from nothing
/// to full size with [IsharaMotion.playful] over [IsharaMotion.celebrate],
/// after an optional [delay]. With reduced motion it simply appears.
class PopIn extends StatefulWidget {
  const PopIn({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.delay + IsharaMotion.celebrate,
  );
  late final Animation<double> _scale = CurvedAnimation(
    parent: _controller,
    curve: Interval(_start, 1, curve: IsharaMotion.playful),
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Interval(_start, 1, curve: IsharaMotion.enter),
  );
  bool _started = false;

  double get _start =>
      widget.delay.inMicroseconds / _controller.duration!.inMicroseconds;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (IsharaMotion.reduced(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: ScaleTransition(scale: _scale, child: widget.child),
  );
}
