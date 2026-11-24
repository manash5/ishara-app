import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/game_rules.dart';
import 'package:ishara_app/features/recognition/domain/entities/hand_frame.dart';
import 'package:ishara_app/features/recognition/domain/temporal_smoother.dart';

void main() {
  const frame = Duration(milliseconds: 33);

  /// Feeds [predictions] one per frame; returns every accepted letter.
  List<String> feed(
    TemporalSmoother smoother,
    Iterable<LetterPrediction?> predictions, {
    Duration start = Duration.zero,
  }) {
    final accepted = <String>[];
    var t = start;
    for (final p in predictions) {
      final letter = smoother.add(p, t);
      if (letter != null) accepted.add(letter);
      t += frame;
    }
    return accepted;
  }

  test('uses the GameRules constants', () {
    final s = TemporalSmoother();
    expect(s.window, GameRules.fingerspellWindowFrames);
    expect(s.minConfidence, GameRules.fingerspellMinConfidence);
    expect(s.hold, GameRules.fingerspellHold);
  });

  test('accepts a confident letter once it has held for 0.5 s', () {
    final s = TemporalSmoother();
    // A full window (10 frames) then 0.5 s more of the same letter.
    final accepted = feed(
      s,
      List.filled(10 + 16, const LetterPrediction('क', 0.9)),
    );
    expect(accepted, ['क']);
  });

  test('not before the hold', () {
    final s = TemporalSmoother();
    expect(feed(s, List.filled(12, const LetterPrediction('क', 0.9))), isEmpty);
    expect(s.candidate, 'क');
    expect(s.holdProgress, inExclusiveRange(0, 1));
  });

  test('low confidence never accepts', () {
    final s = TemporalSmoother();
    expect(feed(s, List.filled(60, const LetterPrediction('क', 0.5))), isEmpty);
  });

  test('flicker between letters never accepts', () {
    final s = TemporalSmoother();
    final flicker = [
      for (var i = 0; i < 60; i++) LetterPrediction(i.isEven ? 'क' : 'म', 0.95),
    ];
    expect(feed(s, flicker), isEmpty);
  });

  test('a brief wrong frame inside the window is outvoted', () {
    final s = TemporalSmoother();
    final mostly = [
      for (var i = 0; i < 40; i++)
        LetterPrediction(i % 7 == 3 ? 'म' : 'क', 0.9),
    ];
    expect(feed(s, mostly), ['क']);
  });

  test('accepts each letter once; the same letter again only after a '
      'change', () {
    final s = TemporalSmoother();
    final word = [
      ...List.filled(40, const LetterPrediction('क', 0.9)),
      ...List.filled(40, const LetterPrediction('म', 0.9)),
    ];
    expect(feed(s, word), ['क', 'म']);
  });

  test('losing the hand resets the window and the hold', () {
    final s = TemporalSmoother();
    final interrupted = [
      ...List.filled(20, const LetterPrediction('क', 0.9)),
      null,
      ...List.filled(12, const LetterPrediction('क', 0.9)),
    ];
    expect(feed(s, interrupted), isEmpty);
    expect(s.holdProgress, lessThan(1));
  });
}
