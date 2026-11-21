import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/daily_goal_options_provider.dart';
import '../providers/onboarding_choices_provider.dart';
import '../widgets/onboarding_step_scaffold.dart';

/// Figma "06 Daily goal" (9:203): step 1 of 3, pick a daily practice goal.
class DailyGoalScreen extends ConsumerWidget {
  const DailyGoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(dailyGoalOptionsProvider);
    final selectedId = ref.watch(
      onboardingChoicesProvider.select((s) => s.dailyGoalId),
    );
    return OnboardingStepScaffold(
      step: 1,
      title: 'How long do you want to practise each day?',
      subtitle: 'You can change your goal anytime in Settings.',
      buttonLabel: 'Continue',
      onContinue: () => const DominantHandRoute().push<void>(context),
      children: [
        SelectionCardGroup(
          label: 'Daily goal',
          cards: [
            for (final option in options)
              SelectionCard(
                key: ValueKey('daily-goal-${option.id}'),
                icon: option.icon,
                title: option.title,
                description: option.description,
                selected: option.id == selectedId,
                onTap: () => ref
                    .read(onboardingChoicesProvider.notifier)
                    .selectDailyGoal(option.id),
              ),
          ],
        ),
      ],
    );
  }
}
