import 'dart:math' as math;
import 'dart:typed_data';

import '../../../core/config/game_rules.dart';
import 'landmark_spec.dart';

/// Records a greeting as normalised frames: from when the hand appears until
/// the learner has moved and then held still for [hold] ("Hold the sign for 1
/// second"), or [maxDuration] at most. Losing the hand starts over.
class SignSequenceRecorder {
  SignSequenceRecorder({
    this.hold = GameRules.signHold,
    this.maxDuration = GameRules.signMaxDuration,
    this.stillThreshold = 0.08,
    this.moveThreshold = 0.25,
    this.minFrames = 8,
  });

  final Duration hold;
  final Duration maxDuration;

  /// The hand counts as still while it stays within this mean per-landmark
  /// distance of where the stillness began (normalised units, i.e. fractions
  /// of the palm length), so slow movement isn't mistaken for holding.
  final double stillThreshold;

  /// Change from the first frame above which the hand counts as having
  /// moved (signed something), so holding still before signing doesn't end
  /// the recording.
  final double moveThreshold;
  final int minFrames;

  final _frames = <Float64List>[];
  Duration? _start;
  Duration? _stillSince;
  Float64List? _stillAnchor;
  Duration? _last;
  bool _moved = false;

  int get length => _frames.length;
  bool get recording => _frames.isNotEmpty;

  /// How far through the final hold the learner is (0–1).
  double get holdProgress {
    final since = _stillSince;
    final last = _last;
    if (!_moved || since == null || last == null) return 0;
    return ((last - since).inMicroseconds / hold.inMicroseconds)
        .clamp(0, 1)
        .toDouble();
  }

  /// Adds one normalised frame (null = no hand) at [time]. Returns the whole
  /// recording when the sign is complete, then starts afresh.
  List<Float64List>? add(Float64List? features, Duration time) {
    if (features == null) {
      reset();
      return null;
    }
    _start ??= time;
    _last = time;
    if (_frames.isNotEmpty &&
        !_moved &&
        _meanChange(_frames.first, features) > moveThreshold) {
      _moved = true;
    }
    final anchor = _stillAnchor;
    if (anchor == null || _meanChange(anchor, features) > stillThreshold) {
      _stillAnchor = features;
      _stillSince = time;
    }
    _frames.add(features);

    final held =
        _moved &&
        _frames.length >= minFrames &&
        _stillSince != null &&
        time - _stillSince! >= hold;
    final timedOut = time - _start! >= maxDuration;
    if (held || timedOut) {
      final recording = List<Float64List>.of(_frames);
      reset();
      return recording;
    }
    return null;
  }

  void reset() {
    _frames.clear();
    _start = null;
    _stillSince = null;
    _stillAnchor = null;
    _last = null;
    _moved = false;
  }

  static double _meanChange(Float64List a, Float64List b) {
    var sum = 0.0;
    for (var i = 0; i < kFeatureLength; i += 3) {
      final dx = a[i] - b[i];
      final dy = a[i + 1] - b[i + 1];
      final dz = a[i + 2] - b[i + 2];
      sum += math.sqrt(dx * dx + dy * dy + dz * dz);
    }
    return sum / kLandmarkCount;
  }
}
