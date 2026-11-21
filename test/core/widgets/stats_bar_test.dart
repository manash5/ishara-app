import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('badge lip, gold streak/XP, danger hearts (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        const StatsBar(streak: 12, xp: 340, hearts: 5),
        mode: mode,
      );
      final badge = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byKey(const ValueKey('course-badge')),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((b) => (b.decoration as ShapeDecoration).color)
          .toList();
      expect(badge, [c.accentLip, c.accentDefault]);
      expect(textColor(tester, 'NSL'), c.textOnAccent);

      final icons = {
        for (final i in tester.widgetList<IsharaFilledIcon>(
          find.byType(IsharaFilledIcon),
        ))
          i.kind: i.color,
      };
      expect(icons, {
        IsharaFilledIconKind.flame: c.funGold,
        IsharaFilledIconKind.zap: c.funGold,
        IsharaFilledIconKind.heart: c.dangerDefault,
      });
      expect(textColor(tester, '12'), c.funGoldLip);
      expect(textColor(tester, '340'), c.funGoldLip);
      expect(textColor(tester, '5'), c.dangerDefault);
      expect(
        find.bySemanticsLabel('12 day streak, 340 XP, 5 hearts'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Course: Nepali Sign Language'),
        findsOneWidget,
      );
      expect(
        tester.getSize(find.byType(StatsBar)).height,
        IsharaSizes.statsBarHeight,
      );
      handle.dispose();
    });
  }

  testWidgets('course badge presses into its lip and taps', (tester) async {
    var taps = 0;
    await pumpThemed(
      tester,
      StatsBar(streak: 1, xp: 2, hearts: 3, onCourse: () => taps++),
    );
    await tester.tap(find.text('NSL'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });
}
