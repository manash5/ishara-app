import 'dart:math' as math;
import 'dart:typed_data';

import 'entities/hand_frame.dart';
import 'landmark_spec.dart';

/// Normalisation spec v1 ([kLandmarkSpecVersion]; must match
/// `ishara-systems/ml`):
/// 1. the wrist (0) moves to the origin;
/// 2. everything is scaled by the wrist → middle-finger MCP (9) distance
///    (3-D Euclidean), so hand size and camera distance don't matter;
/// 3. x is mirrored when the learner signs with their left hand, so a left
///    hand matches right-handed references;
/// 4. x, y, z × 21 are flattened into [kFeatureLength] floats.
class LandmarkNormalizer {
  const LandmarkNormalizer();

  /// Throws [ArgumentError] for a frame without [kLandmarkCount] landmarks or
  /// with the wrist on top of the middle MCP (no scale).
  Float64List normalize(List<Landmark> landmarks, {bool leftHanded = false}) {
    if (landmarks.length != kLandmarkCount) {
      throw ArgumentError.value(
        landmarks.length,
        'landmarks',
        'expected $kLandmarkCount landmarks',
      );
    }
    final wrist = landmarks[kWrist];
    final mcp = landmarks[kMiddleMcp];
    final dx = mcp.x - wrist.x;
    final dy = mcp.y - wrist.y;
    final dz = mcp.z - wrist.z;
    final scale = math.sqrt(dx * dx + dy * dy + dz * dz);
    if (scale < 1e-9) {
      throw ArgumentError('the wrist and middle MCP coincide: no scale');
    }
    final mirror = leftHanded ? -1.0 : 1.0;
    final out = Float64List(kFeatureLength);
    for (var i = 0; i < kLandmarkCount; i++) {
      final p = landmarks[i];
      out[i * 3] = (p.x - wrist.x) / scale * mirror;
      out[i * 3 + 1] = (p.y - wrist.y) / scale;
      out[i * 3 + 2] = (p.z - wrist.z) / scale;
    }
    return out;
  }
}
