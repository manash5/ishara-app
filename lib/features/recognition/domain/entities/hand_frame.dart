import 'dart:typed_data';

/// One MediaPipe hand landmark: x and y normalised to 0–1 in the image, z
/// relative depth. Lives in memory only — never saved, uploaded or logged
/// (CLAUDE.md privacy rule).
class Landmark {
  const Landmark(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  @override
  bool operator ==(Object other) =>
      other is Landmark && other.x == x && other.y == y && other.z == z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() => 'Landmark($x, $y, $z)';
}

/// The 21 landmarks of one detected hand in one camera frame.
class HandFrame {
  const HandFrame({required this.landmarks, required this.timestamp});

  final List<Landmark> landmarks;

  /// Time since the camera stream started.
  final Duration timestamp;
}

/// One fingerspelling classifier output.
class LetterPrediction {
  const LetterPrediction(this.label, this.confidence);

  final String label;

  /// 0–1.
  final double confidence;
}

/// What the learner's signing scored (the UI calls it "practice feedback",
/// never "verified").
enum RecognitionOutcome { correct, almost, wrong }

/// Path-normalised DTW distances at or below which a sign counts as
/// [RecognitionOutcome.correct] or [RecognitionOutcome.almost].
class DtwThresholds {
  const DtwThresholds({required this.correct, required this.almost})
    : assert(correct <= almost, 'correct must be the tighter threshold');

  final double correct;
  final double almost;
}

/// The reference recordings of one sign (3–5 per sign), as normalised
/// feature frames, with its scoring thresholds.
class SignTemplate {
  const SignTemplate({
    required this.signId,
    required this.recordings,
    required this.thresholds,
  });

  final String signId;
  final List<List<Float64List>> recordings;
  final DtwThresholds thresholds;
}

/// The five fingers with their landmark indices (MediaPipe hand model).
enum Finger {
  thumb([1, 2, 3, 4]),
  indexFinger([5, 6, 7, 8]),
  middle([9, 10, 11, 12]),
  ring([13, 14, 15, 16]),
  pinky([17, 18, 19, 20]);

  const Finger(this.landmarks);

  /// Base to tip.
  final List<int> landmarks;
}
