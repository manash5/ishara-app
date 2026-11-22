import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/services/connectivity/connectivity_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'learn_screen.dart';

/// Placeholder lesson id until the path comes from the API.
const String placeholderLessonId = 'greetings-1';

/// Figma "11 Learn – lesson sheet": modal sheet opened from a path node.
Future<void> showLearnLessonSheet(
  BuildContext context, {
  String? lessonId,
  String? title,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    builder: (sheetContext) => LearnLessonSheet(
      lessonId: lessonId ?? placeholderLessonId,
      title: title,
    ),
  );
}

/// Content of frame 11 (placeholder).
class LearnLessonSheet extends StatelessWidget {
  const LearnLessonSheet({
    super.key,
    this.lessonId = placeholderLessonId,
    this.title,
  });

  final String lessonId;

  /// Lesson name from the path node, if known.
  final String? title;

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
            Text(
              title == null
                  ? '11 · Learn – lesson sheet'
                  : '11 · Learn – lesson sheet · $title',
              style: s.titleLarge.copyWith(color: c.textPrimary),
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
