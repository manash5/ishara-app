import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  // Values from the Figma "Color" collection (Light, Dark).
  const expected = <String, (int, int)>{
    'bg/canvas': (0xFFF5F7F6, 0xFF0F2A2D),
    'bg/surface': (0xFFFFFFFF, 0xFF163A3E),
    'text/primary': (0xFF163A3E, 0xFFF1F7F4),
    'text/on-accent': (0xFFFFFFFF, 0xFF163A3E),
    'accent/default': (0xFF1F4D52, 0xFFC6F04D),
    'accent/lip': (0xFF0F2E31, 0xFF8FB51F),
    'success/default': (0xFF4CC97E, 0xFF5ED38B),
    'danger/default': (0xFFF2654E, 0xFFFF7A64),
    'border/default': (0xFFE1E7E6, 0xFF2B5A5E),
    'fun/gold': (0xFFFFB020, 0xFFFFBE45),
    'fun/lavender': (0xFFB79CF0, 0xFFC4ADF5),
    'fun/lavender-subtle': (0xFFEFE9FC, 0xFF33305A),
    'fun/lime-lip': (0xFF9CC427, 0xFF9CC427),
    'fun/teal-hero': (0xFF1F4D52, 0xFF1F4D52),
  };

  group('IsharaColors', () {
    test('exposes all 45 Figma semantic tokens', () {
      expect(IsharaColors.light.byFigmaName, hasLength(45));
      expect(IsharaColors.dark.byFigmaName, hasLength(45));
    });

    for (final MapEntry(key: name, value: (light, dark)) in expected.entries) {
      test('$name matches Figma in Light and Dark', () {
        expect(IsharaColors.light.byFigmaName[name], Color(light));
        expect(IsharaColors.dark.byFigmaName[name], Color(dark));
      });
    }

    test('lerp returns the endpoints at t = 0 and t = 1', () {
      final a = IsharaColors.light, b = IsharaColors.dark;
      expect(a.lerp(b, 0).byFigmaName, a.byFigmaName);
      expect(a.lerp(b, 1).byFigmaName, b.byFigmaName);
      expect(a.lerp(null, 0.5), same(a));
    });

    test('copyWith replaces only the given token', () {
      const red = Color(0xFFFF0000);
      final copy = IsharaColors.light.copyWith(accentDefault: red);
      expect(copy.accentDefault, red);
      expect(copy.bgCanvas, IsharaColors.light.bgCanvas);
    });
  });
}
