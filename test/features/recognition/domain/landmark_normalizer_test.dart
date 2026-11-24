import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/recognition/data/fake/synthetic_hands.dart';
import 'package:ishara_app/features/recognition/domain/entities/hand_frame.dart';
import 'package:ishara_app/features/recognition/domain/landmark_normalizer.dart';
import 'package:ishara_app/features/recognition/domain/landmark_spec.dart';

void main() {
  const normalizer = LandmarkNormalizer();
  final hand = SyntheticHands()
      .frame(SyntheticHands.letterPoses['क']!, time: Duration.zero)
      .landmarks;

  List<Landmark> transform(
    List<Landmark> lm, {
    double dx = 0,
    double dy = 0,
    double scale = 1,
    bool mirror = false,
  }) => [
    for (final l in lm)
      Landmark(
        (mirror ? 1 - l.x : l.x) * scale + dx,
        l.y * scale + dy,
        l.z * scale,
      ),
  ];

  void expectClose(List<double> a, List<double> b) {
    expect(a.length, b.length);
    for (var i = 0; i < a.length; i++) {
      expect(a[i], closeTo(b[i], 1e-9), reason: 'feature $i');
    }
  }

  test('63 floats, spec v1', () {
    expect(kLandmarkSpecVersion, 1);
    expect(normalizer.normalize(hand), hasLength(kFeatureLength));
  });

  test('the wrist is the origin and the palm length is 1', () {
    final f = normalizer.normalize(hand);
    expect(f.sublist(0, 3), [0, 0, 0]);
    final mcp = f.sublist(kMiddleMcp * 3, kMiddleMcp * 3 + 3);
    final length = mcp.fold<double>(0, (s, v) => s + v * v);
    expect(length, closeTo(1, 1e-9));
  });

  test('moving the hand or changing its size changes nothing', () {
    expectClose(
      normalizer.normalize(transform(hand, dx: 0.21, dy: -0.13, scale: 1.7)),
      normalizer.normalize(hand),
    );
  });

  test('a left hand, mirrored, matches the right-handed features', () {
    final left = transform(hand, mirror: true);
    expectClose(
      normalizer.normalize(left, leftHanded: true),
      normalizer.normalize(hand),
    );
    // Without the left-hand flag the mirrored hand differs.
    expect(
      normalizer.normalize(left)[8 * 3],
      closeTo(-normalizer.normalize(hand)[8 * 3], 1e-9),
    );
  });

  test('rejects a wrong landmark count or a zero palm length', () {
    expect(
      () => normalizer.normalize(hand.sublist(0, 20)),
      throwsArgumentError,
    );
    expect(
      () => normalizer.normalize(
        List.filled(kLandmarkCount, const Landmark(0.5, 0.5, 0)),
      ),
      throwsArgumentError,
    );
  });

  test('parity fixture (synthetic until ishara-systems provides it)', () {
    final json = jsonDecode(
      File('test/fixtures/landmark_parity.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    expect(json['specVersion'], kLandmarkSpecVersion);
    final cases = json['cases'] as List;
    expect(cases, isNotEmpty);
    for (final c in cases.cast<Map<String, dynamic>>()) {
      final landmarks = [
        for (final l in c['landmarks'] as List)
          Landmark(
            ((l as List)[0] as num).toDouble(),
            (l[1] as num).toDouble(),
            (l[2] as num).toDouble(),
          ),
      ];
      final out = normalizer.normalize(
        landmarks,
        leftHanded: c['leftHanded'] as bool,
      );
      final expected = [
        for (final v in c['expected'] as List) (v as num).toDouble(),
      ];
      for (var i = 0; i < kFeatureLength; i++) {
        expect(out[i], closeTo(expected[i], 1e-4));
      }
    }
  });
}
