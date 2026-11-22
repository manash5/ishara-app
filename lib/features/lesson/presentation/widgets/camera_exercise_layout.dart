import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/lesson_models.dart';
import 'exercise_prompt.dart';

/// Shared layout of the camera exercises (Figma 23–25), always in the dark
/// theme: prompt row (optional reference video), optional extra row, the
/// camera area (28dp corners) with a status chip, and a footer with an
/// optional hint and "Can't use the camera now".
///
/// UI-only phase: [CameraFeed] shows its placeholder and a "Simulate"
/// row stands in for the recognition result.
class CameraExerciseLayout extends StatelessWidget {
  const CameraExerciseLayout({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.status,
    required this.onSkip,
    required this.onFakeResult,
    this.showReference = false,
    this.below,
    this.hint,
    this.overlay = HandOverlayStyle.live,
  });

  final String eyebrow;
  final String title;

  /// Chip over the top-left of the camera (e.g. "Hand detected").
  final Widget status;

  /// "Can't use the camera now": swap camera exercises for recognise ones.
  final VoidCallback onSkip;

  /// Fake recognition result; null while it can't be used (sheet showing).
  final ValueChanged<CameraOutcome>? onFakeResult;

  /// Figma 23 `referencePip`: the sign's video, top-right of the prompt.
  final bool showReference;

  /// Row under the prompt (Figma 25 letters).
  final Widget? below;

  /// Figma 23 footer line ("Hold the sign for 1 second").
  final String? hint;
  final HandOverlayStyle overlay;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return ColoredBox(
      color: c.bgCamera,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              IsharaSpacing.screenMargin,
              IsharaSpacing.s2,
              IsharaSpacing.screenMargin,
              IsharaSpacing.s3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ExercisePrompt(eyebrow: eyebrow, title: title),
                ),
                if (showReference) ...[
                  const SizedBox(width: IsharaSpacing.s3),
                  SizedBox(
                    width: IsharaSizes.referencePipWidth,
                    child: SignVideoPlayer(
                      semanticLabel: 'Reference video: $title',
                      size: SignVideoSize.tile,
                      borderRadius: IsharaRadius.brSm,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?below,
          Expanded(
            child: ClipRRect(
              borderRadius: IsharaRadius.brSheet,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Figma: the 560dp feed sits 20dp above the camera area.
                  Positioned(
                    top: -IsharaSpacing.s5,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: CameraFeed(overlay: overlay),
                  ),
                  Positioned(
                    left: IsharaSpacing.s4,
                    top: IsharaSpacing.s4,
                    child: status,
                  ),
                  Positioned(
                    left: IsharaSpacing.s4,
                    right: IsharaSpacing.s4,
                    bottom: IsharaSpacing.s4,
                    child: _FakeResultRow(onResult: onFakeResult),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              IsharaSpacing.screenMargin,
              IsharaSpacing.s4,
              IsharaSpacing.screenMargin,
              IsharaSpacing.s2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hint != null) ...[
                  Text(
                    hint!,
                    textAlign: TextAlign.center,
                    style: s.bodyMedium.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: IsharaSpacing.s2),
                ],
                IsharaButton(
                  label: 'Can’t use the camera now',
                  variant: IsharaButtonVariant.text,
                  onPressed: onSkip,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// UI-only stand-in for the recognition pipeline: pretend the camera saw
/// the sign (correct) or nearly (almost).
class _FakeResultRow extends StatelessWidget {
  const _FakeResultRow({required this.onResult});

  final ValueChanged<CameraOutcome>? onResult;

  @override
  Widget build(BuildContext context) {
    final r = onResult;
    return Row(
      children: [
        Expanded(
          child: IsharaButton(
            label: 'Simulate: correct',
            variant: IsharaButtonVariant.outlined,
            compact: true,
            onPressed: r == null ? null : () => r(CameraOutcome.correct),
          ),
        ),
        const SizedBox(width: IsharaSpacing.s2),
        Expanded(
          child: IsharaButton(
            label: 'Simulate: almost',
            variant: IsharaButtonVariant.outlined,
            compact: true,
            onPressed: r == null ? null : () => r(CameraOutcome.almost),
          ),
        ),
      ],
    );
  }
}
