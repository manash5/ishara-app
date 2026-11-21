import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'onboarding_bar.dart';
import 'onboarding_heading.dart';

/// Shared layout of the onboarding choice steps (06, 07): [OnboardingBar],
/// a scrolling body (8 top, 24 sides, 24 gap) and a footer button (Figma
/// `footer`: 24 sides, 12 vertical).
class OnboardingStepScaffold extends StatelessWidget {
  const OnboardingStepScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.buttonLabel,
    required this.onContinue,
  });

  final int step;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final String buttonLabel;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      backgroundColor: context.colors.bgCanvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OnboardingBar(
              step: step,
              onBack: navigator.canPop() ? navigator.pop : null,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  IsharaSpacing.screenMargin,
                  IsharaSpacing.s2,
                  IsharaSpacing.screenMargin,
                  IsharaSpacing.s6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OnboardingHeading(title: title, subtitle: subtitle),
                    for (final child in children) ...[
                      const SizedBox(height: IsharaSpacing.s6),
                      child,
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: IsharaSpacing.screenMargin,
                vertical: IsharaSpacing.s3,
              ),
              child: IsharaButton(label: buttonLabel, onPressed: onContinue),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single-choice list of [SelectionCard]s with radio-group semantics and
/// the Figma `layout/list-gap` between cards.
class SelectionCardGroup extends StatelessWidget {
  const SelectionCardGroup({
    super.key,
    required this.label,
    required this.cards,
  });

  /// Accessible name of the group, e.g. "Daily goal".
  final String label;
  final List<SelectionCard> cards;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(height: IsharaSpacing.listGap),
            cards[i],
          ],
        ],
      ),
    );
  }
}
