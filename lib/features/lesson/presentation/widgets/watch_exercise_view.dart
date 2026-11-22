import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../providers/lesson_models.dart';
import 'exercise_prompt.dart';
import 'lesson_sign_video.dart';
import 'lesson_tip_card.dart';

/// Figma "18 Watch & learn": a new sign's video, its description and a tip.
class WatchExerciseView extends StatelessWidget {
  const WatchExerciseView({super.key, required this.exercise});

  final WatchExercise exercise;

  @override
  Widget build(BuildContext context) {
    return ExerciseBody(
      children: [
        ExercisePrompt(
          eyebrow: exercise.eyebrow,
          title: exercise.title,
          subtitle: 'Watch closely, then try it yourself.',
        ),
        LessonSignVideo(semanticLabel: 'Sign video: ${exercise.title}'),
        Text(
          exercise.description,
          style: context.textStyles.bodyMedium.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        LessonTipCard(text: exercise.tip),
      ],
    );
  }
}
