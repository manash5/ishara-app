// Writes the synthetic recognition fixtures and greeting templates.
//
//   dart run tool/generate_recognition_fixtures.dart
//
// Synthetic geometry only (not NSL). test/features/recognition/data/
// recognition_fixtures_test.dart fails if the checked-in files drift.
import 'dart:io';

import 'package:ishara_app/features/recognition/data/fake/recognition_fixtures.dart';

void main() {
  for (final MapEntry(key: path, value: content)
      in RecognitionFixtures.all().entries) {
    final file = File(path)..parent.createSync(recursive: true);
    file.writeAsStringSync('$content\n');
    stdout.writeln('wrote $path');
  }
}
