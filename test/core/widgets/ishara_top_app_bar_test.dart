import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  Future<void> pumpBar(
    WidgetTester tester,
    IsharaTopAppBar bar,
    ThemeMode mode,
  ) => tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      home: Scaffold(appBar: bar),
    ),
  );

  test('preferredSize is 64dp', () {
    const bar = IsharaTopAppBar(title: 'Settings', onLeading: null);
    expect(bar.preferredSize.height, IsharaSizes.appBarHeight);
  });

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    for (final (leading, icon, tooltip) in [
      (IsharaAppBarLeading.back, IsharaIcons.arrowLeft, 'Back'),
      (IsharaAppBarLeading.close, IsharaIcons.close, 'Close'),
    ]) {
      testWidgets('leading ${leading.name} (${mode.name})', (tester) async {
        var taps = 0;
        await pumpBar(
          tester,
          IsharaTopAppBar(
            title: 'Settings',
            leading: leading,
            onLeading: () => taps++,
          ),
          mode,
        );
        expect(find.byIcon(icon), findsOneWidget);
        expect(textColor(tester, 'Settings'), c.textPrimary);
        expect(
          renderedStyle(tester, find.text('Settings'))?.fontSize,
          IsharaTextStyles.standard.titleLarge.fontSize,
        );
        expect(
          tester.getSize(find.byType(AppBar)).height,
          IsharaSizes.appBarHeight,
        );
        await tester.tap(find.byIcon(icon));
        await tester.pumpAndSettle();
        expect(taps, 1);

        final handle = tester.ensureSemantics();
        final data = tester
            .getSemantics(find.byType(IconButton))
            .getSemanticsData();
        expect(data.tooltip, tooltip);
        expect(find.bySemanticsLabel('Settings'), findsOneWidget);
        handle.dispose();
      });
    }

    testWidgets('optional action (${mode.name})', (tester) async {
      var taps = 0;
      await pumpBar(
        tester,
        IsharaTopAppBar(
          title: 'Dictionary',
          onLeading: () {},
          action: IsharaAppBarAction(
            icon: IsharaIcons.search,
            tooltip: 'Search',
            onPressed: () => taps++,
          ),
        ),
        mode,
      );
      await tester.tap(find.byIcon(IsharaIcons.search));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });
  }
}
