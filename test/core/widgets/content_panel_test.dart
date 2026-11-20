import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('surface, sheet top corners, padding and gap (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const ContentPanel(
          children: [
            SectionHeader(title: 'This week'),
            SizedBox(key: Key('slot'), height: 40),
          ],
        ),
        mode: mode,
      );
      final box = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(ContentPanel),
              matching: find.byType(Container),
            )
            .first,
      );
      final deco = box.decoration! as BoxDecoration;
      expect(deco.color, c.bgSurface);
      expect(deco.borderRadius, IsharaRadius.sheetTop);
      expect(box.padding, const EdgeInsets.all(IsharaSpacing.screenMargin));

      final headerBottom = tester.getBottomLeft(find.byType(SectionHeader)).dy;
      final slotTop = tester.getTopLeft(find.byKey(const Key('slot'))).dy;
      expect(slotTop - headerBottom, IsharaSpacing.s4);
    });
  }
}
