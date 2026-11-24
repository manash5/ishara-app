import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../recognition/presentation/providers/camera_session_state.dart';
import 'exercise_prompt.dart';

/// Shared layout of the camera exercises (Figma 23–25), always in the dark
/// theme: prompt row (optional reference video), optional extra row, the
/// camera area (28dp corners) with a status chip, and a footer with an
/// optional hint and "Can't use the camera now".
///
/// The recognition pipeline (`features/recognition`) supplies the live hand
/// ([landmarks], [highlighted]) and the [status] chip; with no hand the feed
/// shows the ghost target pose. Until the real camera lands the hand comes
/// from the fake detector (`/gallery` → Fake camera).
class CameraExerciseLayout extends StatelessWidget {
  const CameraExerciseLayout({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.status,
    required this.onSkip,
    this.landmarks,
    this.highlighted = const {},
    this.stats,
    this.showReference = false,
    this.below,
    this.hint,
    this.overlay = HandOverlayStyle.live,
  });

  /// Wraps [status], so tests can tell it from the debug stats chip.
  static const statusKey = Key('camera-status');

  final String eyebrow;
  final String title;

  /// Chip over the top-left of the camera (e.g. "Hand detected").
  final Widget status;

  /// "Can't use the camera now": swap camera exercises for recognise ones.
  final VoidCallback onSkip;

  /// The live hand (0–1 points), or null with no hand in view.
  final List<Offset>? landmarks;

  /// Joints drawn in danger (Figma 24: the finger to fix).
  final Set<int> highlighted;

  /// Debug-only fps / latency readout (recognition.md).
  final RecognitionStats? stats;

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
                    child: CameraFeed(
                      landmarks: landmarks,
                      highlighted: highlighted,
                      overlay:
                          landmarks == null && overlay == HandOverlayStyle.live
                          ? HandOverlayStyle.ghost
                          : overlay,
                    ),
                  ),
                  Positioned(
                    left: IsharaSpacing.s4,
                    top: IsharaSpacing.s4,
                    child: KeyedSubtree(key: statusKey, child: status),
                  ),
                  if (kDebugMode && stats != null)
                    Positioned(
                      right: IsharaSpacing.s4,
                      top: IsharaSpacing.s4,
                      child: IsharaChip(
                        key: const Key('recognition-debug-stats'),
                        label:
                            '${stats!.fps.round()} fps · '
                            '${stats!.latencyMs.toStringAsFixed(1)} ms',
                        tone: IsharaChipTone.neutral,
                      ),
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
