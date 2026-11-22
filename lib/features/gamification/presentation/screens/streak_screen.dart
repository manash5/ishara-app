import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/week_streak_row.dart';

/// Figma "27 Streak" (Light 15:2665 · Dark 60:7125): shown after a lesson
/// that extended the streak. Laid out like 26: the flame badge left of the
/// day count, Danu celebrating at the hero's right edge over the panel.
/// Flame pop, day count-up and a short confetti burst, with a medium haptic.
/// Continue → Learn.
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
      // Same hero as 26: badge + text a little lower, clear of the backdrop
      // circles; Danu on the right beside the text, straddling the panel.
      heroPadding: const EdgeInsets.fromLTRB(
        IsharaSpacing.screenMargin,
        IsharaSizes.resultHeroTop + IsharaSpacing.s4,
        IsharaSpacing.screenMargin,
        IsharaSizes.resultHeroBottom,
      ),
      backdrop: HeroBackdropLayout.results,
      // Danu cheers, a little higher than on 26: right by the count.
      danu: const ResultsDanu(
        size: IsharaSizes.resultMascotLarge,
        pose: DanuPose.celebrate,
      ),
      danuRise: IsharaSizes.streakMascotRise,
      hero: Row(
        children: [
          PopIn(
            child: Container(
              width: IsharaSizes.resultBadge,
              height: IsharaSizes.resultBadge,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.funTealHeroLip,
                shape: BoxShape.circle,
              ),
              child: IsharaFilledIcon(
                IsharaFilledIconKind.flame,
                size: IsharaSizes.resultBadgeIcon,
                color: c.funGold,
              ),
            ),
          ),
          const SizedBox(width: IsharaSpacing.s4),
          Expanded(
            child: Semantics(
              header: true,
              label: '${streak.days} day streak',
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ],
      ),
      onContinue: () => const LearnRoute().go(context),
      children: [
        const SectionHeader(title: 'This week'),
        WeekStreakRow(
          practised: streak.practisedDays,
          todayIndex: streak.todayIndex,
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StatCard(
                  value: '${streak.longestDays}',
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
