import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/recognition/data/fake/fake_fingerspelling_classifier.dart';
import 'package:ishara_app/features/recognition/data/fake/recognition_fixtures.dart';
import 'package:ishara_app/features/recognition/data/fake/scripted_hand_landmark_detector.dart';
import 'package:ishara_app/features/recognition/data/fake/synthetic_hands.dart';
import 'package:ishara_app/features/recognition/data/sign_template_source.dart';
import 'package:ishara_app/features/recognition/domain/entities/hand_frame.dart';
import 'package:ishara_app/features/recognition/domain/landmark_normalizer.dart';

import '../../../helpers/mock_api.dart';

void main() {
  group('checked-in fixtures match the generator', () {
    // `dart run tool/generate_recognition_fixtures.dart` rewrites them.
    for (final MapEntry(key: path, value: content)
        in RecognitionFixtures.all().entries) {
      test(path, () {
        final onDisk = File(path).readAsStringSync().replaceAll('\r\n', '\n');
        expect(onDisk.trimRight(), content.trimRight());
      });
    }
  });

  test('scripted sequences parse back into frames', () {
    final json = jsonDecode(
      File('test/fixtures/landmark_sequences/greeting_correct.json')
          .readAsStringSync(),
    );
    final frames = RecognitionFixtures.parseSequence(json as List);
    expect(frames.first, isNull, reason: 'the hand enters after a moment');
    final hand = frames.whereType<HandFrame>().first;
    expect(hand.landmarks, hasLength(21));
  });

  group('ScriptedHandLandmarkDetector', () {
    Future<void> wait(int ms) =>
        Future<void>.delayed(Duration(milliseconds: ms));

    test('replays the script in order at its fps, looping with rising '
        'timestamps', () async {
      final hands = SyntheticHands();
      final script = <HandFrame?>[
        null,
        hands.frame(SyntheticHands.letterPoses['क']!, time: Duration.zero),
        hands.frame(
          SyntheticHands.letterPoses['म']!,
          time: const Duration(milliseconds: 33),
        ),
      ];
      final detector = ScriptedHandLandmarkDetector(script, fps: 100);
      final seen = <HandFrame?>[];
      final sub = detector.frames().listen(seen.add);
      await wait(120);
      await sub.cancel();
      await detector.dispose();

      expect(seen.length, greaterThanOrEqualTo(5));
      expect(seen[0], isNull);
      expect(seen[1]!.landmarks, script[1]!.landmarks);
      expect(seen[3], isNull, reason: 'looped back to the start');
      expect(seen[4]!.timestamp, greaterThan(seen[1]!.timestamp));
    });

    test('without looping it ends', () async {
      final detector = ScriptedHandLandmarkDetector(
        const [null, null],
        fps: 100,
        loop: false,
      );
      final events = await detector.frames().toList();
      expect(events, [null, null]);
    });
  });

  group('FakeFingerspellingClassifier', () {
    final classifier = FakeFingerspellingClassifier();
    const normalizer = LandmarkNormalizer();

    test('labels each synthetic letter confidently, wherever the hand is', () {
      final hands = SyntheticHands();
      for (final letter in SyntheticHands.letterPoses.keys) {
        final frame = hands.frame(
          SyntheticHands.letterPoses[letter]!,
          time: Duration.zero,
          centerX: 0.35,
          scale: 0.25,
          noise: 0.004,
        );
        final p = classifier.classify(normalizer.normalize(frame.landmarks));
        expect(p.label, letter);
        expect(p.confidence, greaterThan(0.7));
      }
    });

    test('a left hand needs the left-hand flag', () {
      final frame = SyntheticHands().frame(
        SyntheticHands.letterPoses['म']!,
        time: Duration.zero,
      );
      final left = [
        for (final l in frame.landmarks) Landmark(1 - l.x, l.y, l.z),
      ];
      final p = classifier.classify(
        normalizer.normalize(left, leftHanded: true),
      );
      expect(p.label, 'म');
    });
  });

  group('SignTemplateSource', () {
    test('loads a greeting template from the assets', () async {
      final template = await SignTemplateSource(FixtureBundle())
          .load(RecognitionFixtures.greetingSignIds.first);
      expect(template, isNotNull);
      expect(template!.recordings, hasLength(3));
      expect(template.recordings.first.first, hasLength(63));
      expect(
        template.thresholds.correct,
        RecognitionFixtures.thresholds.correct,
      );
    });

    test('a sign without a template is null', () async {
      expect(await SignTemplateSource(_MissingBundle()).load('nope'), isNull);
    });
  });
}

class _MissingBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) =>
      Future.error(FlutterError('Unable to load asset: $key'));

  @override
  Future<String> loadString(String key, {bool cache = true}) =>
      Future.error(FlutterError('Unable to load asset: $key'));
}
