import 'dart:typed_data';

/// One front-camera image, as the hand landmark detector receives it.
///
/// Privacy (CLAUDE.md): frames live in memory only — never saved, uploaded
/// or logged — and are released as soon as the detector is done with them.
class CameraFrame {
  const CameraFrame({
    required this.width,
    required this.height,
    required this.rotationDegrees,
    required this.timestamp,
    required this.planes,
  });

  final int width;
  final int height;

  /// Sensor rotation to apply before inference (0, 90, 180 or 270).
  final int rotationDegrees;

  /// Time since the stream started.
  final Duration timestamp;

  /// Raw image planes (e.g. YUV420), reused between frames — copy nothing.
  final List<Uint8List> planes;
}

/// The front camera's image stream (medium resolution), behind an interface
/// so features and tests never touch the `camera` plugin (CLAUDE.md).
///
/// Boundary only for now: the `camera` + `hand_landmarker` wrappers will live
/// next to this file. Until then recognition runs on scripted fakes
/// (`ScriptedHandLandmarkDetector`).
abstract interface class CameraFrameSource {
  /// Opens the front camera. Throws if permission is missing.
  Future<void> start();

  /// Frames as they arrive. A consumer that is still busy drops frames;
  /// they are never queued (recognition.md).
  Stream<CameraFrame> frames();

  /// Releases the camera (call from `ref.onDispose`).
  Future<void> stop();
}
