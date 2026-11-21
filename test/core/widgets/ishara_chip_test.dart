import 'dart:ui' show Tristate;

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

  for (final mode in themeModes) {
    final c = tokensFor(mode);
    testWidgets('filter chip: 32dp, selected is accent (${mode.name})', (
      tester,
    ) async {
      var taps = 0;
      await pumpThemed(
        tester,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IsharaChip.filter(label: 'All', selected: true, onTap: () {}),
            IsharaChip.filter(
              label: 'Greetings',
              selected: false,
              onTap: () => taps++,
            ),
          ],
        ),
        mode: mode,
      );
      Finder pill(String label) => find.ancestor(
        of: find.text(label),
        matching: find.byType(AnimatedContainer),
      );
      Color? fill(String label) =>
          (tester.widget<AnimatedContainer>(pill(label)).decoration!
                  as BoxDecoration)
              .color;
      expect(fill('All'), c.accentSubtle);
      expect(textColor(tester, 'All'), c.accentText);
      expect(fill('Greetings'), c.bgSurfaceMuted);
      expect(textColor(tester, 'Greetings'), c.textSecondary);
      expect(tester.getSize(pill('All')).height, IsharaSizes.filterChipHeight);
      expect(
        tester.getSize(find.byType(IsharaChip).first).height,
        greaterThanOrEqualTo(IsharaSizes.minTouch),
      );
      await tester.tap(find.text('Greetings'));
      expect(taps, 1);
    });
  }

  testWidgets('filter chip exposes selected button semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpThemed(
      tester,
      IsharaChip.filter(label: 'All', selected: true, onTap: () {}),
    );
    final data = tester
        .getSemantics(find.byType(IsharaChip))
        .getSemanticsData();
    expect(data.flagsCollection.isSelected, Tristate.isTrue);
    expect(data.flagsCollection.isButton, isTrue);
    handle.dispose();
  });
}
