import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('lavender card, gold flame, stat value (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        const StatCard(value: '12', caption: 'Day streak'),
        mode: mode,
      );
      final deco =
          tester
                  .widget<Container>(
                    find.descendant(
                      of: find.byType(StatCard),
                      matching: find.byType(Container),
                    ),
                  )
                  .decoration!
              as BoxDecoration;
      expect(deco.color, c.funLavenderSubtle);
      expect(deco.borderRadius, IsharaRadius.brLg);
      final icon = tester.widget<IsharaFilledIcon>(
        find.byType(IsharaFilledIcon),
      );
      expect(icon.kind, IsharaFilledIconKind.flame);
      expect(icon.color, c.funGold);
      expect(textColor(tester, '12'), c.textPrimary);
      expect(
        renderedStyle(tester, find.text('12'))?.fontSize,
        IsharaTextStyles.standard.stat.fontSize,
      );
      expect(textColor(tester, 'Day streak'), c.textSecondary);
      expect(find.bySemanticsLabel('12 Day streak'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('accepts a Lucide icon (${mode.name})', (tester) async {
      await pumpThemed(
        tester,
        const StatCard(
          value: '340',
          caption: 'Total XP',
          icon: IsharaIcons.zap,
        ),
        mode: mode,
      );
      expect(find.byIcon(IsharaIcons.zap), findsOneWidget);
      expect(find.byType(IsharaFilledIcon), findsNothing);
    });
  }
}
