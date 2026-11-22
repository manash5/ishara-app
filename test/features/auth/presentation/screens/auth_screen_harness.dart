import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:material_ui/material_ui.dart';

import '../../auth_test_utils.dart';

export '../../auth_test_utils.dart' show learnStub;

void _phoneView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
}

Widget _media(
  BuildContext context,
  Widget? child, {
  required bool disableAnimations,
  required double textScale,
}) => MediaQuery(
  data: MediaQuery.of(context).copyWith(
    disableAnimations: disableAnimations,
    textScaler: TextScaler.linear(textScale),
  ),
  child: child!,
);

/// Pumps [screen] alone (no router) on a phone-sized view in [mode].
/// Returns the provider container so tests can read/override state.
Future<ProviderContainer> pumpAuthScreen(
  WidgetTester tester,
  Widget screen, {
  ThemeMode mode = ThemeMode.light,
  List<Override> overrides = const [],
  double textScale = 1,
}) async {
  _phoneView(tester);
  final container = ProviderContainer(
    overrides: [
      ...AuthTestEnv(session: SessionState.signedOut).overrides,
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        builder: (context, child) => _media(
          context,
          child,
          disableAnimations: false,
          textScale: textScale,
        ),
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

/// Pumps a minimal GoRouter app: `/splash` shows [splash], `/learn` shows
/// [learnStub]. Does not settle, so tests can step through the animation.
/// [session] defaults to a restored (ready) signed-out session.
Future<ProviderContainer> pumpSplashRouter(
  WidgetTester tester,
  Widget splash, {
  ThemeMode mode = ThemeMode.light,
  bool disableAnimations = false,
  SessionState session = SessionState.signedOut,
}) async {
  _phoneView(tester);
  final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => splash),
      GoRoute(
        path: '/learn',
        builder: (_, _) => const Scaffold(body: Text(learnStub)),
      ),
    ],
  );
  addTearDown(router.dispose);
  final container = ProviderContainer(
    overrides: AuthTestEnv(session: session).overrides,
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        routerConfig: router,
        builder: (context, child) => _media(
          context,
          child,
          disableAnimations: disableAnimations,
          textScale: 1,
        ),
      ),
    ),
  );
  return container;
}
