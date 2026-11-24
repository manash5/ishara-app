import 'package:material_ui/material_ui.dart';

import '../../domain/entities/hand_frame.dart';

/// What the camera sees right now, for the status chip.
enum HandStatus {
  /// No single hand in view (none, two, or out of frame).
  noHand,

  /// A hand is visible.
  handDetected,

  /// The learner is holding a sign / letter steady.
  holding,
}

/// Debug-only performance readout (recognition.md: fps / latency overlay).
@immutable
class RecognitionStats {
  const RecognitionStats({this.fps = 0, this.latencyMs = 0});

  /// Frames processed per second.
  final double fps;

  /// Processing time of the last frame.
  final double latencyMs;
}

/// The 21 landmarks as 0–1 points for `CameraFeed` / `HandLandmarkPainter`.
/// They live in memory only (privacy rule).
List<Offset> overlayPoints(HandFrame frame) => [
  for (final l in frame.landmarks) Offset(l.x, l.y),
];

/// Shared frame timing for [RecognitionStats].
class StatsMeter {
  Duration? _lastFrame;
  double _fps = 0;

  RecognitionStats record(Duration timestamp, Duration processing) {
    final last = _lastFrame;
    _lastFrame = timestamp;
    if (last != null && timestamp > last) {
      final instant = 1e6 / (timestamp - last).inMicroseconds;
      // Smoothed so the readout doesn't flicker.
      _fps = _fps == 0 ? instant : _fps * 0.9 + instant * 0.1;
    }
    return RecognitionStats(
      fps: _fps,
      latencyMs: processing.inMicroseconds / 1000,
    );
  }
}
