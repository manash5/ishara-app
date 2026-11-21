import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `StepIndicator` (`step` 1 | 2 | 3, generalised to any [total]).
///
/// Bars are 8dp pills with a 6dp gap; the current step is 28dp wide, the
/// others 12dp. Done and current steps are accent/default, upcoming steps
/// border/default. Width changes animate in [IsharaMotion.fast].
class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.current,
    this.total = 3,
    this.onHero = false,
  }) : assert(total > 0),
       assert(current >= 1 && current <= total);

  /// 1-based current step.
  final int current;
  final int total;

  /// On a teal HeroBackdrop (Figma 9:373): active bars in fun/lime.
  final bool onHero;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final duration = IsharaMotion.duration(context, IsharaMotion.fast);
    return Semantics(
      container: true,
      label: 'Step $current of $total',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= total; i++) ...[
            if (i > 1) const SizedBox(width: IsharaSizes.stepGap),
            AnimatedContainer(
              key: ValueKey('step-$i'),
              duration: duration,
              curve: IsharaMotion.move,
              width: i == current
                  ? IsharaSizes.stepBarActive
                  : IsharaSizes.stepBarInactive,
              height: IsharaSizes.stepBarHeight,
              decoration: BoxDecoration(
                color: i <= current
                    ? (onHero ? c.funLime : c.accentDefault)
                    : c.borderDefault,
                borderRadius: IsharaRadius.brFull,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
