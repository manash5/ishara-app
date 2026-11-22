import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_themed.dart';

void main() {
  const childKey = Key('child');

  double scaleOf(WidgetTester tester) => tester
      .widget<ScaleTransition>(
        find.ancestor(
          of: find.byKey(childKey),
          matching: find.byType(ScaleTransition),
        ),
      )
      .scale
      .value;

  Widget pop() =>
      const PopIn(child: SizedBox.square(key: childKey, dimension: 64));

  for (final mode in themeModes) {
    testWidgets('pops from 0 to full size in celebrate (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(tester, pop(), mode: mode);
      expect(scaleOf(tester), 0);
      await tester.pump(IsharaMotion.celebrate ~/ 2);
      expect(scaleOf(tester), greaterThan(0));
      await tester.pumpAndSettle();
      expect(scaleOf(tester), 1);
    });
  }

  testWidgets('reduced motion: appears at full size', (tester) async {
    await pumpThemed(tester, pop(), disableAnimations: true);
    expect(scaleOf(tester), 1);
  });
}
