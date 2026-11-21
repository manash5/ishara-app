import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Figma `onboardingBar` (9:212, 9:301, 9:368): a back button on the left
/// and the [StepIndicator] on the right, 64dp tall.
///
/// When [onBack] is null the back button is hidden (first step reached via a
/// redirect has nothing to go back to) but keeps its space.
/// [onHero] = drawn over the teal `HeroBackdrop` (08): white icon, lime bars.
class OnboardingBar extends StatelessWidget {
  const OnboardingBar({
    super.key,
    required this.step,
    required this.onBack,
    this.totalSteps = 3,
    this.onHero = false,
  });

  final int step;
  final int totalSteps;
  final VoidCallback? onBack;
  final bool onHero;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final indicator = StepIndicator(
      current: step,
      total: totalSteps,
      onHero: onHero,
    );
    return SizedBox(
      height: IsharaSizes.appBarHeight,
      child: Padding(
        padding: const EdgeInsets.only(
          left: IsharaSpacing.s1,
          right: IsharaSpacing.screenMargin,
        ),
        child: Row(
          children: [
            Visibility.maintain(
              visible: onBack != null,
              child: IsharaIconButton(
                icon: IsharaIcons.arrowLeft,
                tooltip: 'Back',
                onPressed: onBack,
                color: onHero ? c.staticWhite : null,
              ),
            ),
            const Spacer(),
            indicator,
          ],
        ),
      ),
    );
  }
}
