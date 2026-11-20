import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  BoxDecoration radioOf(WidgetTester tester) =>
      tester
              .widget<AnimatedContainer>(
                find.byKey(const ValueKey('selection-radio')),
              )
              .decoration!
          as BoxDecoration;

  Widget card({required bool selected, VoidCallback? onTap}) => SelectionCard(
    icon: IsharaIcons.target,
    title: 'Regular',
    description: '10 min a day',
    selected: selected,
    onTap: onTap ?? () {},
  );

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('state default (${mode.name})', (tester) async {
      await pumpThemed(tester, card(selected: false), mode: mode);
      final highlight = tester.widget<SelectionHighlight>(
        find.byType(SelectionHighlight),
      );
      expect(highlight.selected, isFalse);
      expect(
        tester.widget<Icon>(find.byIcon(IsharaIcons.target)).color,
        c.textPrimary,
      );
      final radio = radioOf(tester);
      expect(radio.color, isNull);
      expect((radio.border! as Border).top.color, c.borderStrong);
      expect(find.byIcon(IsharaIcons.check), findsNothing);
      expect(textColor(tester, 'Regular'), c.textPrimary);
      expect(textColor(tester, '10 min a day'), c.textSecondary);
    });

    testWidgets('state selected (${mode.name})', (tester) async {
      await pumpThemed(tester, card(selected: true), mode: mode);
      await tester.pumpAndSettle();
      final outer =
          tester
                  .widget<AnimatedContainer>(
                    find
                        .descendant(
                          of: find.byType(SelectionHighlight),
                          matching: find.byType(AnimatedContainer),
                        )
                        .first,
                  )
                  .decoration!
              as BoxDecoration;
      expect(outer.color, c.funLavenderSubtle);
      expect((outer.border! as Border).top.color, c.funLavender);
      expect(
        tester.widget<Icon>(find.byIcon(IsharaIcons.target)).color,
        c.funLavenderLip,
      );
      expect(radioOf(tester).color, c.funLavenderLip);
      expect(
        tester.widget<Icon>(find.byIcon(IsharaIcons.check)).color,
        c.staticWhite,
      );
    });

    testWidgets('tap + radio-group semantics (${mode.name})', (tester) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await pumpThemed(
        tester,
        card(selected: true, onTap: () => taps++),
        mode: mode,
      );
      expect(
        tester.getSemantics(find.byType(SelectionCard)),
        matchesSemantics(
          label: 'Regular, 10 min a day',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
          isInMutuallyExclusiveGroup: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.byType(SelectionCard));
      await tester.pumpAndSettle();
      expect(taps, 1);
      handle.dispose();
    });
  }
}
