import 'dart:math' as math;

import '../../../core/config/game_rules.dart';
import 'entities/hand_frame.dart';
import 'landmark_spec.dart';

/// How far the hand is from the camera, judged by its size in the frame.
enum SetupDistance { tooFar, good, tooClose }

/// What "09 Camera setup check" can tell from one detection.
class SetupAssessment {
  const SetupAssessment({
    required this.handVisible,
    required this.inFrame,
    this.distance,
  });

  /// No hand (or not exactly one) in view.
  static const none = SetupAssessment(handVisible: false, inFrame: false);

  /// A hand was detected.
  final bool handVisible;

  /// Every landmark sits inside the frame, clear of its edges.
  final bool inFrame;

  /// Null with no hand.
  final SetupDistance? distance;

  /// Ready to sign: a hand, fully in frame, at a good distance.
  bool get ready => handVisible && inFrame && distance == SetupDistance.good;
}

/// Judges the learner's setup from the hand landmarks only (no pixels, so
/// nothing about the image itself is kept). Distance uses the palm length
/// (wrist → middle-finger MCP) as a fraction of the frame
/// ([GameRules.setupPalmMin]–[GameRules.setupPalmMax]).
class SetupAssessor {
  const SetupAssessor();

  SetupAssessment assess(HandFrame? frame) {
    if (frame == null || frame.landmarks.length != kLandmarkCount) {
      return SetupAssessment.none;
    }
    final l = frame.landmarks;
    const margin = GameRules.setupEdgeMargin;
    final inFrame = l.every(
      (p) =>
          p.x >= margin &&
          p.x <= 1 - margin &&
          p.y >= margin &&
          p.y <= 1 - margin,
    );
    final wrist = l[kWrist];
    final mcp = l[kMiddleMcp];
    final palm = math.sqrt(
      math.pow(mcp.x - wrist.x, 2) + math.pow(mcp.y - wrist.y, 2),
    );
    final distance = palm < GameRules.setupPalmMin
        ? SetupDistance.tooFar
        : palm > GameRules.setupPalmMax
        ? SetupDistance.tooClose
        : SetupDistance.good;
    return SetupAssessment(
      handVisible: true,
      inFrame: inFrame,
      distance: distance,
    );
  }
}
