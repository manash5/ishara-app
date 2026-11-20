import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('theme resolves Figma track/thumb tokens (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        IsharaSwitch(value: true, onChanged: (_) {}, semanticLabel: 'Sound'),
        mode: mode,
      );
      final theme = Theme.of(tester.element(find.byType(Switch))).switchTheme;
      const on = {WidgetState.selected};
      const off = <WidgetState>{};
      expect(theme.trackColor!.resolve(on), c.accentDefault);
      expect(theme.thumbColor!.resolve(on), c.textOnAccent);
      expect(theme.trackColor!.resolve(off), c.bgSurfaceMuted);
      expect(theme.thumbColor!.resolve(off), c.textSecondary);
      expect(theme.trackOutlineColor!.resolve(off), c.borderStrong);
      expect(theme.trackOutlineWidth!.resolve(off), 2);
    });

    testWidgets('toggles and exposes a labelled toggle (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var value = false;
      await pumpThemed(
        tester,
        StatefulBuilder(
          builder: (context, setState) => IsharaSwitch(
            value: value,
            onChanged: (v) => setState(() => value = v),
            semanticLabel: 'Daily reminder',
          ),
        ),
        mode: mode,
      );
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(value, isTrue);
      final data = tester.getSemantics(find.byType(Switch)).getSemanticsData();
      expect(data.label, contains('Daily reminder'));
      handle.dispose();
    });
  }
}
