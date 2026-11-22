import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/week_streak_row.dart';

/// Figma "27 Streak" (Light 15:2665 · Dark 60:7125): shown after a lesson
/// that extended the streak. Flame pop, Danu waving, day count-up and
/// a short confetti burst, with a medium haptic. Continue → Learn.
class StreakScreen extends ConsumerStatefulWidget {
  const StreakScreen({super.key});

  @override
  ConsumerState<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends ConsumerState<StreakScreen> {
  @override
  void initState() {
    super.initState();
    IsharaFeedback.streak();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final value = ref.watch(streakSummaryProvider);
    final streak = value.value;
    if (streak == null) {
      return Scaffold(
        backgroundColor: c.bgSurface,
        body: LoadStateView(
          error: value.error,
          errorTitle: 'Couldn’t load your streak',
          onRetry: () => ref.invalidate(userProfileProvider),
          loadingLabel: 'Loading your streak',
        ),
      );
    }
    return ResultsScaffold(
      heroPadding: const EdgeInsets.fromLTRB(
        IsharaSpacing.screenMargin,
        IsharaSpacing.s8,
        IsharaSpacing.screenMargin,
        IsharaSpacing.s12 + IsharaSpacing.s1,
      ),
      hero: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Danu on the left, clear of the backdrop shapes (right).
              const ResultsDanu(),
              PopIn(
                child: Container(
                  width: IsharaSizes.streakHero,
                  height: IsharaSizes.streakHero,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.funTealHeroLip,
                    shape: BoxShape.circle,
                  ),
                  child: IsharaFilledIcon(
                    IsharaFilledIconKind.flame,
                    size: IsharaSizes.streakHeroIcon,
                    color: c.funGold,
                  ),
                ),
              ),
              // Balances Danu so the flame stays centred.
              const SizedBox(width: IsharaSizes.resultMascot),
            ],
          ),
          const SizedBox(height: IsharaSpacing.s1),
          Semantics(
            header: true,
            label: '${streak.days} day streak',
            excludeSemantics: true,
            child: Column(
              children: [
                CountUp(
                  value: streak.days,
                  builder: (_, days) => Text(
                    '$days',
                    style: s.displaySmall.copyWith(
                      fontSize: IsharaSizes.streakNumber,
                      height:
                          IsharaSizes.streakNumberLine /
                          IsharaSizes.streakNumber,
                      color: c.staticWhite,
                    ),
                  ),
                ),
                const SizedBox(height: IsharaSpacing.s1),
                Opacity(
                  opacity: IsharaSizes.heroCaptionOpacity,
                  child: Text(
                    'day streak',
                    style: s.titleLarge.copyWith(color: c.staticWhite),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onContinue: () => const LearnRoute().go(context),
      children: [
        const SectionHeader(title: 'This week'),
        WeekStreakRow(practised: streak.week, todayIndex: streak.todayIndex),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StatCard(
                  value: '${streak.longest}',
                  caption: 'Longest streak',
                  kind: IsharaFilledIconKind.star,
                  tint: StatCardTint.peach,
                ),
              ),
              const SizedBox(width: IsharaSpacing.s3),
              Expanded(
                child: StatCard(
                  value: '${streak.freezes}',
                  caption: 'Streak freeze ready',
                  kind: IsharaFilledIconKind.zap,
                  tint: StatCardTint.mint,
                ),
              ),
            ],
          ),
        ),
        Text(
          'Practise tomorrow to keep it going. A streak freeze is ready if '
          'you miss a day.',
          style: s.bodyMedium.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}
