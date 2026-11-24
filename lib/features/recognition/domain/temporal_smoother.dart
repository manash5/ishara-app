import 'dart:collection';

import '../../../core/config/game_rules.dart';
import 'entities/hand_frame.dart';

/// Steadies the fingerspelling classifier: a letter is accepted when the
/// majority class over the last [window] frames has a mean confidence of at
/// least [minConfidence] and has stayed the majority for [hold]
/// (recognition.md; constants in `GameRules`). Losing the hand resets it.
class TemporalSmoother {
  TemporalSmoother({
    this.window = GameRules.fingerspellWindowFrames,
    this.minConfidence = GameRules.fingerspellMinConfidence,
    this.hold = GameRules.fingerspellHold,
  });

  final int window;
  final double minConfidence;
  final Duration hold;

  final _recent = ListQueue<LetterPrediction>();
  String? _candidate;
  Duration? _since;
  Duration? _last;
  String? _accepted;

  /// The steady majority letter right now (not yet accepted), if any.
  String? get candidate => _candidate;

  /// How far through [hold] the [candidate] is (0–1).
  double get holdProgress {
    final since = _since;
    final last = _last;
    if (_candidate == null || since == null || last == null) return 0;
    final p = (last - since).inMicroseconds / hold.inMicroseconds;
    return p.clamp(0, 1).toDouble();
  }

  /// Adds one frame's prediction (null = no hand) taken at [time]. Returns
  /// the letter when it is accepted, once; the same letter is accepted again
  /// only after another letter or no hand.
  String? add(LetterPrediction? prediction, Duration time) {
    if (prediction == null) {
      reset();
      return null;
    }
    _last = time;
    _recent.addLast(prediction);
    while (_recent.length > window) {
      _recent.removeFirst();
    }

    final majority = _steadyMajority();
    if (majority == null) {
      _candidate = null;
      _since = null;
      return null;
    }
    if (majority != _candidate) {
      _candidate = majority;
      _since = time;
      if (majority != _accepted) _accepted = null;
      return null;
    }
    if (time - _since! >= hold && majority != _accepted) {
      _accepted = majority;
      return majority;
    }
    return null;
  }

  /// The label with more than half of a full window and enough mean
  /// confidence, else null.
  String? _steadyMajority() {
    if (_recent.length < window) return null;
    final counts = <String, int>{};
    final confidence = <String, double>{};
    for (final p in _recent) {
      counts[p.label] = (counts[p.label] ?? 0) + 1;
      confidence[p.label] = (confidence[p.label] ?? 0) + p.confidence;
    }
    for (final MapEntry(key: label, value: count) in counts.entries) {
      if (count * 2 > _recent.length &&
          confidence[label]! / count >= minConfidence) {
        return label;
      }
    }
    return null;
  }

  void reset() {
    _recent.clear();
    _candidate = null;
    _since = null;
    _last = null;
    _accepted = null;
  }
}
