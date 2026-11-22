import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/lesson_models.dart';
import 'exercise_prompt.dart';

/// Figma "22 Match pairs": tap a word (left), then its sign video (right).
/// A matched pair turns success at 45% opacity; a wrong pair turns danger
/// and shakes.
class MatchPairsExerciseView extends StatelessWidget {
  const MatchPairsExerciseView({
    super.key,
    required this.exercise,
    required this.state,
    required this.onTapWord,
    required this.onTapVideo,
  });

  final MatchPairsExercise exercise;
  final LessonPlayerState state;
  final ValueChanged<int> onTapWord;
  final ValueChanged<int> onTapVideo;

  @override
  Widget build(BuildContext context) {
    final answering = state.phase == LessonPhase.answering;
    return ExerciseBody(
      gap: IsharaSpacing.s6,
      children: [
        ExercisePrompt(
          eyebrow: exercise.eyebrow,
          title: 'Tap a word, then its sign',
        ),
        Column(
          children: [
            for (var row = 0; row < exercise.words.length; row++) ...[
              if (row > 0) const SizedBox(height: IsharaSpacing.s3),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _word(row, answering)),
                    const SizedBox(width: IsharaSpacing.s2),
                    Expanded(child: _video(row, answering)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _word(int i, bool answering) {
    final m = state.match;
    return MatchTile(
      label: exercise.words[i],
      state: m.matched.contains(i)
          ? MatchTileState.matched
          : m.wrongWord == i
          ? MatchTileState.wrong
          : m.word == i
          ? MatchTileState.selected
          : MatchTileState.idle,
      onTap: answering ? () => onTapWord(i) : null,
    );
  }

  Widget _video(int row, bool answering) {
    final m = state.match;
    final matched = m.matched.contains(exercise.videoOrder[row]);
    final option = VideoOption(
      // Never name the sign: that would give the answer away.
      semanticLabel: matched ? 'Video ${row + 1}, matched' : 'Video ${row + 1}',
      state: matched
          ? AnswerState.correct
          : m.wrongVideo == row
          ? AnswerState.wrong
          : m.video == row
          ? AnswerState.selected
          : AnswerState.idle,
      onTap: answering && !matched ? () => onTapVideo(row) : null,
    );
    // Figma 22: a matched video is VideoOption(correct) at 45% opacity.
    return matched
        ? Opacity(opacity: IsharaSizes.matchedOpacity, child: option)
        : option;
  }
}
