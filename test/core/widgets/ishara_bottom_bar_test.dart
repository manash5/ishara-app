import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    for (final active in IsharaTab.values) {
      testWidgets('active ${active.name} (${mode.name})', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpThemed(
          tester,
          IsharaBottomBar(
            current: active,
            onTabSelected: (_) {},
            onPractice: () {},
          ),
          mode: mode,
        );
        for (final t in IsharaTab.values) {
          final color = t == active ? c.accentDefault : c.textTertiary;
          expect(tester.widget<Icon>(find.byIcon(t.icon)).color, color);
          expect(textColor(tester, t.label), color);
          expect(
            tester.getSemantics(find.bySemanticsLabel(t.label)),
            isSemantics(isSelected: t == active, isButton: true),
          );
        }
        handle.dispose();
      });
    }

    testWidgets('bar surface + lime practice button (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        IsharaBottomBar(
          current: IsharaTab.learn,
          onTabSelected: (_) {},
          onPractice: () {},
        ),
        mode: mode,
      );
      final bar =
          tester
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(IsharaBottomBar),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration!
              as BoxDecoration;
      expect(bar.color, c.bgSurface);
      expect(
        bar.borderRadius,
        BorderRadius.circular(IsharaSizes.bottomBarRadius),
      );
      expect((bar.border! as Border).top.color, c.borderSubtle);
      expect(bar.boxShadow, IsharaElevation.level2);

      final practice =
          tester
                  .widget<Container>(
                    find.byKey(const ValueKey('bottom-bar-practice')),
                  )
                  .decoration!
              as BoxDecoration;
      expect(practice.color, c.funLime);
      expect(practice.boxShadow, IsharaElevation.level1);
      expect(
        tester.widget<Icon>(find.byIcon(IsharaIcons.camera)).color,
        c.funTealHero,
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('bottom-bar-practice'))),
        const Size.square(IsharaSizes.practiceButton),
      );
    });
  }

  testWidgets('tabs report selection; camera is an action, not a tab', (
    tester,
  ) async {
    IsharaTab? selected;
    var practice = 0;
    await pumpThemed(
      tester,
      IsharaBottomBar(
        current: IsharaTab.learn,
        onTabSelected: (t) => selected = t,
        onPractice: () => practice++,
      ),
    );
    await tester.tap(find.text('Ranks'));
    expect(selected, IsharaTab.leaderboard);
    await tester.tap(find.byIcon(IsharaIcons.camera));
    await tester.pumpAndSettle();
    expect(practice, 1);
    expect(selected, IsharaTab.leaderboard);
  });

  testWidgets('is 92 tall like Figma, reserving the gesture handle area', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      IsharaBottomBar(
        current: IsharaTab.learn,
        onTabSelected: (_) {},
        onPractice: () {},
      ),
    );
    expect(
      tester.getSize(find.byType(IsharaBottomBar)).height,
      IsharaSizes.bottomBarHeight,
    );
  });
}
