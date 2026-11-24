import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../recognition/domain/entities/hand_frame.dart';
import '../../../recognition/presentation/providers/camera_session_state.dart';
import '../../../recognition/presentation/providers/fingerspell_session.dart';
import '../providers/lesson_models.dart';
import 'camera_exercise_layout.dart';
import 'fingerspell_letter_tile.dart';

/// Figma "25 Fingerspell (camera)": spell a word letter by letter. The
/// fingerspelling pipeline ([FingerspellSession]) runs on-device ("Works
/// offline"); each accepted letter advances the word. Camera mistakes never
/// cost hearts.
class FingerspellExerciseView extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = fingerspellSessionProvider(
      FingerspellSession.keyFor(exercise.letters),
    );
    final session = ref.watch(provider);
    ref.listen(provider, (previous, next) {
      if (state.phase != LessonPhase.answering) return;
      // Each letter spelled moves the word on; the last one (or a wrong
      // letter) ends in the feedback sheet.
      if (next.letterIndex > (previous?.letterIndex ?? 0)) {
        onResult(CameraOutcome.correct);
      }
      if (next.outcome != null && previous?.outcome == null) {
        onResult(
          next.outcome == RecognitionOutcome.correct
              ? CameraOutcome.correct
              : CameraOutcome.almost,
        );
      }
    });
    // After "Try again" the player is answering again: listen afresh.
    if (state.phase == LessonPhase.answering &&
        state.cameraOutcome == null &&
        session.outcome != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(provider.notifier).restart(),
      );
    }

    final current = state.letterIndex;
    final done = state.feedback == FeedbackResult.correct;
    final almost = state.cameraOutcome == CameraOutcome.almost;
    return CameraExerciseLayout(
      eyebrow: exercise.eyebrow,
      title: '${exercise.word}  ·  ${exercise.meaning}',
      landmarks: session.landmarks,
      stats: session.stats,
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
      status: session.hand == HandStatus.noHand
          ? const IsharaChip(
              label: 'Show your hand in the frame',
              tone: IsharaChipTone.neutral,
              icon: IsharaIcons.hand,
            )
          : IsharaChip(
              label: 'Letter ${exercise.letters[current]} — hold still',
              tone: IsharaChipTone.success,
              icon: IsharaIcons.check,
            ),
      onSkip: onSkip,
    );
  }
}
