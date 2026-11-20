import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  test('durations follow motion.md', () {
    expect(IsharaMotion.instant, const Duration(milliseconds: 100));
    expect(IsharaMotion.fast, const Duration(milliseconds: 200));
    expect(IsharaMotion.standard, const Duration(milliseconds: 300));
    expect(IsharaMotion.page, const Duration(milliseconds: 400));
    expect(IsharaMotion.celebrate, const Duration(milliseconds: 500));
  });

  test('curves are the M3 easing tokens', () {
    expect(IsharaMotion.enter, Easing.emphasizedDecelerate);
    expect(IsharaMotion.exit, Easing.emphasizedAccelerate);
    expect(IsharaMotion.move, Easing.standard);
    expect(IsharaMotion.playful, Curves.easeOutBack);
  });

  test('exit runs at 75% of enter', () {
    expect(
      IsharaMotion.exitDuration(IsharaMotion.standard),
      const Duration(milliseconds: 225),
    );
  });

  for (final reduced in [false, true]) {
    testWidgets('duration() with disableAnimations=$reduced', (tester) async {
      late Duration d;
      await pumpThemed(
        tester,
        Builder(
          builder: (context) {
            d = IsharaMotion.duration(context, IsharaMotion.fast);
            return const SizedBox();
          },
        ),
        disableAnimations: reduced,
      );
      expect(d, reduced ? Duration.zero : IsharaMotion.fast);
    });
  }
}
