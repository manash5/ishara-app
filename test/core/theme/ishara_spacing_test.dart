import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';

void main() {
  test('4-pt scale matches Figma "Spacing"', () {
    expect(
      [
        IsharaSpacing.s0,
        IsharaSpacing.s1,
        IsharaSpacing.s2,
        IsharaSpacing.s3,
        IsharaSpacing.s4,
        IsharaSpacing.s5,
        IsharaSpacing.s6,
        IsharaSpacing.s8,
        IsharaSpacing.s10,
        IsharaSpacing.s12,
      ],
      [0, 4, 8, 12, 16, 20, 24, 32, 40, 48],
    );
  });

  test('layout aliases resolve to Figma values', () {
    expect(IsharaSpacing.screenMargin, 24);
    expect(IsharaSpacing.cardPadding, 16);
    expect(IsharaSpacing.sectionGap, 32);
    expect(IsharaSpacing.listGap, 12);
    expect(IsharaSpacing.stackGap, 8);
    expect(IsharaSpacing.inlineGap, 8);
  });
}
