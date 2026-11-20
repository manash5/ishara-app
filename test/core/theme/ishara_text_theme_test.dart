import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  const body = Color(0xFF111111), display = Color(0xFF222222);
  final s = IsharaTextStyles.standard;
  final theme = buildIsharaTextTheme(s, body: body, display: display);

  test('every M3 slot is set and uses Plus Jakarta Sans', () {
    final slots = {
      'displayLarge': theme.displayLarge,
      'displayMedium': theme.displayMedium,
      'displaySmall': theme.displaySmall,
      'headlineLarge': theme.headlineLarge,
      'headlineMedium': theme.headlineMedium,
      'headlineSmall': theme.headlineSmall,
      'titleLarge': theme.titleLarge,
      'titleMedium': theme.titleMedium,
      'titleSmall': theme.titleSmall,
      'bodyLarge': theme.bodyLarge,
      'bodyMedium': theme.bodyMedium,
      'bodySmall': theme.bodySmall,
      'labelLarge': theme.labelLarge,
      'labelMedium': theme.labelMedium,
      'labelSmall': theme.labelSmall,
    };
    for (final MapEntry(:key, :value) in slots.entries) {
      expect(value, isNotNull, reason: key);
      expect(value!.fontFamily, IsharaFonts.sans, reason: key);
    }
  });

  test('Figma styles map 1:1 onto their M3 slots with colours', () {
    expect(theme.displaySmall!.fontSize, s.displaySmall.fontSize);
    expect(theme.displaySmall!.color, display);
    expect(theme.bodyLarge!.fontSize, s.bodyLarge.fontSize);
    expect(theme.bodyLarge!.color, body);
    expect(theme.labelSmall!.letterSpacing, s.labelSmall.letterSpacing);
    expect(theme.titleSmall!.fontSize, s.labelLarge.fontSize);
  });
}
