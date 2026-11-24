import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/game_rules.dart';
import 'package:ishara_app/features/recognition/data/fake/synthetic_hands.dart';
import 'package:ishara_app/features/recognition/domain/entities/hand_frame.dart';
import 'package:ishara_app/features/recognition/domain/landmark_normalizer.dart';
import 'package:ishara_app/features/recognition/domain/sign_scorer.dart';
import 'package:ishara_app/features/recognition/domain/sign_sequence_recorder.dart';

void main() {
  group('SignScorer', () {
    const scorer = SignScorer();
    const t = DtwThresholds(correct: 0.15, almost: 0.8);

    test('thresholds: correct ≤ 0.15 < almost ≤ 0.8 < wrong', () {
      expect(scorer.score(0, t), RecognitionOutcome.correct);
      expect(scorer.score(0.15, t), RecognitionOutcome.correct);
      expect(scorer.score(0.5, t), RecognitionOutcome.almost);
      expect(scorer.score(0.8, t), RecognitionOutcome.almost);
      expect(scorer.score(0.81, t), RecognitionOutcome.wrong);
    });

    test('weakestFinger: the finger with the largest mean error', () {
      final error = Float64List(21);
      for (final i in Finger.ring.landmarks) {
        error[i] = 0.5;
      }
      error[4] = 0.9; // one thumb joint alone doesn't outweigh the ring
      expect(scorer.weakestFinger(error), Finger.ring);
    });
  });

  group('SignSequenceRecorder', () {
    const normalizer = LandmarkNormalizer();
    final hands = SyntheticHands();
    final keys = SyntheticHands.greetingKeyframes('sign');

    List<Float64List>? play(SignSequenceRecorder r, List<HandFrame?> frames) {
      for (final f in frames) {
        final done = r.add(
          f == null ? null : normalizer.normalize(f.landmarks),
          f?.timestamp ?? Duration.zero,
        );
        if (done != null) return done;
      }
      return null;
    }

    test('completes after moving and then holding still for 1 s', () {
      final r = SignSequenceRecorder();
      expect(r.hold, GameRules.signHold);
      final frames = hands.motion(keys);
      final done = play(r, frames);
      expect(done, isNotNull);
      // Moved for 1.2 s, then held ~1 s.
      expect(done!.length, inInclusiveRange(60, frames.length));
      expect(r.recording, isFalse);
    });

    test('holding still without signing never completes before the cap', () {
      final r = SignSequenceRecorder();
      final still = hands.motion(
        [keys.first, keys.first],
        move: Duration.zero,
        hold: const Duration(milliseconds: 2500),
      );
      expect(play(r, still), isNull);
      expect(r.holdProgress, 0);
    });

    test('stops at 4 s even without a hold', () {
      final r = SignSequenceRecorder();
      final restless = hands.motion(
        [...keys, ...keys.reversed, ...keys, ...keys.reversed],
        move: const Duration(seconds: 5),
        hold: Duration.zero,
      );
      final done = play(r, restless);
      expect(done, isNotNull);
      // ~33.3 ms frames: 4 s is at most 122 of them.
      expect(done!.length, lessThanOrEqualTo(4 * 30 + 2));
    });

    test('losing the hand starts over', () {
      final r = SignSequenceRecorder();
      final frames = hands.motion(keys);
      final interrupted = [
        ...frames.sublist(0, 50),
        null,
        ...frames.sublist(50, 70),
      ];
      expect(play(r, interrupted), isNull);
    });
  });
}
