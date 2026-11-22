import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/dev/gallery/sections/widget_sections.dart';
import 'package:ishara_app/dev/gallery/widgets_gallery_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ishara_app/core/router/app_router.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
  });

  Future<void> pumpGallery(WidgetTester tester, Brightness b) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: WidgetsGalleryScreen(initialBrightness: b)),
      ),
    );
  }

  Brightness brightness(WidgetTester tester) =>
      Theme.of(tester.element(find.byKey(const Key('widgets-gallery-list'))))
          .brightness;

  for (final b in Brightness.values) {
    testWidgets('every widget section builds without errors in ${b.name}', (
      tester,
    ) async {
      await pumpGallery(tester, b);
      final list = find.byKey(const Key('widgets-gallery-list'));
      for (final title in [
        'IsharaButton',
        'IsharaBottomBar',
        'PathNode',
        'CameraFeed',
        'FeedbackSheet',
        'SettingsTile',
        'DanuMascot',
        'IsharaLogo',
      ]) {
        await tester.scrollUntilVisible(
          find.text(title),
          400,
          scrollable: find
              .descendant(of: list, matching: find.byType(Scrollable))
              .first,
        );
        await tester.pump(IsharaMotion.celebrate);
        expect(find.text(title), findsOneWidget);
        expect(tester.takeException(), isNull, reason: title);
      }
    });
  }

  test('a section per exported widget plus each added variant', () {
    // 35 base widgets (SettingsGroup shares the SettingsTile variant section)
    // + 13 variant sections + 5 widgets consolidated from features.
    expect(widgetSections, hasLength(53));
  });

  testWidgets('toggle switches light ↔ dark', (tester) async {
    await pumpGallery(tester, Brightness.light);
    expect(brightness(tester), Brightness.light);
    await tester.tap(find.byKey(const Key('widgets-gallery-theme-toggle')));
    await tester.pump();
    expect(brightness(tester), Brightness.dark);
    await tester.tap(find.byKey(const Key('widgets-gallery-theme-toggle')));
    await tester.pump();
    expect(brightness(tester), Brightness.light);
  });

  test('/gallery route is registered in debug builds', () {
    expect(
      appRoutes.whereType<GoRoute>().map((r) => r.path),
      contains(const GalleryRoute().location),
    );
  });
}
