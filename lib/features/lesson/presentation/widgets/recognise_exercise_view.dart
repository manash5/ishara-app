import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/lesson_models.dart';
import 'exercise_prompt.dart';
import 'option_states.dart';

/// Figma "19 Recognise" / "20 Recognise – correct": watch a sign, pick its
/// meaning.
class RecogniseExerciseView extends StatelessWidget {
  const RecogniseExerciseView({
    super.key,
    required this.exercise,
    required this.state,
    required this.onSelect,
  });

  final RecogniseExercise exercise;
  final LessonPlayerState state;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final answering = state.phase == LessonPhase.answering;
    return ExerciseBody(
      children: [
        ExercisePrompt(
          eyebrow: exercise.eyebrow,
          title: 'What does this sign mean?',
        ),
        // Don't name the sign: that would give the answer away.
        const SignVideo(semanticLabel: 'Sign video'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, label) in exercise.options.indexed) ...[
              if (i > 0) const SizedBox(height: IsharaSpacing.listGap),
              AnswerOption(
                label: label,
                state: optionState(state, i, exercise.answerIndex),
                onTap: answering ? () => onSelect(i) : null,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
