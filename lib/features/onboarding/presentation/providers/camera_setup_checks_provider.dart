import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/theme/theme.dart';
import '../../../recognition/data/recognition_providers.dart';
import '../../../recognition/domain/entities/hand_frame.dart';
import '../../../recognition/domain/setup_assessor.dart';
import '../../../recognition/presentation/providers/camera_session_state.dart';

part 'camera_setup_checks_provider.g.dart';

/// One row of the "09 Camera setup check" checklist.
@immutable
class CameraSetupCheck {
  const CameraSetupCheck({
    required this.icon,
    required this.label,
    required this.status,
    required this.ok,
  });

  final IconData icon;
  final String label;

  /// Short status shown in the chip, e.g. "Good" or "Move a bit closer".
  final String status;

  /// Passing checks show a success chip, ones to fix an accent chip.
  final bool ok;
}

/// What "09 Camera setup check" shows: the live hand and the checklist.
@immutable
class CameraSetupState {
  const CameraSetupState({required this.checks, this.landmarks});

  /// Lighting, distance and hand visibility (Figma 9:530 order).
  final List<CameraSetupCheck> checks;

  /// The live hand for the overlay (0–1), or null with no hand.
  final List<Offset>? landmarks;

  /// The checklist for [a] (no hand: every row asks for one).
  factory CameraSetupState.from(SetupAssessment a, HandFrame? frame) {
    const show = 'Show your hand';
    return CameraSetupState(
      landmarks: frame == null ? null : overlayPoints(frame),
      checks: [
        // The landmarker found a hand, so the light is enough to sign in.
        CameraSetupCheck(
          icon: IsharaIcons.sun,
          label: 'Lighting',
          status: a.handVisible ? 'Good' : show,
          ok: a.handVisible,
        ),
        CameraSetupCheck(
          icon: IsharaIcons.scan,
          label: 'Distance',
          status: switch (a.distance) {
            null => show,
            SetupDistance.tooFar => 'Move a bit closer',
            SetupDistance.tooClose => 'Move back a little',
            SetupDistance.good => 'Good',
          },
          ok: a.distance == SetupDistance.good,
        ),
        CameraSetupCheck(
          icon: IsharaIcons.hand,
          label: 'Hand visible',
          status: !a.handVisible
              ? show
              : a.inFrame
              ? 'Detected'
              : 'Keep your whole hand in view',
          ok: a.handVisible && a.inFrame,
        ),
      ],
    );
  }
}

/// The setup checklist, updated from the hand landmark detector on every
/// frame (recognition.md). Frames and landmarks stay in memory only.
@riverpod
class CameraSetupChecks extends _$CameraSetupChecks {
  static const _assessor = SetupAssessor();

  StreamSubscription<HandFrame?>? _frames;

  @override
  CameraSetupState build() {
    final detector = ref.watch(
      handLandmarkDetectorProvider(const PracticeTarget()),
    );
    _frames = detector.frames().listen(
      (frame) => state = CameraSetupState.from(_assessor.assess(frame), frame),
    );
    ref.onDispose(() => _frames?.cancel());
    return CameraSetupState.from(SetupAssessment.none, null);
  }
}
