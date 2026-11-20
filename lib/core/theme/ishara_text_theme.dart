import 'package:material_ui/material_ui.dart';

import 'ishara_text_styles.dart';

/// Maps the Figma text styles onto Material 3 [TextTheme] slots.
///
/// Figma defines one size per role; the larger M3 slots fall back to the
/// nearest Figma style so nothing ever renders in the platform default font.
/// `stat` and `glyph` live only on [IsharaTextStyles].
TextTheme buildIsharaTextTheme(
  IsharaTextStyles s, {
  required Color body,
  required Color display,
}) {
  TextStyle d(TextStyle t) => t.copyWith(color: display);
  TextStyle b(TextStyle t) => t.copyWith(color: body);
  return TextTheme(
    displayLarge: d(s.displaySmall),
    displayMedium: d(s.displaySmall),
    displaySmall: d(s.displaySmall),
    headlineLarge: d(s.headlineSmall),
    headlineMedium: d(s.headlineSmall),
    headlineSmall: d(s.headlineSmall),
    titleLarge: d(s.titleLarge),
    titleMedium: d(s.titleMedium),
    titleSmall: d(s.labelLarge),
    bodyLarge: b(s.bodyLarge),
    bodyMedium: b(s.bodyMedium),
    bodySmall: b(s.bodySmall),
    labelLarge: b(s.labelLarge),
    labelMedium: b(s.labelMedium),
    labelSmall: b(s.labelSmall),
  );
}
