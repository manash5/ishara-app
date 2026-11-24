import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'learn_screen.dart';
import '../../../../core/connectivity/is_online.dart';

/// Figma "11 Learn – lesson sheet": modal sheet opened from a path node, for
/// that node's lesson (`GET /path`).
Future<void> showLearnLessonSheet(
  BuildContext context, {
  required String lessonId,
  required String title,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    builder: (sheetContext) =>
        LearnLessonSheet(lessonId: lessonId, title: title),
  );
}

/// Content of frame 11: the lesson's name and Start lesson.
class LearnLessonSheet extends StatelessWidget {
  const LearnLessonSheet({
    super.key,
    required this.lessonId,
    required this.title,
  });

  final String lessonId;

  /// Lesson name from the path node.
  final String title;

  @override
  Widget build(BuildContext context) {
    final s = context.textStyles;
    final c = context.colors;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          IsharaSpacing.screenMargin,
          0,
          IsharaSpacing.screenMargin,
          IsharaSpacing.screenMargin,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                title,
                style: s.titleLarge.copyWith(color: c.textPrimary),
              ),
            ),
            const SizedBox(height: IsharaSpacing.s4),
            // Lessons need sign videos, so they need a connection.
            Consumer(
              builder: (context, ref, _) {
                final offline = ref.watch(isOnlineProvider).value == false;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (offline) ...[
                      Text(
                        LearnScreen.offlineLessonMessage,
                        key: const Key('lesson-sheet-offline'),
                        style: s.bodyMedium.copyWith(color: c.textSecondary),
                      ),
                      const SizedBox(height: IsharaSpacing.s3),
                    ],
                    IsharaButton(
                      label: 'Start lesson',
                      onPressed: offline
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              LessonRoute(lessonId: lessonId)
                                  .push<void>(context);
                            },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
