import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/lesson_models.dart';
import 'exercise_prompt.dart';
import 'option_states.dart';

/// Figma "21 Pick the sign": a meaning, then a 2×2 grid of sign videos.
class PickSignExerciseView extends StatelessWidget {
  const PickSignExerciseView({
    super.key,
    required this.exercise,
    required this.state,
    required this.onSelect,
  });

  final PickSignExercise exercise;
  final LessonPlayerState state;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final answering = state.phase == LessonPhase.answering;
    Widget option(int i) => Expanded(
      child: i < exercise.optionCount
          ? VideoOption(
              // Never name the sign: that would give the answer away.
              semanticLabel: 'Option ${i + 1}',
              state: optionState(state, i, exercise.answerIndex),
              onTap: answering ? () => onSelect(i) : null,
            )
          : const SizedBox.shrink(),
    );
    return ExerciseBody(
      children: [
        ExercisePrompt(
          eyebrow: exercise.eyebrow,
          title: 'Which sign means “${exercise.meaning}”?',
        ),
        Column(
          children: [
            for (var i = 0; i < exercise.optionCount; i += 2) ...[
              if (i > 0) const SizedBox(height: IsharaSpacing.listGap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  option(i),
                  const SizedBox(width: IsharaSpacing.listGap),
                  option(i + 1),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
