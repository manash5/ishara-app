import 'package:material_ui/material_ui.dart';

import '../ishara_motion.dart';

/// Counters on the lesson results (XP, streak) count up from [from] to
/// [value] in [IsharaMotion.celebrate] (motion.md). With reduced motion the
/// final value shows at once.
///
/// [builder] receives the current whole number, so callers keep their own
/// formatting and widget (e.g. `StatCard(value: '+$n')`).
class CountUp extends StatelessWidget {
  const CountUp({
    super.key,
    required this.value,
    required this.builder,
    this.from = 0,
  });

  final int value;
  final int from;
  final Widget Function(BuildContext context, int value) builder;

  @override
  Widget build(BuildContext context) {
    if (IsharaMotion.reduced(context)) return builder(context, value);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: from.toDouble(), end: value.toDouble()),
      duration: IsharaMotion.celebrate,
      curve: IsharaMotion.enter,
      builder: (context, v, _) => builder(context, v.round()),
    );
  }
}
