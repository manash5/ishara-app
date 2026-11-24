import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/learn_path_provider.dart';
import '../widgets/learn_offline_notice.dart';
import '../widgets/learn_path_view.dart';
import 'learn_lesson_sheet.dart';
import '../../../../core/connectivity/is_online.dart';

/// Figma "10 Learn" (10:457): StatsBar over the scrolling roadmap. Tapping a
/// lesson opens the lesson sheet (11). Offline (12) the cached roadmap stays,
/// with a notice above the bottom bar; lessons need a connection (videos).
class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  /// Shown when a lesson is tapped offline.
  static const offlineLessonMessage =
      'You’re offline. Lessons need a connection for sign videos.';

  void _onStop(
    BuildContext context,
    WidgetRef ref,
    PathUnit unit,
    PathStop stop,
  ) {
    switch (stop.state) {
      case PathNodeState.current ||
              PathNodeState.completed ||
              PathNodeState.review
          when ref.read(isOnlineProvider).value == false:
        IsharaSnackbar.show(
          context,
          message: offlineLessonMessage,
          icon: IsharaIcons.wifiOff,
        );
      case PathNodeState.current ||
          PathNodeState.completed ||
          PathNodeState.review:
        // Lesson stops always carry their lesson id (`GET /path`).
        if (stop.lessonId case final lessonId?) {
          showLearnLessonSheet(context, lessonId: lessonId, title: stop.title);
        }
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
                  streak: stats.streakDays,
                  xp: stats.totalXp,
                  hearts: stats.hearts,
                  onCourse: () => IsharaSnackbar.show(
                    context,
                    message: 'Nepali Sign Language is the only course for now.',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: LearnPathView(
                      units: units,
                      bottomPadding: IsharaSizes.bottomBarContentPadding,
                      onStop: (unit, stop) => _onStop(context, ref, unit, stop),
                      onGuide: (unit) => IsharaSnackbar.show(
                        context,
                        message:
                            'The Unit ${unit.number} guidebook is coming soon.',
                      ),
                    ),
                  ),
                  // Figma 12: just above the bottom bar.
                  const Positioned(
                    left: IsharaSpacing.screenMargin,
                    right: IsharaSpacing.screenMargin,
                    bottom: IsharaSizes.bottomBarHeight + IsharaSpacing.s3,
                    child: LearnOfflineNotice(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
