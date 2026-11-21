import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  Widget header(UnitColor color, {VoidCallback? onGuide}) => SizedBox(
    width: 364,
    child: UnitHeader(
      unit: 1,
      title: 'Greetings & etiquette',
      learned: 4,
      total: 12,
      color: color,
      onGuide: onGuide ?? () {},
    ),
  );

  for (final mode in themeModes) {
    final c = tokensFor(mode);
    final expected = {
      UnitColor.teal: (c.funTealHero, c.funTealHeroLip, c.staticWhite),
      UnitColor.mint: (c.funMint, c.funMintLip, c.funTealHero),
      UnitColor.lavender: (c.funLavender, c.funLavenderLip, c.funTealHero),
      UnitColor.lime: (c.funLime, c.funLimeLip, c.funTealHero),
    };

    for (final MapEntry(key: color, value: (face, lip, fg))
        in expected.entries) {
      testWidgets('${color.name}: lip card + foreground (${mode.name})', (
        tester,
      ) async {
        await pumpThemed(tester, header(color), mode: mode);
        final outer =
            tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(
                            of: find.byType(UnitHeader),
                            matching: find.byType(DecoratedBox),
                          )
                          .first,
                    )
                    .decoration
                as ShapeDecoration;
        expect(outer.color, lip);
        expect(textColor(tester, 'UNIT 1'), fg);
        expect(textColor(tester, 'Greetings & etiquette'), fg);
        expect(
          textColor(tester, '4 of 12 signs learned'),
          fg.withValues(alpha: IsharaSizes.subtitleOpacity),
        );
        expect(
          tester.widget<Icon>(find.byIcon(IsharaIcons.bookOpen)).color,
          fg,
        );
        expect(
          find.descendant(
            of: find.byType(UnitHeader),
            matching: find.byWidgetPredicate(
              (w) =>
                  w is DecoratedBox &&
                  (w.decoration as ShapeDecoration).color == face,
            ),
          ),
          findsWidgets,
        );
      });
    }
  }

  testWidgets('guide button: semantics + tap', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpThemed(tester, header(UnitColor.teal, onGuide: () => taps++));
    expect(
      find.bySemanticsLabel(
        'Unit 1: Greetings & etiquette, 4 of 12 signs learned',
      ),
      findsOneWidget,
    );
    expect(
      tester.getSemantics(find.byKey(const ValueKey('unit-guide'))),
      matchesSemantics(label: 'Guidebook', isButton: true, hasTapAction: true),
    );
    await tester.tap(find.text('GUIDEBOOK'));
    await tester.pumpAndSettle();
    expect(taps, 1);
    handle.dispose();
  });

  testWidgets('banner is 104 tall and the guide 97×64, as in Figma', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      SizedBox(
        // Wide enough that the Ahem test font doesn't wrap the subtitle.
        width: 600,
        child: UnitHeader(
          unit: 1,
          title: 'Hi',
          learned: 4,
          total: 12,
          onGuide: () {},
        ),
      ),
    );
    expect(tester.getSize(find.byType(UnitHeader)).height, 104);
    final guide = tester.getSize(find.byKey(const ValueKey('unit-guide')));
    expect(guide.height, 64);
    // 2px border + 10 padding each side of the label.
    expect(
      guide.width - tester.getSize(find.text('GUIDEBOOK')).width,
      2 * (IsharaSizes.guidePaddingX + IsharaSizes.selectedBorder),
    );
  });
}
