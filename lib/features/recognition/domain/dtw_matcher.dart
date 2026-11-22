import 'dart:math' as math;
import 'dart:typed_data';

import 'entities/hand_frame.dart';
import 'landmark_spec.dart';

/// The closest template recording and how far the learner was from it.
class DtwMatch {
  const DtwMatch({
    required this.distance,
    required this.perLandmarkError,
    required this.recording,
  });

  /// Path-length-normalised DTW distance (0 = identical).
  final double distance;

  /// Mean distance of each of the 21 landmarks along the warping path, to
  /// find which finger is off.
  final Float64List perLandmarkError;

  /// Index of the best-matching reference recording.
  final int recording;
}

/// Dynamic time warping over normalised landmark sequences
/// (recognition.md): each sequence is resampled to [length] frames, the
/// warping path stays inside a Sakoe-Chiba band of [bandRatio] × [length],
/// and the total cost is divided by the path length.
class DtwMatcher {
  const DtwMatcher({this.length = 32, this.bandRatio = 0.1});

  final int length;
  final double bandRatio;

  /// [sequence] linearly resampled to [length] frames.
  List<Float64List> resample(List<Float64List> sequence) {
    if (sequence.isEmpty) throw ArgumentError('empty sequence');
    if (sequence.length == 1) {
      return List.generate(length, (_) => Float64List.fromList(sequence[0]));
    }
    final out = <Float64List>[];
    final last = sequence.length - 1;
    for (var i = 0; i < length; i++) {
      final t = length == 1 ? 0.0 : i * last / (length - 1);
      final lo = t.floor();
      final hi = math.min(lo + 1, last);
      final f = t - lo;
      final a = sequence[lo];
      final b = sequence[hi];
      final frame = Float64List(a.length);
      for (var k = 0; k < a.length; k++) {
        frame[k] = a[k] + (b[k] - a[k]) * f;
      }
      out.add(frame);
    }
    return out;
  }

  /// The DTW distance between two sequences.
  double distance(List<Float64List> a, List<Float64List> b) =>
      _dtw(resample(a), resample(b)).distance;

  /// The best match of [sequence] against every recording of [template].
  DtwMatch bestMatch(List<Float64List> sequence, SignTemplate template) {
    if (template.recordings.isEmpty) {
      throw ArgumentError('template ${template.signId} has no recordings');
    }
    final query = resample(sequence);
    DtwMatch? best;
    for (final (i, recording) in template.recordings.indexed) {
      final m = _dtw(query, resample(recording), recording: i);
      if (best == null || m.distance < best.distance) best = m;
    }
    return best!;
  }

  DtwMatch _dtw(List<Float64List> a, List<Float64List> b, {int recording = 0}) {
    final n = a.length;
    final m = b.length;
    final band = math.max(1, (bandRatio * math.max(n, m)).ceil());
    final cost = List.generate(n, (_) => Float64List(m)..fillRange(0, m, _inf));
    for (var i = 0; i < n; i++) {
      final from = math.max(0, i - band);
      final to = math.min(m - 1, i + band);
      for (var j = from; j <= to; j++) {
        final d = _frameDistance(a[i], b[j]);
        if (i == 0 && j == 0) {
          cost[i][j] = d;
          continue;
        }
        var prev = _inf;
        if (i > 0) prev = math.min(prev, cost[i - 1][j]);
        if (j > 0) prev = math.min(prev, cost[i][j - 1]);
        if (i > 0 && j > 0) prev = math.min(prev, cost[i - 1][j - 1]);
        cost[i][j] = d + prev;
      }
    }

    // Walk the path back to get its length and the per-landmark error.
    final perLandmark = Float64List(kLandmarkCount);
    var i = n - 1;
    var j = m - 1;
    var steps = 0;
    while (true) {
      _addLandmarkErrors(a[i], b[j], perLandmark);
      steps++;
      if (i == 0 && j == 0) break;
      if (i == 0) {
        j--;
      } else if (j == 0) {
        i--;
      } else {
        final diag = cost[i - 1][j - 1];
        final up = cost[i - 1][j];
        final left = cost[i][j - 1];
        if (diag <= up && diag <= left) {
          i--;
          j--;
        } else if (up <= left) {
          i--;
        } else {
          j--;
        }
      }
    }
    for (var k = 0; k < kLandmarkCount; k++) {
      perLandmark[k] /= steps;
    }
    return DtwMatch(
      distance: cost[n - 1][m - 1] / steps,
      perLandmarkError: perLandmark,
      recording: recording,
    );
  }

  static const _inf = double.infinity;

  /// Euclidean distance over the 63 features.
  static double _frameDistance(Float64List a, Float64List b) {
    var sum = 0.0;
    for (var k = 0; k < a.length; k++) {
      final d = a[k] - b[k];
      sum += d * d;
    }
    return math.sqrt(sum);
  }

  static void _addLandmarkErrors(
    Float64List a,
    Float64List b,
    Float64List into,
  ) {
    for (var k = 0; k < kLandmarkCount; k++) {
      final dx = a[k * 3] - b[k * 3];
      final dy = a[k * 3 + 1] - b[k * 3 + 1];
      final dz = a[k * 3 + 2] - b[k * 3 + 2];
      into[k] += math.sqrt(dx * dx + dy * dy + dz * dz);
    }
  }
}
