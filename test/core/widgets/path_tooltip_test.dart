import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('inverse bubble with arrow (${mode.name})', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(tester, const PathTooltip(text: 'Start'), mode: mode);
      final bubble = tester.widget<Container>(
        find.descendant(
          of: find.byType(PathTooltip),
          matching: find.byType(Container),
        ),
      );
      final deco = bubble.decoration! as BoxDecoration;
      expect(deco.color, c.bgInverse);
      expect(deco.borderRadius, IsharaRadius.brMd);
      expect(textColor(tester, 'Start'), c.textInverse);
      final arrow = find.descendant(
        of: find.byType(PathTooltip),
        matching: find.byType(CustomPaint),
      );
      expect(
        tester.getSize(arrow.last),
        const Size(
          IsharaSizes.tooltipArrowWidth,
          IsharaSizes.tooltipArrowHeight,
        ),
      );
      expect(arrow.last, paints..path(color: c.bgInverse));
      expect(find.bySemanticsLabel('Start'), findsOneWidget);
      handle.dispose();
    });
  }
}
