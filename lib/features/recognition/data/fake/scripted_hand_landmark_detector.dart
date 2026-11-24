import '../../domain/entities/hand_frame.dart';
import '../hand_landmark_detector.dart';

/// Replays scripted frames as if the camera saw them, at [fps], looping.
/// Stands in for the MediaPipe detector until the real camera lands.
class ScriptedHandLandmarkDetector implements HandLandmarkDetector {
  ScriptedHandLandmarkDetector(this.script, {this.fps = 30, this.loop = true});

  final List<HandFrame?> script;
  final int fps;
  final bool loop;

  @override
  Stream<HandFrame?> frames() {
    if (script.isEmpty) return const Stream.empty();
    final period = Duration(microseconds: 1000000 ~/ fps);
    final lap = period * script.length;
    final ticks = Stream<HandFrame?>.periodic(period, (i) {
      final frame = script[i % script.length];
      // Timestamps keep rising across loops, like a real camera clock.
      return frame == null
          ? null
          : HandFrame(
              landmarks: frame.landmarks,
              timestamp: lap * (i ~/ script.length) + frame.timestamp,
            );
    });
    return loop ? ticks : ticks.take(script.length);
  }

  /// Nothing to free: cancelling the `frames()` subscription stops it.
  @override
  Future<void> dispose() async {}
}
