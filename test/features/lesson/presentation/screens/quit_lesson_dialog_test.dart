import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/screens/quit_lesson_dialog.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets(
      'Figma 29 copy, surface-raised and danger Quit (${mode.name})',
      (tester) async {
        var quit = 0;
        var keep = 0;
        await pumpThemed(
          tester,
          QuitLessonDialog(onQuit: () => quit++, onKeepLearning: () => keep++),
          mode: mode,
        );
        expect(find.text('Quit this lesson?'), findsOneWidget);
        expect(textColor(tester, 'Quit this lesson?'), c.textPrimary);
        expect(
          find.text(
            'Your progress in this lesson won’t be saved. Your streak is safe.',
          ),
          findsOneWidget,
        );
        expect(
          tester.widget<Dialog>(find.byType(Dialog)).backgroundColor,
          c.bgSurfaceRaised,
        );
        expect(textColor(tester, 'Quit'), c.dangerText);
        expect(textColor(tester, 'Keep learning'), c.accentText);
        // Right-aligned, Quit before Keep learning (Figma order). A Wrap so
        // the actions stack at large text sizes instead of overflowing.
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.alignment, WrapAlignment.end);
        expect(wrap.children.map((w) => (w as IsharaButton).label), [
          'Quit',
          'Keep learning',
        ]);
        for (final label in ['Quit', 'Keep learning']) {
          expect(
            tester.getSize(find.widgetWithText(IsharaButton, label)).height,
            greaterThanOrEqualTo(IsharaSizes.minTouch),
          );
        }
        await tester.tap(find.text('Quit'));
        await tester.tap(find.text('Keep learning'));
        expect((quit, keep), (1, 1));
      },
    );
  }
}
