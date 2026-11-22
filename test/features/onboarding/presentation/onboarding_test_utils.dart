import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_themed.dart';
import '../../auth/auth_test_utils.dart';

import 'package:ishara_app/features/recognition/data/recognition_providers.dart';

/// Pumps an onboarding [screen] on a phone-sized view (Ahem test font is
/// wide) in [mode], optionally at a larger [textScale]. Returns the container
/// so tests can read the providers.
Future<ProviderContainer> pumpOnboardingScreen(
  WidgetTester tester,
  Widget screen, {
  ThemeMode mode = ThemeMode.light,
  double textScale = 1,
  bool disableAnimations = false,
  FakeCameraScenario camera = FakeCameraScenario.correct,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);

  final container = AuthTestEnv().container();
  container.read(fakeCameraSettingsProvider.notifier).set(camera);
  await pumpThemed(
    tester,
    UncontrolledProviderScope(
      container: container,
      child: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: screen,
        ),
      ),
    ),
    mode: mode,
    disableAnimations: disableAnimations,
  );
  await tester.pumpAndSettle();
  return container;
}
