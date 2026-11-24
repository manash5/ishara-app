import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../recognition/domain/entities/hand_frame.dart';
import '../../../recognition/presentation/providers/camera_session_state.dart';
import '../../../recognition/presentation/providers/sign_it_session.dart';
import '../providers/lesson_models.dart';
import 'camera_exercise_layout.dart';

/// Figma "23 Sign it (camera)" and "24 Sign it – almost": sign a greeting
/// into the front camera. The greeting pipeline ([SignItSession]) scores it
/// as practice feedback; almost / wrong highlight the finger to fix in
/// danger. Camera mistakes never cost hearts.
class SignItExerciseView extends ConsumerWidget {
  const SignItExerciseView({
    super.key,
    required this.exercise,
    required this.state,
    required this.onSkip,
    required this.onResult,
  });

  final SignItExercise exercise;
  final LessonPlayerState state;
  final VoidCallback onSkip;
  final ValueChanged<CameraOutcome> onResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = signItSessionProvider(exercise.signId);
    final session = ref.watch(provider);
    ref.listen(provider, (previous, next) {
      final outcome = next.outcome;
      if (outcome == null || previous?.outcome != null) return;
      if (state.phase != LessonPhase.answering) return;
      onResult(switch (outcome) {
        RecognitionOutcome.correct => CameraOutcome.correct,
        RecognitionOutcome.almost => CameraOutcome.almost,
        RecognitionOutcome.wrong => CameraOutcome.wrong,
      });
    });
    // After "Try again" the player is answering again: listen afresh.
    if (state.phase == LessonPhase.answering &&
        state.cameraOutcome == null &&
        session.outcome != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(provider.notifier).restart(),
      );
    }

    final missed =
        state.cameraOutcome == CameraOutcome.almost ||
        state.cameraOutcome == CameraOutcome.wrong;
    final weakest = session.weakestFinger;
    return CameraExerciseLayout(
      eyebrow: exercise.eyebrow,
      title: exercise.title,
      showReference: true,
      hint: 'Hold the sign for 1 second',
      landmarks: session.landmarks,
      highlighted: missed && weakest != null
          ? HandFinger.values[weakest.index].landmarks
          : const {},
      stats: session.stats,
      overlay: missed ? HandOverlayStyle.hint : HandOverlayStyle.live,
      status: _status(session, missed),
      onSkip: onSkip,
    );
  }

  Widget _status(SignItState session, bool missed) {
    if (session.unavailable) {
      return const IsharaChip(
        label: 'Practice feedback isn’t ready for this sign',
        tone: IsharaChipTone.neutral,
        icon: IsharaIcons.info,
      );
    }
    if (missed) {
      // Figma 24: the chip names the finger to fix.
      return IsharaChip(label: exercise.almostChip, icon: IsharaIcons.check);
    }
    return switch (session.hand) {
      HandStatus.noHand => const IsharaChip(
        label: 'Show your hand in the frame',
        tone: IsharaChipTone.neutral,
        icon: IsharaIcons.hand,
      ),
      HandStatus.handDetected => const IsharaChip(
        label: 'Hand detected',
        tone: IsharaChipTone.success,
        icon: IsharaIcons.check,
      ),
      HandStatus.holding => const IsharaChip(
        label: 'Hold still…',
        tone: IsharaChipTone.success,
        icon: IsharaIcons.check,
      ),
    };
  }
}
