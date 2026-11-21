import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/app.dart';
import 'package:ishara_app/core/router/app_router.dart';
import 'package:ishara_app/features/auth/presentation/providers/fake_session_provider.dart';
import 'package:material_ui/material_ui.dart';

/// Boots the real app (router + shell) on a phone-sized view with the given
/// fake session. Returns the container so tests can flip the session.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  bool loggedIn = false,
  bool onboardingDone = false,
  String? location,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);

  final container = ProviderContainer();
  addTearDown(container.dispose);
  container.read(fakeSessionProvider.notifier)
    ..setLoggedIn(loggedIn)
    ..setOnboardingDone(onboardingDone);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const IsharaApp()),
  );
  if (location != null) {
    container.read(appRouterProvider).go(location);
  }
  await tester.pumpAndSettle();
  return container;
}

/// The router's current location.
String currentLocation(ProviderContainer container) => container
    .read(appRouterProvider)
    .routerDelegate
    .currentConfiguration
    .uri
    .path;

/// Placeholder heading of frame [frame] (e.g. "13 · Dictionary").
Finder frameTitle(String frame, String name) => find.text('$frame · $name');
