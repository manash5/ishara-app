import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/onboarding_choices_provider.dart';
import '../widgets/onboarding_step_scaffold.dart';

/// Figma "07 Dominant hand" (9:292): step 2 of 3, pick the signing hand.
class DominantHandScreen extends ConsumerWidget {
  const DominantHandScreen({super.key});

  static const _options = [
    (
      hand: DominantHand.right,
      title: 'Right hand',
      description: 'Videos play as recorded',
    ),
    (
      hand: DominantHand.left,
      title: 'Left hand',
      description: 'Videos are mirrored for you',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final selected = ref.watch(onboardingChoicesProvider.select((s) => s.hand));
    return OnboardingStepScaffold(
      step: 2,
      title: 'Which hand do you sign with?',
      subtitle: 'Lessons and camera checks will mirror to match.',
      buttonLabel: 'Continue',
      onContinue: () => const CameraPermissionRoute().push<void>(context),
      children: [
        SelectionCardGroup(
          label: 'Dominant hand',
          cards: [
            for (final o in _options)
              SelectionCard(
                key: ValueKey('hand-${o.hand.name}'),
                icon: IsharaIcons.hand,
                title: o.title,
                description: o.description,
                selected: o.hand == selected,
                onTap: () => ref
                    .read(onboardingChoicesProvider.notifier)
                    .selectHand(o.hand),
              ),
          ],
        ),
        // Figma `tip` (9:345).
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              IsharaIcons.info,
              size: IsharaSizes.iconMd,
              color: c.textSecondary,
            ),
            const SizedBox(width: IsharaSpacing.s3),
            Expanded(
              child: Text(
                'Not sure? Choose the hand you write with.',
                style: context.textStyles.bodyMedium.copyWith(
                  color: c.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
