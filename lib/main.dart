import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';

void main() {
  registerFontLicenses();
  runApp(const ProviderScope(child: IsharaApp()));
}

/// Adds the bundled fonts' OFL licences to the app's licence page.
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in const [
      ('Plus Jakarta Sans', 'assets/fonts/OFL-PlusJakartaSans.txt'),
      ('Anek Devanagari', 'assets/fonts/OFL-AnekDevanagari.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        family,
      ], await rootBundle.loadString(file));
    }
  });
}
