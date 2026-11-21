import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('app uses the Ishara themes and follows the system mode', (
    tester,
  ) async {
    await pumpApp(tester);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.theme, same(AppTheme.light));
    expect(app.darkTheme, same(AppTheme.dark));
    expect(app.themeMode, ThemeMode.system);
    expect(app.routerConfig, isNotNull);
  });
}
