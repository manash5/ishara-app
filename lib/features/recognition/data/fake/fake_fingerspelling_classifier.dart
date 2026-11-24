import 'dart:math' as math;
import 'dart:typed_data';

import '../../domain/entities/hand_frame.dart';
import '../fingerspelling_classifier.dart';
import 'synthetic_hands.dart';

/// Nearest-prototype classifier over the synthetic letter handshapes: close
/// enough to a model's behaviour (steady, confident on a held letter;
/// uncertain mid-change) to drive the real smoother. Stands in for the
/// TFLite model until it lands.
class FakeFingerspellingClassifier implements FingerspellingClassifier {
  FakeFingerspellingClassifier({this.temperature = 0.05});

  /// Softmax temperature over squared distances: lower = more confident.
  final double temperature;

  late final Map<String, Float64List> _prototypes = {
    for (final letter in SyntheticHands.letterPoses.keys)
      letter: SyntheticHands.letterFeatures(letter),
  };

  @override
  Future<void> load() async {}

  @override
  LetterPrediction classify(Float64List features) {
    final scores = <String, double>{};
    var best = '';
    var bestScore = double.negativeInfinity;
    for (final MapEntry(key: letter, value: proto) in _prototypes.entries) {
      var d2 = 0.0;
      for (var k = 0; k < proto.length; k++) {
        final d = proto[k] - features[k];
        d2 += d * d;
      }
      final score = -d2 / temperature;
      scores[letter] = score;
      if (score > bestScore) {
        bestScore = score;
        best = letter;
      }
    }
    // Softmax (shifted by the best score for stability).
    var sum = 0.0;
    for (final s in scores.values) {
      sum += math.exp(s - bestScore);
    }
    return LetterPrediction(best, 1 / sum);
  }

  @override
  void dispose() {}
}
