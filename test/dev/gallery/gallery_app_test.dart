import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/dev/gallery/gallery_app.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
  });

  Brightness brightness(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(ListView))).brightness;

  for (final mode in themeModes) {
    testWidgets('builds in ${mode.name} with every token shown', (
      tester,
    ) async {
      await tester.pumpWidget(GalleryApp(initialMode: mode));
      expect(tester.takeException(), isNull);
      expect(
        brightness(tester),
        mode == ThemeMode.dark ? Brightness.dark : Brightness.light,
      );

      // Scroll through the whole gallery so every section builds.
      final list = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.text('fun/teal-hero'),
        300,
        scrollable: list,
      );
      expect(find.text('fun/teal-hero'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('elevation/2'),
        300,
        scrollable: list,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('theme toggle cycles light → dark', (tester) async {
    await tester.pumpWidget(const GalleryApp());
    expect(brightness(tester), Brightness.light);
    await tester.tap(find.byKey(const Key('gallery-theme-toggle')));
    await tester.pumpAndSettle();
    expect(brightness(tester), Brightness.dark);
  });

  testWidgets('selection, wrong and correct demos run', (tester) async {
    await tester.pumpWidget(const GalleryApp());

    final option = find.byKey(const Key('gallery-option-1'));
    await tester.ensureVisible(option);
    await tester.pumpAndSettle();
    await tester.tap(option);
    await tester.pumpAndSettle();
    final selected = tester.widget<SelectionHighlight>(
      find.descendant(
        of: find.byKey(const Key('gallery-option-1')),
        matching: find.byType(SelectionHighlight),
      ),
    );
    expect(selected.selected, isTrue);

    final wrong = find.byKey(const Key('gallery-wrong'));
    await tester.ensureVisible(wrong);
    await tester.pumpAndSettle();
    await tester.tap(wrong);
    await tester.pumpAndSettle();
    expect(find.text('Not quite'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    await tester.tap(find.byKey(const Key('gallery-sheet-continue')));
    await tester.pumpAndSettle();
    expect(find.text('Not quite'), findsNothing);

    await tester.tap(find.byKey(const Key('gallery-correct')));
    await tester.pumpAndSettle();
    expect(find.text('Nice work'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduce-motion switch toggles', (tester) async {
    await tester.pumpWidget(const GalleryApp());
    final toggle = find.byKey(const Key('gallery-reduce-motion'));
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(toggle).value, isTrue);
  });
}
