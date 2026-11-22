import 'dart:typed_data';

import '../domain/entities/hand_frame.dart';

/// Classifies one normalised hand (63 floats, spec v1) as a letter.
///
/// The real implementation runs `assets/ml/fingerspelling.tflite` with
/// `labels.json` through `tflite_flutter`, loaded once (keepAlive), off the
/// UI thread. Until then the app uses `FakeFingerspellingClassifier`.
abstract interface class FingerspellingClassifier {
  Future<void> load();

  /// The most likely letter and its confidence (0–1).
  LetterPrediction classify(Float64List features);

  void dispose();
}
