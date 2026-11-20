import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  const text = 'Which sign means “Thank you”?';

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('surface bubble with lip border and tail (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        const SizedBox(width: 256, child: SpeechBubble(text: text)),
        mode: mode,
      );
      final boxes = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(SpeechBubble),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((b) => (b.decoration as BoxDecoration).color)
          .toList();
      expect(boxes, [c.borderDefault, c.bgSurface]);

      // 2px sides + 4px bottom lip between the border box and the surface.
      final padding = tester
          .widgetList<Padding>(
            find.descendant(
              of: find.byType(SpeechBubble),
              matching: find.byType(Padding),
            ),
          )
          .map((p) => p.padding)
          .toList();
      expect(
        padding,
        contains(
          const EdgeInsets.fromLTRB(
            IsharaSizes.selectedBorder,
            IsharaSizes.selectedBorder,
            IsharaSizes.selectedBorder,
            IsharaSizes.bubbleLip,
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(SpeechBubble),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
      expect(textColor(tester, text), c.textPrimary);
      expect(find.bySemanticsLabel(text), findsOneWidget);
      handle.dispose();
    });
  }
}
