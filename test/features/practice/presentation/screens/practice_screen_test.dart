import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/practice/presentation/screens/practice_screen.dart';
import 'package:ishara_app/features/recognition/data/recognition_providers.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  Future<void> pumpPractice(
    WidgetTester tester,
    FakeCameraScenario camera,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...mockApiOverrides(),
          fakeCameraSettingsProvider.overrideWithBuild((ref, _) => camera),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const PracticeScreen()),
      ),
    );
    await pumpApi(tester);
  }

  String letterShown(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const Key('practice-letter'))).data!;

  testWidgets('uses the camera (dark) theme and works offline', (tester) async {
    await pumpPractice(tester, FakeCameraScenario.noHand);
    final context = tester.element(find.byType(CameraFeed));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(context.colors, IsharaColors.dark);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Works offline'), findsOneWidget);
    expect(find.byTooltip('Close'), findsOneWidget);
  });

  testWidgets('no hand: the ghost pose, a friendly chip and no letter', (
    tester,
  ) async {
    await pumpPractice(tester, FakeCameraScenario.noHand);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Show your hand in the frame'), findsOneWidget);
    final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
    expect(feed.overlay, HandOverlayStyle.ghost);
    expect(letterShown(tester), '—');
    expect(find.bySemanticsLabel('No letter yet'), findsOneWidget);
  });

  testWidgets('a held letter shows as practice feedback', (tester) async {
    await pumpPractice(tester, FakeCameraScenario.correct);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Hand detected'), findsOneWidget);
    final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
    expect(feed.landmarks, hasLength(21));
    expect(feed.overlay, HandOverlayStyle.live);
    expect(letterShown(tester), isNot('—'));
    expect(
      find.bySemanticsLabel(RegExp('^Practice feedback: ')),
      findsOneWidget,
    );
  });
}
