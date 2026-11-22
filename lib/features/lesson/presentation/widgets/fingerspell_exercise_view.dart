import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/lesson_models.dart';
import 'camera_exercise_layout.dart';
import 'fingerspell_letter_tile.dart';

/// Figma "25 Fingerspell (camera)": spell a word letter by letter. Runs
/// on-device ("Works offline"); camera mistakes never cost hearts.
class FingerspellExerciseView extends StatelessWidget {
  const FingerspellExerciseView({
    super.key,
    required this.exercise,
    required this.state,
    required this.onSkip,
    required this.onResult,
  });

  final FingerspellExercise exercise;
  final LessonPlayerState state;
  final VoidCallback onSkip;
  final ValueChanged<CameraOutcome> onResult;

  @override
  Widget build(BuildContext context) {
    final current = state.letterIndex;
    final done = state.feedback == FeedbackResult.correct;
    final almost = state.cameraOutcome == CameraOutcome.almost;
    return CameraExerciseLayout(
      eyebrow: exercise.eyebrow,
      title: '${exercise.word}  ·  ${exercise.meaning}',
      overlay: almost ? HandOverlayStyle.hint : HandOverlayStyle.live,
      below: Padding(
        padding: const EdgeInsets.fromLTRB(
          IsharaSpacing.screenMargin,
          0,
          IsharaSpacing.screenMargin,
          IsharaSpacing.s3,
        ),
        child: Wrap(
          spacing: IsharaSpacing.s2,
          runSpacing: IsharaSpacing.s2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final (i, letter) in exercise.letters.indexed)
              FingerspellLetterTile(
                letter: letter,
                state: done || i < current
                    ? LetterTileState.done
                    : i == current
                    ? LetterTileState.current
                    : LetterTileState.todo,
              ),
            const IsharaChip(
              label: 'Works offline',
              tone: IsharaChipTone.neutral,
              icon: IsharaIcons.wifiOff,
            ),
          ],
        ),
      ),
      status: IsharaChip(
        label: 'Letter ${exercise.letters[current]} — hold still',
        tone: IsharaChipTone.success,
        icon: IsharaIcons.check,
      ),
      onSkip: onSkip,
      onFakeResult: state.phase == LessonPhase.answering ? onResult : null,
    );
  }
}
