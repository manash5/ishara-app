import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/recognition/data/fake/recognition_fixtures.dart';
import 'package:ishara_app/features/recognition/data/fake/synthetic_hands.dart';
import 'package:ishara_app/features/recognition/domain/dtw_matcher.dart';
import 'package:ishara_app/features/recognition/domain/entities/hand_frame.dart';
import 'package:ishara_app/features/recognition/domain/landmark_normalizer.dart';

void main() {
  const matcher = DtwMatcher();
  const normalizer = LandmarkNormalizer();
  const namaste = '91a1aaec-304d-5c72-8be7-3404cc351df2';
  const thresholds = RecognitionFixtures.thresholds;

  List<Float64List> features(List<HandFrame> frames) => [
    for (final f in frames) normalizer.normalize(f.landmarks),
  ];

  List<Float64List> sign(
    String id, {
    int moveMs = 1200,
    double noise = 0,
    Duration pause = Duration.zero,
  }) {
    final hands = SyntheticHands();
    final keys = SyntheticHands.greetingKeyframes(id);
    final first = hands.motion(
      keys.sublist(0, 2),
      move: Duration(milliseconds: moveMs ~/ 2),
      hold: pause,
      noise: noise,
    );
    final second = hands.motion(
      keys.sublist(1),
      move: Duration(milliseconds: moveMs ~/ 2),
      noise: noise,
    );
    return features([...first, ...second]);
  }

  test('resamples to a fixed length', () {
    final s = sign(namaste);
    expect(matcher.resample(s), hasLength(matcher.length));
    expect(matcher.resample(s.sublist(0, 1)), hasLength(matcher.length));
    expect(matcher.resample(s).first, s.first);
    expect(matcher.resample(s).last, s.last);
  });

  test('identical sequences → 0', () {
    final s = sign(namaste);
    expect(matcher.distance(s, s), 0);
  });

  test('time-warped (slower, faster, paused) → small, within "correct"', () {
    final reference = sign(namaste);
    for (final warped in [
      sign(namaste, moveMs: 2000),
      sign(namaste, moveMs: 700),
      sign(namaste, pause: const Duration(milliseconds: 400)),
      sign(namaste, noise: 0.004),
    ]) {
      final d = matcher.distance(reference, warped);
      expect(d, lessThan(thresholds.correct), reason: 'd = $d');
    }
  });

  test('a different sign → large, beyond "almost"', () {
    final d = matcher.distance(sign(namaste), sign('another-sign'));
    expect(d, greaterThan(thresholds.almost));
  });

  test('symmetric', () {
    final a = sign(namaste);
    final b = sign(namaste, moveMs: 1600, noise: 0.004);
    expect(matcher.distance(a, b), closeTo(matcher.distance(b, a), 1e-9));
  });

  test('the band limits warping: a sequence shifted far beyond it costs '
      'more', () {
    final s = sign(namaste);
    final narrow = DtwMatcher(bandRatio: 0.03);
    final wide = DtwMatcher(bandRatio: 0.5);
    final shifted = [...List.filled(30, s.first), ...s];
    expect(narrow.distance(s, shifted), greaterThan(wide.distance(s, shifted)));
  });

  test('bestMatch picks the closest recording and reports per-landmark '
      'error', () {
    final template = SignTemplate(
      signId: namaste,
      thresholds: thresholds,
      recordings: [sign('another-sign'), sign(namaste)],
    );
    final m = matcher.bestMatch(sign(namaste, noise: 0.004), template);
    expect(m.recording, 1);
    expect(m.perLandmarkError, hasLength(21));
    expect(m.distance, lessThan(thresholds.correct));
  });
}
