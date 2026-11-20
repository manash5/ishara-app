import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);
    final expected = {
      IsharaChipTone.accent: (c.accentSubtle, c.accentText),
      IsharaChipTone.neutral: (c.bgSurfaceMuted, c.textSecondary),
      IsharaChipTone.success: (c.successSubtle, c.successText),
      IsharaChipTone.danger: (c.dangerSubtle, c.dangerText),
    };

    for (final MapEntry(key: tone, value: (bg, fg)) in expected.entries) {
      testWidgets('tone ${tone.name} (${mode.name})', (tester) async {
        await pumpThemed(
          tester,
          IsharaChip(label: 'Learned', tone: tone, icon: IsharaIcons.check),
          mode: mode,
        );
        final box = tester.widget<Container>(
          find.descendant(
            of: find.byType(IsharaChip),
            matching: find.byType(Container),
          ),
        );
        final deco = box.decoration! as BoxDecoration;
        expect(deco.color, bg);
        expect(deco.borderRadius, IsharaRadius.brFull);
        expect(textColor(tester, 'Learned'), fg);
        expect(tester.widget<Icon>(find.byType(Icon)).color, fg);
        expect(
          tester.getSize(find.byType(IsharaChip)).height,
          IsharaSizes.chipHeight,
        );
      });
    }

    testWidgets('semantics label, no icon by default (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(tester, const IsharaChip(label: 'New'), mode: mode);
      expect(find.byType(Icon), findsNothing);
      expect(find.bySemanticsLabel('New'), findsOneWidget);
      handle.dispose();
    });
  }
}
