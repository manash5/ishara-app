import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/lesson_models.dart';
import 'camera_exercise_layout.dart';

/// Figma "23 Sign it (camera)" and "24 Sign it – almost": sign a greeting
/// into the front camera. Almost highlights the finger to fix in danger and
/// names it in the chip. Camera mistakes never cost hearts.
class SignItExerciseView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final almost = state.cameraOutcome == CameraOutcome.almost;
    return CameraExerciseLayout(
      eyebrow: exercise.eyebrow,
      title: exercise.title,
      showReference: true,
      hint: 'Hold the sign for 1 second',
      overlay: almost ? HandOverlayStyle.hint : HandOverlayStyle.live,
      status: almost
          ? IsharaChip(label: exercise.almostChip, icon: IsharaIcons.check)
          : const IsharaChip(
              label: 'Hand detected',
              tone: IsharaChipTone.success,
              icon: IsharaIcons.check,
            ),
      onSkip: onSkip,
      onFakeResult: state.phase == LessonPhase.answering ? onResult : null,
    );
  }
}
