import '../domain/entities/hand_frame.dart';

/// Finds one hand's 21 landmarks in the front camera stream.
///
/// The real implementation wraps `hand_landmarker` (MediaPipe) over a
/// `CameraFrameSource` (`lib/core/services/camera/`): it runs inference off
/// the UI thread and drops frames while busy — it never queues them. Until
/// then the app uses `ScriptedHandLandmarkDetector`.
///
/// Privacy: frames and landmarks stay in memory — never saved, uploaded or
/// logged.
abstract interface class HandLandmarkDetector {
  /// One event per processed frame: the hand, or null when no single hand
  /// is in view (none, two, or out of frame).
  Stream<HandFrame?> frames();

  /// Stops the camera and frees the model.
  Future<void> dispose();
}
