import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('white label, lime underline, 48dp, tap (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await pumpThemed(
        tester,
        TextLinkCTA(label: 'Get started', onPressed: () => taps++),
        mode: mode,
      );
      expect(textColor(tester, 'Get started'), c.staticWhite);
      final underline = tester.widget<Container>(
        find.descendant(
          of: find.byType(TextLinkCTA),
          matching: find.byType(Container),
        ),
      );
      expect((underline.decoration! as BoxDecoration).color, c.funLime);
      expect(
        tester.getSize(find.byWidget(underline)).height,
        IsharaSizes.underline,
      );
      expect(
        tester.getSize(find.byWidget(underline)).width,
        tester.getSize(find.text('Get started')).width,
      );
      expect(
        tester.getSize(find.byType(TextLinkCTA)).height,
        greaterThanOrEqualTo(IsharaSizes.minTouch),
      );
      expect(
        tester.getSemantics(find.byType(TextLinkCTA)),
        matchesSemantics(
          label: 'Get started',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.byType(TextLinkCTA));
      await tester.pumpAndSettle();
      expect(taps, 1);
      handle.dispose();
    });
  }
}
