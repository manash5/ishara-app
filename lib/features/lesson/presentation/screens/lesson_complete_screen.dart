import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/lesson_providers.dart';

/// "4:12".
String formatLessonTime(Duration d) =>
    '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

/// Figma "26 Lesson complete" (Light 15:2617 · Dark 60:7103): results with
/// a check badge beside the title, Danu waving at the hero's edge, XP count-up and a short confetti
/// burst (motion.md playful). Continue → Streak (27).
class LessonCompleteScreen extends ConsumerStatefulWidget {
  const LessonCompleteScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonCompleteScreen> createState() =>
      _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends ConsumerState<LessonCompleteScreen> {
  @override
  void initState() {
    super.initState();
    IsharaFeedback.correct();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final value = ref.watch(lessonResultProvider(widget.lessonId));
    final summary = value.value;
    if (summary == null) {
      return Scaffold(
        backgroundColor: c.bgSurface,
        body: LoadStateView(
          error: value.error,
          errorTitle: 'Couldn’t save your lesson',
          onRetry: () => ref.invalidate(lessonResultProvider(widget.lessonId)),
          loadingLabel: 'Saving your lesson',
        ),
      );
    }
    return ResultsScaffold(
      // Badge + title below the lavender circle, with more teal around them.
      heroPadding: const EdgeInsets.fromLTRB(
        IsharaSpacing.screenMargin,
        IsharaSizes.resultHeroTop,
        IsharaSpacing.screenMargin,
        IsharaSizes.resultHeroBottom,
      ),
      backdrop: HeroBackdropLayout.results,
      // Right of the hero, below the top circles, overlapping the panel.
      danu: const ResultsDanu(size: IsharaSizes.resultMascotLarge),
      hero: Row(
        children: [
          PopIn(
            child: Container(
              width: IsharaSizes.resultBadge,
              height: IsharaSizes.resultBadge,
              decoration: BoxDecoration(
                color: c.funLime,
                shape: BoxShape.circle,
              ),
              child: Icon(
                IsharaIcons.check,
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
                  child: Text(
                    'Lesson complete!',
                    style: s.displaySmall.copyWith(color: c.staticWhite),
                  ),
                ),
                const SizedBox(height: IsharaSpacing.s2),
                Opacity(
                  opacity: IsharaSizes.heroCaptionOpacity,
                  child: Text(
                    'You learned ${summary.newSignCount} new greetings.',
                    style: s.bodyMedium.copyWith(color: c.staticWhite),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onContinue: () => const StreakRoute().go(context),
      children: [
        const SectionHeader(title: 'Your results'),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CountUp(
                  value: summary.xpEarned,
                  builder: (_, xp) => StatCard(
                    value: '+$xp',
                    caption: 'XP earned',
                    kind: IsharaFilledIconKind.zap,
                    // Figma 26: text/primary (dark teal / white), not gold.
                    iconColor: c.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: IsharaSpacing.s3),
              Expanded(
                child: CountUp(
                  value: (summary.accuracy * 100).round(),
                  builder: (_, pct) => StatCard(
                    value: '$pct%',
                    caption: 'Accuracy',
                    icon: IsharaIcons.target,
                    iconColor: c.accentText,
                    tint: StatCardTint.peach,
                  ),
                ),
              ),
              const SizedBox(width: IsharaSpacing.s3),
              Expanded(
                child: StatCard(
                  value: formatLessonTime(summary.duration),
                  caption: 'Time',
                  icon: IsharaIcons.clock,
                  iconColor: c.accentText,
                  tint: StatCardTint.mint,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: IsharaSpacing.s2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(title: 'Signs you learned'),
              for (final sign in summary.signs) ...[
                const SizedBox(height: IsharaSpacing.s3),
                SignListTile(
                  title: sign.name,
                  subtitle: sign.category.label,
                  statusLabel: 'Learned',
                  onTap: () =>
                      SignDetailRoute(signId: sign.id).push<void>(context),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
