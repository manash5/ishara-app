import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('radius tokens match Figma "Radius"', () {
    expect(
      [
        IsharaRadius.sm,
        IsharaRadius.md,
        IsharaRadius.lg,
        IsharaRadius.xl,
        IsharaRadius.sheet,
        IsharaRadius.full,
      ],
      [8, 12, 16, 20, 28, 999],
    );
  });

  test('BorderRadius helpers use the tokens', () {
    expect(IsharaRadius.brLg, BorderRadius.circular(16));
    expect(IsharaRadius.brSheet, BorderRadius.circular(28));
    expect(IsharaRadius.sheetTop.topLeft, const Radius.circular(28));
    expect(IsharaRadius.sheetTop.bottomLeft, Radius.zero);
  });

  test('elevation matches Figma effect styles', () {
    expect(IsharaElevation.level1.single.offset, const Offset(0, 2));
    expect(IsharaElevation.level1.single.blurRadius, 8);
    expect(IsharaElevation.level2.single.offset, const Offset(0, 8));
    expect(IsharaElevation.level2.single.blurRadius, 24);
  });
}
