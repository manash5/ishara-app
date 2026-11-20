import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/main.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('app uses the Ishara themes', (tester) async {
    await tester.pumpWidget(const MyApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.theme, same(AppTheme.light));
    expect(app.darkTheme, same(AppTheme.dark));
    expect(app.themeMode, ThemeMode.system);

    // Placeholder counter still works.
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
