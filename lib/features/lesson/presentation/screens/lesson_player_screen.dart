import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/screen_placeholder.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'quit_lesson_dialog.dart';

/// One exercise state of the player (Figma frames 18–25).
typedef LessonStep = ({String frame, String name, bool camera});

/// Figma "18–25" — one player; exercises are states, not routes
/// (lessons-gamification.md). Placeholder step switcher until real exercises.
class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key, required this.lessonId});

  final String lessonId;

  static const List<LessonStep> steps = [
    (frame: '18', name: 'Watch & learn', camera: false),
    (frame: '19', name: 'Recognise', camera: false),
    (frame: '20', name: 'Recognise – correct', camera: false),
    (frame: '21', name: 'Pick the sign', camera: false),
    (frame: '22', name: 'Match pairs', camera: false),
    (frame: '23', name: 'Sign it (camera)', camera: true),
    (frame: '24', name: 'Sign it – almost', camera: true),
    (frame: '25', name: 'Fingerspell (camera)', camera: true),
  ];

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  int _step = 0;

  bool get _isLast => _step == LessonPlayerScreen.steps.length - 1;

  void _next() {
    if (_isLast) {
      LessonCompleteRoute(lessonId: widget.lessonId).go(context);
    } else {
      setState(() => _step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = LessonPlayerScreen.steps[_step];
    final page = ScreenPlaceholder(
      frame: step.frame,
      name: step.name,
      leading: IsharaAppBarLeading.close,
      onLeading: () => showQuitLessonDialog(context),
      extras: [
        Wrap(
          spacing: IsharaSpacing.s2,
          runSpacing: IsharaSpacing.s2,
          children: [
            for (final (i, s) in LessonPlayerScreen.steps.indexed)
              ChoiceChip(
                label: Text(s.frame),
                selected: i == _step,
                onSelected: (_) => setState(() => _step = i),
              ),
          ],
        ),
      ],
      actions: [
        PlaceholderAction(
          _isLast ? 'Finish lesson' : 'Next',
          _next,
          primary: true,
        ),
        PlaceholderAction(
          'Run out of hearts (28)',
          () => const OutOfHeartsRoute().go(context),
        ),
      ],
    );
    // Android back asks before quitting (frame 29).
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) showQuitLessonDialog(context);
      },
      // Camera screens always use the dark theme (ui.md).
      child: step.camera ? Theme(data: AppTheme.dark, child: page) : page,
    );
  }
}
