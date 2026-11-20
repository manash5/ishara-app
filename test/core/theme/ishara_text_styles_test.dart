import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  final s = IsharaTextStyles.standard;

  void expectStyle(
    TextStyle style, {
    required double size,
    required double line,
    required FontWeight weight,
    String family = IsharaFonts.sans,
    double trackingPercent = 0,
  }) {
    expect(style.fontFamily, family);
    expect(style.fontSize, size);
    expect(style.height! * size, closeTo(line, 0.001));
    expect(style.fontWeight, weight);
    expect(style.letterSpacing, closeTo(size * trackingPercent / 100, 1e-9));
    expect(style.color, isNull, reason: 'styles are colourless');
  }

  test('display/small = 32/40 ExtraBold −1.5%', () {
    expectStyle(
      s.displaySmall,
      size: 32,
      line: 40,
      weight: FontWeight.w800,
      trackingPercent: -1.5,
    );
  });

  test('headline/small = 26/32 Bold −0.5% (Figma style, not caption)', () {
    expectStyle(
      s.headlineSmall,
      size: 26,
      line: 32,
      weight: FontWeight.w700,
      trackingPercent: -0.5,
    );
  });

  test('label/large = 15/20 SemiBold, no tracking', () {
    expectStyle(s.labelLarge, size: 15, line: 20, weight: FontWeight.w600);
  });

  test('label/small = 11/14 Bold +4%', () {
    expectStyle(
      s.labelSmall,
      size: 11,
      line: 14,
      weight: FontWeight.w700,
      trackingPercent: 4,
    );
  });

  test('custom/stat = 22/28 ExtraBold −0.5%', () {
    expectStyle(
      s.stat,
      size: 22,
      line: 28,
      weight: FontWeight.w800,
      trackingPercent: -0.5,
    );
  });

  test('custom/glyph = 88/96 Anek Devanagari SemiBold', () {
    expectStyle(
      s.glyph,
      size: 88,
      line: 96,
      weight: FontWeight.w600,
      family: IsharaFonts.devanagari,
    );
    expect(s.glyph.fontVariations, [const FontVariation.weight(600)]);
  });

  test('has all 12 Figma text styles', () {
    expect(s.byFigmaName, hasLength(12));
  });

  test('lerp and copyWith', () {
    expect(s.lerp(s, 0.5).bodyLarge.fontSize, 16);
    expect(s.lerp(null, 0.5), same(s));
    final big = s.copyWith(bodyLarge: s.bodyLarge.copyWith(fontSize: 40));
    expect(big.bodyLarge.fontSize, 40);
    expect(big.bodyMedium, s.bodyMedium);
  });
}
