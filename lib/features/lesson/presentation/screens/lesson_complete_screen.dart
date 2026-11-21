import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';

/// Figma "26 Lesson complete" — placeholder until the real screen is built.
class LessonCompleteScreen extends StatelessWidget {
  const LessonCompleteScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return ScreenPlaceholder(
      frame: '26',
      name: 'Lesson complete',
      actions: [
        PlaceholderAction(
          'Continue',
          () => const StreakRoute().go(context),
          primary: true,
        ),
      ],
    );
  }
}
