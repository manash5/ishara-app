import 'dart:convert';
import 'dart:typed_data';

import '../../domain/entities/hand_frame.dart';
import '../../domain/landmark_normalizer.dart';
import '../../domain/landmark_spec.dart';
import 'synthetic_hands.dart';

/// Builds every synthetic recognition file from [SyntheticHands], so
/// `tool/generate_recognition_fixtures.dart` writes them and a test checks
/// the checked-in copies haven't drifted.
///
/// All of it is synthetic geometry — not NSL. The real parity fixture comes
/// from `ishara-systems/shared/fixtures/` and the real templates from
/// `ishara-systems/ml`.
abstract final class RecognitionFixtures {
  /// Greetings with a Sign it exercise in the lesson fixtures (Namaste) and
  /// one more, so the template loader is exercised for several signs.
  static const greetingSignIds = [
    '91a1aaec-304d-5c72-8be7-3404cc351df2', // Namaste
    '9010db34-4029-511e-bbed-d00a6b244f75', // Thank you
  ];

  /// The fingerspelled word in the lesson fixture (कमल).
  static const word = ['क', 'म', 'ल'];

  /// Per-sign thresholds, calibrated on the synthetic data (correct ≈ 0.04,
  /// almost ≈ 0.35, a different sign ≈ 1.7).
  static const thresholds = DtwThresholds(correct: 0.15, almost: 0.8);

  static const _encoder = JsonEncoder.withIndent(' ');

  /// Relative path → file content.
  static Map<String, String> all() => {
    'test/fixtures/landmark_parity.json': _encoder.convert(parity()),
    for (final s in FakeCameraScenario.values) ...{
      'test/fixtures/landmark_sequences/greeting_${s.name}.json': jsonEncode(
        _sequence(SyntheticHands().greetingScenario(greetingSignIds.first, s)),
      ),
      'test/fixtures/landmark_sequences/fingerspell_${s.name}.json': jsonEncode(
        _sequence(SyntheticHands().fingerspellScenario(word, s)),
      ),
    },
    for (final id in greetingSignIds)
      'assets/ml/templates/greetings/$id.json': jsonEncode(template(id)),
  };

  /// A synthetic stand-in for `ishara-systems`' parity fixture, in the same
  /// shape: raw landmarks and the spec v1 features they must normalise to.
  static Map<String, Object> parity() {
    const normalizer = LandmarkNormalizer();
    final hands = SyntheticHands(seed: 3);
    final cases = <Map<String, Object>>[];
    for (final (i, letter) in SyntheticHands.letterPoses.keys.indexed) {
      final frame = hands.frame(
        SyntheticHands.letterPoses[letter]!,
        time: Duration.zero,
        centerX: 0.3 + i * 0.08,
        scale: 0.12 + i * 0.02,
        noise: 0.01,
      );
      for (final left in const [false, true]) {
        cases.add({
          'leftHanded': left,
          'landmarks': [
            for (final l in frame.landmarks) [_r(l.x), _r(l.y), _r(l.z)],
          ],
          'expected': [
            for (final v in normalizer.normalize([
              for (final l in frame.landmarks)
                Landmark(_r(l.x), _r(l.y), _r(l.z)),
            ], leftHanded: left))
              _r(v),
          ],
        });
      }
    }
    return {
      'specVersion': kLandmarkSpecVersion,
      'synthetic': true,
      'note':
          'Synthetic placeholder. Replace with ishara-systems/shared/fixtures/'
          'landmark_parity.json.',
      'cases': cases,
    };
  }

  /// A greeting's reference recordings as normalised spec v1 frames.
  static Map<String, Object> template(String signId) {
    const normalizer = LandmarkNormalizer();
    return {
      'specVersion': kLandmarkSpecVersion,
      'synthetic': true,
      'signId': signId,
      'thresholds': {
        'correct': thresholds.correct,
        'almost': thresholds.almost,
      },
      'recordings': [
        for (final recording in SyntheticHands().greetingRecordings(signId))
          [
            for (final f in recording)
              [for (final v in normalizer.normalize(f.landmarks)) _r(v)],
          ],
      ],
    };
  }

  /// Parses a template file.
  static SignTemplate parseTemplate(Map<String, dynamic> json) {
    final t = json['thresholds'] as Map<String, dynamic>;
    return SignTemplate(
      signId: json['signId'] as String,
      thresholds: DtwThresholds(
        correct: (t['correct'] as num).toDouble(),
        almost: (t['almost'] as num).toDouble(),
      ),
      recordings: [
        for (final r in json['recordings'] as List)
          [
            for (final f in r as List)
              Float64List.fromList([
                for (final v in f as List) (v as num).toDouble(),
              ]),
          ],
      ],
    );
  }

  /// A scripted sequence: `null` for "no hand", else `{t, landmarks}`.
  static List<Object?> _sequence(List<HandFrame?> frames) => [
    for (final f in frames)
      f == null
          ? null
          : {
              't': f.timestamp.inMilliseconds,
              'landmarks': [
                for (final l in f.landmarks) [_r(l.x), _r(l.y), _r(l.z)],
              ],
            },
  ];

  /// Reads a scripted sequence back into frames (null = no hand).
  static List<HandFrame?> parseSequence(List<dynamic> json) => [
    for (final f in json)
      f == null
          ? null
          : HandFrame(
              timestamp: Duration(
                milliseconds: ((f as Map<String, dynamic>)['t'] as num).toInt(),
              ),
              landmarks: [
                for (final l in f['landmarks'] as List)
                  Landmark(
                    ((l as List)[0] as num).toDouble(),
                    (l[1] as num).toDouble(),
                    (l[2] as num).toDouble(),
                  ),
              ],
            ),
  ];

  static double _r(double v) => (v * 1e5).roundToDouble() / 1e5;
}
