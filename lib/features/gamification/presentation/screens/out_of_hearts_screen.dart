import 'package:material_ui/material_ui.dart';

import '../../../../core/config/game_rules.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Figma "28 Out of hearts" as a full-screen results page (`/out-of-hearts`),
/// laid out like Lesson complete (26): a broken-heart badge and the title
/// on the teal hero, sad Danu sighing at its right edge, then the empty
/// hearts, how to get them back and two actions. No confetti. The lesson
/// player goes here when hearts reach 0. Android back ends the lesson.
class OutOfHeartsScreen extends StatefulWidget {
  const OutOfHeartsScreen({super.key});

  @override
  State<OutOfHeartsScreen> createState() => _OutOfHeartsScreenState();
}

class _OutOfHeartsScreenState extends State<OutOfHeartsScreen> {
  @override
  void initState() {
    super.initState();
    IsharaFeedback.wrong();
  }

  void _endLesson() => const LearnRoute().go(context);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _endLesson();
      },
      child: ResultsScaffold(
        heroPadding: const EdgeInsets.fromLTRB(
          IsharaSpacing.screenMargin,
          IsharaSizes.resultHeroTop,
          IsharaSpacing.screenMargin,
          IsharaSizes.resultHeroBottom,
        ),
        backdrop: HeroBackdropLayout.results,
        celebrate: false,
        danu: const ResultsDanu(
          pose: DanuPose.sad,
          size: IsharaSizes.resultMascotLarge,
        ),
        hero: Row(
          children: [
            PopIn(
              child: Container(
                width: IsharaSizes.resultBadge,
                height: IsharaSizes.resultBadge,
                decoration: BoxDecoration(
                  color: c.funPeach,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IsharaIcons.heartCrack,
                  size: IsharaSizes.resultBadgeIcon,
                  color: c.funTealHero,
                ),
              ),
            ),
            const SizedBox(width: IsharaSpacing.s4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    liveRegion: true,
                    child: Text(
                      'You’re out of hearts',
                      style: s.displaySmall.copyWith(color: c.staticWhite),
                    ),
                  ),
                  const SizedBox(height: IsharaSpacing.s2),
                  Opacity(
                    opacity: IsharaSizes.heroCaptionOpacity,
                    child: Text(
                      'Take a break — you can come back to this lesson.',
                      style: s.bodyMedium.copyWith(color: c.staticWhite),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        continueLabel: 'Practise to earn a heart',
        onContinue: () => const PracticeRoute().go(context),
        secondaryLabel: 'End lesson',
        onSecondary: _endLesson,
        children: [
          const SectionHeader(title: 'Your hearts'),
          const SizedBox(height: IsharaSpacing.s4),
          Semantics(
            label: 'No hearts left',
            excludeSemantics: true,
            child: Row(
              children: [
                for (var i = 0; i < GameRules.maxHearts; i++) ...[
                  if (i > 0)
                    const SizedBox(width: IsharaSizes.outOfHeartsHeartGap),
                  Icon(
                    IsharaIcons.heart,
                    size: IsharaSizes.outOfHeartsHeart,
                    color: c.textTertiary,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: IsharaSpacing.s4),
          Text(
            'Hearts refill every ${GameRules.heartRefillHours} hours — '
            'or practise a review lesson to earn one back. '
            'Camera mistakes never cost hearts.',
            style: s.bodyMedium.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}
