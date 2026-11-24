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

  // Regression: on a phone the status bar sits inside the app bar's
  // area; a fixed 64dp box squeezed the toolbar, cutting off the title and
  // hiding the back button.
  testWidgets('below a status bar: back button and title fully visible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    tester.view.padding = const FakeViewPadding(top: 63); // 24dp
    addTearDown(tester.view.reset);
    var taps = 0;
    await pumpBar(
      tester,
      IsharaTopAppBar(title: 'Settings', onLeading: () => taps++),
      ThemeMode.light,
    );
    const statusBar = 24.0;
    final bar = tester.getRect(find.byType(IsharaTopAppBar));
    expect(bar.height, statusBar + IsharaSizes.appBarHeight);
    final title = tester.getRect(find.text('Settings'));
    final back = tester.getRect(find.byTooltip('Back'));
    for (final r in [title, back]) {
      expect(r.top, greaterThanOrEqualTo(statusBar));
      expect(r.bottom, lessThanOrEqualTo(bar.bottom));
    }
    // Centred in the 64dp toolbar under the status bar.
    expect(
      title.center.dy,
      closeTo(statusBar + IsharaSizes.appBarHeight / 2, 1),
    );
    await tester.tap(find.byTooltip('Back'));
    expect(taps, 1);
  });

  testWidgets('title is optional (back button only)', (tester) async {
    await pumpThemed(
      tester,
      SizedBox(
        height: IsharaSizes.appBarHeight,
        child: IsharaTopAppBar(onLeading: () {}),
      ),
    );
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(IsharaTopAppBar),
        matching: find.byType(Text),
      ),
      findsNothing,
    );
  });
}
