import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('title + action with 48dp target (${mode.name})', (
      tester,
    ) async {
      var taps = 0;
      await pumpThemed(
        tester,
        SectionHeader(
          title: 'This week',
          actionLabel: 'See all',
          onAction: () => taps++,
        ),
        mode: mode,
      );
      expect(textColor(tester, 'This week'), c.textPrimary);
      expect(textColor(tester, 'See all'), c.accentText);
      expect(
        renderedStyle(tester, find.text('This week'))?.fontSize,
        IsharaTextStyles.standard.titleMedium.fontSize,
      );
      final target = tester.getSize(find.bySemanticsLabel('See all'));
      expect(target.height, greaterThanOrEqualTo(IsharaSizes.minTouch));
      await tester.tap(find.text('See all'));
      expect(taps, 1);
    });

    testWidgets('no action when showAction is off (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        const SectionHeader(title: 'This week'),
        mode: mode,
      );
      expect(find.text('See all'), findsNothing);
      final data = tester
          .getSemantics(find.text('This week'))
          .getSemanticsData();
      expect(data.flagsCollection.isHeader, isTrue);
      handle.dispose();
    });
  }
}
