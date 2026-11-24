import 'dart:math' as math;
import 'dart:typed_data';

import '../../domain/entities/hand_frame.dart';
import '../../domain/landmark_normalizer.dart';

/// How bent each finger is (0 = straight, 1 = fully curled), thumb first.
class HandPose {
  const HandPose(this.curls, {this.tilt = 0});

  /// Thumb, index, middle, ring, pinky.
  final List<double> curls;

  /// Whole-hand rotation around the wrist, in radians.
  final double tilt;

  HandPose lerp(HandPose other, double t) => HandPose([
    for (var i = 0; i < 5; i++) curls[i] + (other.curls[i] - curls[i]) * t,
  ], tilt: tilt + (other.tilt - tilt) * t);

  HandPose withCurl(Finger finger, double curl) =>
      HandPose([...curls]..[finger.index] = curl, tilt: tilt);
}

/// What the fake camera should show.
enum FakeCameraScenario {
  correct('Correct'),
  almost('Almost'),
  wrong('Wrong'),
  noHand('No hand');

  const FakeCameraScenario(this.label);
  final String label;
}

/// Deterministic **synthetic** hands for the fakes and the tests: plausible
/// 21-landmark geometry, not real NSL. Real reference templates and the
/// parity fixture come from `ishara-systems` later.
class SyntheticHands {
  SyntheticHands({this.fps = 30, int seed = 7}) : _random = math.Random(seed);

  final int fps;
  final math.Random _random;

  Duration get frameTime => Duration(microseconds: 1000000 ~/ fps);

  // ---- Poses ----

  /// Synthetic letter handshapes (fingerspelling fakes).
  static const letterPoses = <String, HandPose>{
    'क': HandPose([0.9, 0, 1, 1, 1]),
    'म': HandPose([1, 0, 0, 1, 1]),
    'ल': HandPose([0, 0, 1, 1, 0]),
    'अ': HandPose([0, 1, 1, 1, 1]),
    'इ': HandPose([1, 1, 1, 1, 0]),
    'उ': HandPose([1, 0, 0, 0, 1]),
  };

  /// A synthetic greeting motion: keyframes derived from [signId], so each
  /// sign gets its own movement.
  static List<HandPose> greetingKeyframes(String signId) {
    final r = math.Random(signId.codeUnits.fold<int>(17, (h, c) => h * 31 + c));
    HandPose pose() => HandPose([
      for (var i = 0; i < 5; i++) r.nextDouble(),
    ], tilt: (r.nextDouble() - 0.5) * 0.8);
    return [pose(), pose(), pose()];
  }

  // ---- Frames ----

  /// The 21 landmarks of [pose], placed at [center] (0–1 image coords) with
  /// [scale] (palm length as a fraction of the image).
  HandFrame frame(
    HandPose pose, {
    required Duration time,
    double centerX = 0.5,
    double centerY = 0.7,
    double scale = 0.18,
    double noise = 0,
  }) {
    final points = _landmarks(pose);
    final cos = math.cos(pose.tilt);
    final sin = math.sin(pose.tilt);
    double jitter() => noise == 0 ? 0 : (_random.nextDouble() - 0.5) * noise;
    return HandFrame(
      timestamp: time,
      landmarks: [
        for (final (x, y, z) in points)
          Landmark(
            centerX + (x * cos - y * sin) * scale + jitter() * scale,
            centerY + (x * sin + y * cos) * scale + jitter() * scale,
            z * scale + jitter() * scale,
          ),
      ],
    );
  }

  /// Hand-space landmarks: wrist at the origin, y up is negative (image
  /// coords), palm length (wrist → middle MCP) = 1.
  static List<(double, double, double)> _landmarks(HandPose pose) {
    final out = List<(double, double, double)>.filled(21, (0, 0, 0));
    // Base (MCP) positions and pointing angles per finger.
    const bases = [
      (-0.35, -0.25, -2.3), // thumb CMC, pointing up-left
      (-0.30, -0.95, -1.75),
      (0.0, -1.0, -1.57),
      (0.28, -0.95, -1.4),
      (0.52, -0.82, -1.25),
    ];
    const lengths = [
      [0.35, 0.3, 0.25],
      [0.45, 0.28, 0.22],
      [0.5, 0.3, 0.24],
      [0.46, 0.28, 0.22],
      [0.36, 0.22, 0.18],
    ];
    for (var f = 0; f < 5; f++) {
      final (bx, by, angle) = bases[f];
      final idx = Finger.values[f].landmarks;
      out[idx[0]] = (bx, by, 0);
      var x = bx;
      var y = by;
      var a = angle;
      var z = 0.0;
      final curl = pose.curls[f];
      for (var s = 0; s < 3; s++) {
        // Each joint bends towards the palm.
        a += curl * (f == 0 ? 0.6 : 1.2);
        final len = lengths[f][s];
        x += math.cos(a) * len;
        y += math.sin(a) * len;
        z -= curl * 0.08;
        out[idx[s + 1]] = (x, y, z);
      }
    }
    return out;
  }

  /// [poses] played as keyframes over [move], then held for [hold].
  List<HandFrame> motion(
    List<HandPose> poses, {
    Duration start = Duration.zero,
    Duration move = const Duration(milliseconds: 1200),
    Duration hold = const Duration(milliseconds: 1300),
    double noise = 0.004,
    double centerX = 0.5,
    double centerY = 0.7,
    double scale = 0.18,
  }) {
    final frames = <HandFrame>[];
    final moveFrames = (move.inMicroseconds / frameTime.inMicroseconds).round();
    final holdFrames = (hold.inMicroseconds / frameTime.inMicroseconds).round();
    var t = start;
    for (var i = 0; i < moveFrames; i++) {
      final p = i / math.max(1, moveFrames - 1) * (poses.length - 1);
      final k = math.min(p.floor(), poses.length - 2);
      final pose = poses[k].lerp(poses[k + 1], p - k);
      frames.add(
        frame(
          pose,
          time: t,
          noise: noise,
          centerX: centerX,
          centerY: centerY,
          scale: scale,
        ),
      );
      t += frameTime;
    }
    for (var i = 0; i < holdFrames; i++) {
      frames.add(
        frame(
          poses.last,
          time: t,
          noise: noise,
          centerX: centerX,
          centerY: centerY,
          scale: scale,
        ),
      );
      t += frameTime;
    }
    return frames;
  }

  // ---- Scenarios ----

  /// The frames a fake camera shows for a greeting: a moment with no hand,
  /// then the signing ([scenario] decides how well).
  List<HandFrame?> greetingScenario(
    String signId,
    FakeCameraScenario scenario,
  ) {
    final keys = greetingKeyframes(signId);
    final empty = List<HandFrame?>.filled(6, null);
    final start = frameTime * empty.length;
    return switch (scenario) {
      FakeCameraScenario.noHand => List<HandFrame?>.filled(60, null),
      // Same sign, a bit slower, elsewhere in the frame and nearer.
      FakeCameraScenario.correct => [
        ...empty,
        ...motion(
          keys,
          start: start,
          move: const Duration(milliseconds: 1500),
          centerX: 0.42,
          scale: 0.22,
        ),
      ],
      // Same movement with the index finger bent the whole time.
      FakeCameraScenario.almost => [
        ...empty,
        ...motion([
          for (final k in keys) k.withCurl(Finger.indexFinger, 0.7),
        ], start: start),
      ],
      // Another sign altogether.
      FakeCameraScenario.wrong => [
        ...empty,
        ...motion(greetingKeyframes('$signId-other'), start: start),
      ],
    };
  }

  /// The reference recordings for a greeting template: the same motion at
  /// three speeds.
  List<List<HandFrame>> greetingRecordings(String signId) => [
    for (final ms in const [1000, 1200, 1400])
      motion(greetingKeyframes(signId), move: Duration(milliseconds: ms)),
  ];

  /// Fingerspelling [letters]: each held ~0.9 s with a short change between.
  /// Almost / wrong hold a different letter first.
  List<HandFrame?> fingerspellScenario(
    List<String> letters,
    FakeCameraScenario scenario,
  ) {
    if (scenario == FakeCameraScenario.noHand) {
      return List<HandFrame?>.filled(60, null);
    }
    final shown = scenario == FakeCameraScenario.correct
        ? letters
        : [_otherLetter(letters.first), ...letters];
    return [...List<HandFrame?>.filled(4, null), ..._spell(shown)];
  }

  /// Free practice: cycles through every known letter.
  List<HandFrame?> practiceScenario() => [
    ...List<HandFrame?>.filled(4, null),
    ..._spell(letterPoses.keys.toList()),
  ];

  List<HandFrame> _spell(List<String> letters) {
    final frames = <HandFrame>[];
    var t = frameTime * 4;
    HandPose? previous;
    for (final letter in letters) {
      final pose = letterPoses[letter] ?? letterPoses.values.first;
      if (previous != null) {
        final change = motion(
          [previous, pose],
          start: t,
          move: const Duration(milliseconds: 300),
          hold: Duration.zero,
        );
        frames.addAll(change);
        t += frameTime * change.length;
      }
      final held = motion(
        [pose, pose],
        start: t,
        move: Duration.zero,
        hold: const Duration(milliseconds: 900),
      );
      frames.addAll(held);
      t += frameTime * held.length;
      previous = pose;
    }
    return frames;
  }

  static String _otherLetter(String letter) =>
      letterPoses.keys.firstWhere((l) => l != letter);

  /// Normalised features of a letter's pose (fake classifier prototypes).
  static Float64List letterFeatures(String letter) =>
      const LandmarkNormalizer().normalize(
        SyntheticHands()
            .frame(letterPoses[letter]!, time: Duration.zero)
            .landmarks,
      );
}
