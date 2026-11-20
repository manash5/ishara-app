import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_themed.dart';

void main() {
  const childKey = Key('child');

  double dxOf(WidgetTester tester) => tester
      .widget<Transform>(
        find.ancestor(
          of: find.byKey(childKey),
          matching: find.byType(Transform),
        ),
      )
      .transform
      .getTranslation()
      .x;

  Widget shake(int trigger) => Shake(
    trigger: trigger,
    child: const SizedBox.square(key: childKey, dimension: 40),
  );

  for (final mode in themeModes) {
    testWidgets('shakes once on trigger change, then settles (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(tester, shake(0), mode: mode);
      expect(dxOf(tester), 0);

      await pumpThemed(tester, shake(1), mode: mode);
      var maxDx = 0.0;
      for (var i = 0; i < 15; i++) {
        await tester.pump(const Duration(milliseconds: 20));
        final dx = dxOf(tester).abs();
        if (dx > maxDx) maxDx = dx;
        expect(dx, lessThanOrEqualTo(IsharaMotion.shakeOffset + 1e-6));
      }
      expect(maxDx, greaterThan(0));

      await tester.pumpAndSettle();
      expect(dxOf(tester), 0);
    });
  }

  testWidgets('reduced motion: never moves', (tester) async {
    await pumpThemed(tester, shake(0), disableAnimations: true);
    await pumpThemed(tester, shake(1), disableAnimations: true);
    for (var i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 20));
      expect(dxOf(tester), 0);
    }
  });

  testWidgets('rebuild without trigger change does not shake', (tester) async {
    await pumpThemed(tester, shake(3));
    await pumpThemed(tester, shake(3));
    await tester.pump(const Duration(milliseconds: 60));
    expect(dxOf(tester), 0);
  });
}
