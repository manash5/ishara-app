import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_themed.dart';

void main() {
  BoxDecoration decorationOf(WidgetTester tester) =>
      tester
              .widget<AnimatedContainer>(find.byType(AnimatedContainer))
              .decoration!
          as BoxDecoration;

  for (final mode in themeModes) {
    final c = mode == ThemeMode.dark ? IsharaColors.dark : IsharaColors.light;

    testWidgets(
      'selected = 2px funLavender on funLavenderSubtle (${mode.name})',
      (tester) async {
        await pumpThemed(
          tester,
          const SelectionHighlight(selected: true, child: Text('A')),
          mode: mode,
        );
        final d = decorationOf(tester);
        final border = d.border! as Border;
        expect(d.color, c.funLavenderSubtle);
        expect(border.top.color, c.funLavender);
        expect(border.top.width, 2);
      },
    );

    testWidgets(
      'unselected = 1.5px borderDefault on bgSurface (${mode.name})',
      (tester) async {
        await pumpThemed(
          tester,
          const SelectionHighlight(selected: false, child: Text('A')),
          mode: mode,
        );
        final d = decorationOf(tester);
        final border = d.border! as Border;
        expect(d.color, c.bgSurface);
        expect(border.top.color, c.borderDefault);
        expect(border.top.width, 1.5);
      },
    );
  }

  testWidgets('animates in fast, instant with reduced motion', (tester) async {
    await pumpThemed(
      tester,
      const SelectionHighlight(selected: true, child: Text('A')),
    );
    expect(
      tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).duration,
      IsharaMotion.fast,
    );
    await pumpThemed(
      tester,
      const SelectionHighlight(selected: true, child: Text('A')),
      disableAnimations: true,
    );
    expect(
      tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).duration,
      Duration.zero,
    );
  });
}
