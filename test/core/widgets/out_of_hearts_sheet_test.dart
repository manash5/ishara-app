import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/game_rules.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('Figma 28 panel: empty hearts, copy, two actions '
        '(${mode.name})', (tester) async {
      var practise = 0;
      var end = 0;
      await pumpThemed(
        tester,
        OutOfHeartsPanel(
          onPractise: () => practise++,
          onEndLesson: () => end++,
        ),
        mode: mode,
      );
      expect(
        find.byIcon(IsharaIcons.heart),
        findsNWidgets(GameRules.maxHearts),
      );
      expect(find.text('You’re out of hearts'), findsOneWidget);
      expect(textColor(tester, 'You’re out of hearts'), c.textPrimary);
      expect(
        find.text(
          'Hearts refill every 4 hours — or practise a review lesson to earn '
          'one back. Camera mistakes never cost hearts.',
        ),
        findsOneWidget,
      );
      final practiseButton = tester.widget<IsharaButton>(
        find.widgetWithText(IsharaButton, 'Practise to earn a heart'),
      );
      expect(practiseButton.variant, IsharaButtonVariant.filled);
      final endButton = tester.widget<IsharaButton>(
        find.widgetWithText(IsharaButton, 'End lesson'),
      );
      expect(endButton.variant, IsharaButtonVariant.outlined);
      await tester.tap(find.text('Practise to earn a heart'));
      await tester.tap(find.text('End lesson'));
      expect((practise, end), (1, 1));
    });
  }

  testWidgets('the sheet cannot be dragged or tapped away', (tester) async {
    await pumpThemed(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showOutOfHeartsSheet(
            context,
            onPractise: () {},
            onEndLesson: () {},
          ),
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(OutOfHeartsPanel), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.byType(OutOfHeartsPanel), findsOneWidget);
  });
}
