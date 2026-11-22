import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/learn_path_provider.dart';
import '../widgets/learn_path_view.dart';
import 'learn_lesson_sheet.dart';
import 'learn_offline_view.dart';

/// Figma "10 Learn" (10:457): StatsBar over the scrolling roadmap. Tapping a
/// lesson opens the lesson sheet (11); frame 12 is the offline state.
class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  void _onStop(BuildContext context, PathUnit unit, PathStop stop) {
    switch (stop.state) {
      case PathNodeState.current ||
          PathNodeState.completed ||
          PathNodeState.review:
        showLearnLessonSheet(
          context,
          lessonId: stop.lessonId,
          title: stop.title,
        );
      case PathNodeState.chest:
        IsharaSnackbar.show(
          context,
          message: 'Reward chest: finish the lesson below it to open it.',
          icon: IsharaIcons.lock,
        );
      case PathNodeState.checkpoint:
        IsharaSnackbar.show(
          context,
          message: 'Checkpoint: complete Unit ${unit.number} to unlock it.',
          icon: IsharaIcons.trophy,
        );
      case PathNodeState.locked:
        IsharaSnackbar.show(
          context,
          message: 'Finish the lessons above to unlock this one.',
          icon: IsharaIcons.lock,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(learnOfflineProvider)) {
      return LearnOfflineView(
        onRetry: () => ref.read(learnOfflineProvider.notifier).set(false),
      );
    }
    final statsValue = ref.watch(learnStatsProvider);
    final path = ref.watch(learnPathProvider);
    final c = context.colors;
    final stats = statsValue.value;
    final units = path.value;
    if (stats == null || units == null) {
      return Scaffold(
        backgroundColor: c.bgCanvas,
        body: LoadStateView(
          error: path.error ?? statsValue.error,
          errorTitle: 'Couldn’t load your path',
          onRetry: () => ref
            ..invalidate(learnPathProvider)
            ..invalidate(userProfileProvider),
          loadingLabel: 'Loading your path',
        ),
      );
    }
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: c.bgCanvas,
        body: Column(
          children: [
            // Header band from the very top of the screen (behind the status
            // bar), like the hero headers on the other tabs.
            DecoratedBox(
              key: const Key('learn-header'),
              decoration: BoxDecoration(
                color: c.bgSurface,
                border: Border(bottom: BorderSide(color: c.borderSubtle)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top,
                ),
                child: StatsBar(
                  streak: stats.streak,
                  xp: stats.xp,
                  hearts: stats.hearts,
                  onCourse: () => IsharaSnackbar.show(
                    context,
                    message: 'Nepali Sign Language is the only course for now.',
                  ),
                ),
              ),
            ),
            Expanded(
              child: LearnPathView(
                units: units,
                bottomPadding: IsharaSizes.bottomBarContentPadding,
                onStop: (unit, stop) => _onStop(context, unit, stop),
                onGuide: (unit) => IsharaSnackbar.show(
                  context,
                  message: 'The Unit ${unit.number} guidebook is coming soon.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
