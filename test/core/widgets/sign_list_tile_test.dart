import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('tokens, status chip, tap and semantics (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await pumpThemed(
        tester,
        SignListTile(
          title: 'Namaste',
          subtitle: 'Greetings',
          statusLabel: 'Learned',
          onTap: () => taps++,
        ),
        mode: mode,
      );
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(SignListTile),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, c.bgSurfaceMuted);
      expect(material.borderRadius, IsharaRadius.brLg);
      expect(
        tester.getSize(find.byType(SignListTile)).height,
        greaterThanOrEqualTo(IsharaSizes.listTileHeight),
      );
      expect(textColor(tester, 'Namaste'), c.textPrimary);
      expect(textColor(tester, 'Greetings'), c.textSecondary);
      expect(
        tester.widget<IsharaChip>(find.byType(IsharaChip)).tone,
        IsharaChipTone.success,
      );
      expect(
        tester.widget<Icon>(find.byIcon(IsharaIcons.hand)).color,
        c.textSecondary,
      );
      expect(
        tester.widget<Icon>(find.byIcon(IsharaIcons.chevronRight)).color,
        c.textTertiary,
      );

      expect(
        tester.getSemantics(find.byType(SignListTile)),
        matchesSemantics(
          label: 'Namaste, Greetings, Learned',
          isButton: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.byType(SignListTile));
      await tester.pumpAndSettle();
      expect(taps, 1);
      handle.dispose();
    });

    testWidgets('showStatus off hides the chip (${mode.name})', (tester) async {
      await pumpThemed(
        tester,
        SignListTile(title: 'Hello', subtitle: 'Greetings', onTap: () {}),
        mode: mode,
      );
      expect(find.byType(IsharaChip), findsNothing);
    });
  }
}
