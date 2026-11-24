import 'dart:typed_data';

import 'entities/hand_frame.dart';

/// Turns a DTW distance into practice feedback with a sign's thresholds, and
/// finds the finger to fix for "almost" (Figma 24).
class SignScorer {
  const SignScorer();

  RecognitionOutcome score(double distance, DtwThresholds thresholds) {
    if (distance <= thresholds.correct) return RecognitionOutcome.correct;
    if (distance <= thresholds.almost) return RecognitionOutcome.almost;
    return RecognitionOutcome.wrong;
  }

  /// The finger whose landmarks are furthest off on average.
  Finger weakestFinger(Float64List perLandmarkError) {
    var worst = Finger.thumb;
    var worstError = -1.0;
    for (final finger in Finger.values) {
      var sum = 0.0;
      for (final i in finger.landmarks) {
        sum += perLandmarkError[i];
      }
      final mean = sum / finger.landmarks.length;
      if (mean > worstError) {
        worstError = mean;
        worst = finger;
      }
    }
    return worst;
  }
}
