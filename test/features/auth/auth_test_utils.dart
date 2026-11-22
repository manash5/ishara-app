import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/services/connectivity/connectivity_service.dart';
import 'package:go_router/go_router.dart';
import 'package:ishara_app/core/router/redirect.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/features/auth/data/datasources/google_id_token_source.dart';
import 'package:ishara_app/features/auth/domain/repositories/google_id_token_provider.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/log_in_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/camera_permission_screen.dart';
import 'package:ishara_app/features/onboarding/presentation/screens/camera_setup_check_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/mock_api.dart';
import '../../helpers/test_hive.dart';

/// One token store shared by the API client (its auth interceptor) and the
/// session, the zero-latency mock API (whose [simulation] can change
/// mid-test) and the in-memory test Hive.
class AuthTestEnv {
  AuthTestEnv({this.google = const FakeGoogleIdTokenProvider(), this.session}) {
    FlutterSecureStorage.setMockInitialValues({});
    tokens = TokenStorage();
    api = mockApiClient(tokens: tokens, simulation: () => simulation);
  }

  late final TokenStorage tokens;
  late final ApiClient api;
  MockApiSimulation simulation = MockApiSimulation.none;

  /// What `isOnlineProvider` reports (no connectivity plugin in tests).
  bool online = true;
  final GoogleIdTokenProvider google;

  /// Seeds the session (skips the start-up restore) when set.
  final SessionState? session;

  HiveService get hive => TestHive.instance;

  List<Override> get overrides => [
    apiClientProvider.overrideWithValue(api),
    tokenStorageProvider.overrideWithValue(tokens),
    hiveServiceProvider.overrideWithValue(hive),
    googleIdTokenSourceProvider.overrideWithValue(google),
    isOnlineProvider.overrideWith((ref) => Stream.value(online)),
    if (session case final seeded?)
      sessionProvider.overrideWith(() => Session(initial: seeded)),
  ];

  ProviderContainer container() {
    final container = ProviderContainer(overrides: overrides);
    addTearDown(container.dispose);
    return container;
  }

  /// Stores a session as if the learner had signed in earlier.
  Future<void> storeTokens([String access = 'mock-access-0']) => tokens.save(
    AuthTokens(
      accessToken: access,
      refreshToken: 'mock-refresh',
      expiresAt: DateTime.utc(2030),
    ),
  );
}

/// Lets async work (secure storage, Hive, the mock API) finish in a plain
/// (non-widget) test.
Future<void> settleAsync() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// Text of the stub page each redirect target shows.
const learnStub = 'Learn stub';
const welcomeStub = 'Welcome stub';
const onboardingStub = 'Onboarding stub';

/// The auth and onboarding screens under a GoRouter whose redirect is the
/// app's [sessionRedirect] fed by the real [sessionProvider], with stub pages
/// for Welcome, Daily goal and Learn.
Future<ProviderContainer> pumpAuthFlow(
  WidgetTester tester,
  AuthTestEnv env, {
  required String location,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);

  final container = env.container();
  final refresh = ValueNotifier(container.read(sessionProvider));
  container.listen(sessionProvider, (_, next) => refresh.value = next);
  addTearDown(refresh.dispose);

  Widget stub(String text) => Scaffold(body: Center(child: Text(text)));
  final router = GoRouter(
    initialLocation: location,
    refreshListenable: refresh,
    redirect: (context, state) => sessionRedirect(
      container.read(sessionProvider).flags,
      state.matchedLocation,
    ),
    routes: [
      GoRoute(path: '/welcome', builder: (_, _) => stub(welcomeStub)),
      GoRoute(path: '/sign-up', builder: (_, _) => const SignUpScreen()),
      GoRoute(path: '/log-in', builder: (_, _) => const LogInScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/onboarding/daily-goal',
        builder: (_, _) => stub(onboardingStub),
      ),
      GoRoute(
        path: '/onboarding/camera-permission',
        builder: (_, _) => const CameraPermissionScreen(),
      ),
      GoRoute(
        path: '/onboarding/camera-check',
        builder: (_, _) => const CameraSetupCheckScreen(),
      ),
      GoRoute(path: '/learn', builder: (_, _) => stub(learnStub)),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
      ),
    ),
  );
  await settleFlow(tester);
  return container;
}

/// Lets requests finish and the redirect run.
Future<void> settleFlow(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await pumpApi(tester);
  }
  await tester.pumpAndSettle();
}

/// The current location of the app under [tester].
String routerLocation(WidgetTester tester) =>
    GoRouter.of(tester.element(find.byType(Navigator).first))
        .routerDelegate
        .currentConfiguration
        .uri
        .path;
