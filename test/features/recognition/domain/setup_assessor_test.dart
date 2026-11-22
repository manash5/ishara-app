import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/game_rules.dart';
import 'package:ishara_app/features/recognition/data/fake/synthetic_hands.dart';
import 'package:ishara_app/features/recognition/domain/entities/hand_frame.dart';
import 'package:ishara_app/features/recognition/domain/setup_assessor.dart';

void main() {
  const assessor = SetupAssessor();
  final hands = SyntheticHands();
  final pose = SyntheticHands.letterPoses.values.first;

  HandFrame hand({double scale = 0.18, double x = 0.5, double y = 0.7}) => hands
      .frame(pose, time: Duration.zero, scale: scale, centerX: x, centerY: y);

  test('no hand: nothing passes', () {
    final a = assessor.assess(null);
    expect(a.handVisible, isFalse);
    expect(a.inFrame, isFalse);
    expect(a.distance, isNull);
    expect(a.ready, isFalse);
  });

  test('a malformed detection counts as no hand', () {
    final a = assessor.assess(
      const HandFrame(landmarks: [], timestamp: Duration.zero),
    );
    expect(a.handVisible, isFalse);
  });

  test('a centred hand at arm\'s length is ready', () {
    final a = assessor.assess(hand());
    expect(a.handVisible, isTrue);
    expect(a.inFrame, isTrue);
    expect(a.distance, SetupDistance.good);
    expect(a.ready, isTrue);
  });

  test('distance follows the palm length', () {
    expect(
      assessor.assess(hand(scale: GameRules.setupPalmMin * 0.8)).distance,
      SetupDistance.tooFar,
    );
    expect(
      assessor.assess(hand(scale: GameRules.setupPalmMax * 1.1)).distance,
      SetupDistance.tooClose,
    );
  });

  test('a hand cut off by the edge is not in frame', () {
    final a = assessor.assess(hand(x: 0.02));
    expect(a.handVisible, isTrue);
    expect(a.inFrame, isFalse);
    expect(a.ready, isFalse);
  });
}
