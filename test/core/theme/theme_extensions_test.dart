import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    testWidgets('context.colors / textStyles resolve in ${mode.name}', (
      tester,
    ) async {
      late IsharaColors colors;
      late IsharaTextStyles styles;
      await pumpThemed(
        tester,
        Builder(
          builder: (context) {
            colors = context.colors;
            styles = context.textStyles;
            return const SizedBox();
          },
        ),
        mode: mode,
      );
      expect(
        colors,
        same(mode == ThemeMode.dark ? IsharaColors.dark : IsharaColors.light),
      );
      expect(styles.stat.fontSize, 22);
    });
  }
}
