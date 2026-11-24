import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/entities/hand_frame.dart';
import 'fake/recognition_fixtures.dart';

/// Loads a greeting's reference templates from
/// `assets/ml/templates/greetings/<signId>.json` (recognition.md).
class SignTemplateSource {
  SignTemplateSource([AssetBundle? bundle]) : _bundle = bundle ?? rootBundle;

  static const root = 'assets/ml/templates/greetings/';

  final AssetBundle _bundle;

  /// The template, or null when this sign has none yet.
  Future<SignTemplate?> load(String signId) async {
    final String raw;
    try {
      raw = await _bundle.loadString('$root$signId.json');
    } catch (_) {
      // No such asset (a FlutterError from rootBundle): no templates yet.
      return null;
    }
    return RecognitionFixtures.parseTemplate(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }
}
