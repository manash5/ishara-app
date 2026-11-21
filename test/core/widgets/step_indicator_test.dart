import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    for (final step in [1, 2, 3]) {
      testWidgets('step $step of 3 (${mode.name})', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpThemed(tester, StepIndicator(current: step), mode: mode);
        await tester.pumpAndSettle();
        for (var i = 1; i <= 3; i++) {
          final bar = find.byKey(ValueKey('step-$i'));
          expect(
            tester.getSize(bar),
            Size(
              i == step
                  ? IsharaSizes.stepBarActive
                  : IsharaSizes.stepBarInactive,
              IsharaSizes.stepBarHeight,
            ),
          );
          final deco =
              tester.widget<AnimatedContainer>(bar).decoration!
                  as BoxDecoration;
          expect(deco.color, i <= step ? c.accentDefault : c.borderDefault);
        }
        expect(find.bySemanticsLabel('Step $step of 3'), findsOneWidget);
        handle.dispose();
      });
    }
  }

  testWidgets('generalises to any total', (tester) async {
    await pumpThemed(tester, const StepIndicator(current: 2, total: 5));
    expect(find.byType(AnimatedContainer), findsNWidgets(5));
  });

  for (final mode in themeModes) {
    final c = tokensFor(mode);
    testWidgets('onHero paints active bars fun/lime (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const StepIndicator(current: 2, onHero: true),
        mode: mode,
      );
      Color? bar(int i) {
        final box = tester.widget<AnimatedContainer>(
          find.byKey(ValueKey('step-$i')),
        );
        return (box.decoration! as BoxDecoration).color;
      }

      expect(bar(1), c.funLime);
      expect(bar(2), c.funLime);
      expect(bar(3), c.borderDefault);
    });
  }
}
