import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/api_endpoints.dart';
import 'package:ishara_app/core/services/api/api_response.dart';
import 'package:ishara_app/core/services/api/mock_api_adapter.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TokenStorage storage;
  late ApiClient client;
  var simulation = MockApiSimulation.none;

  ApiClient clientFor(MockApiAdapter adapter) => ApiClient(
    tokenStorage: storage,
    adapter: adapter,
    retryDelays: const [],
    enableLogging: false,
  );

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage();
    simulation = MockApiSimulation.none;
    client = clientFor(
      MockApiAdapter(
        simulation: () => simulation,
        latency: Duration.zero,
        clock: () => DateTime.utc(2026, 11, 22, 9),
      ),
    );
  });
  tearDown(() => storage.dispose());

  Future<AuthTokens> logIn() async {
    final response = await client.post(
      ApiEndpoints.userLogin,
      data: {'email': 'learner@example.com', 'password': 'secret'},
    );
    final tokens = ApiEnvelope.fromJson(
      response.data,
      AuthTokens.fromJson,
    ).requireData;
    await storage.save(tokens);
    return tokens;
  }

  group('routing', () {
    test('login returns a fake session with fresh tokens', () async {
      final tokens = await logIn();
      expect(tokens.accessToken, 'mock-access-1');
      expect(tokens.refreshToken, 'mock-refresh-1');
      expect(
        tokens.expiresAt,
        DateTime.utc(2026, 11, 22, 9).add(MockApiAdapter.sessionLength),
      );
    });

    test('serves GET /me, /health and onboarding from fixtures', () async {
      await logIn();
      final me = ApiEnvelope.fromJson(
        (await client.get(ApiEndpoints.getProfile)).data,
        (d) => d! as Map<String, dynamic>,
      );
      expect(me.success, isTrue);
      expect(me.requireData['onboardingDone'], isTrue);
      expect((await client.get(ApiEndpoints.health)).statusCode, 200);
      expect(
        (await client.post(ApiEndpoints.submitOnboarding)).statusCode,
        200,
      );
    });

    test('every default route has a fixture that is an envelope', () async {
      final adapter = MockApiAdapter(latency: Duration.zero);
      for (final route in MockApiAdapter.defaultRoutes) {
        final body = await adapter.fetch(
          RequestOptions(
            method: route.method,
            baseUrl: ApiEndpoints.mockBaseUrl,
            path: route.path,
          ),
          null,
          null,
        );
        expect(body.statusCode, 200, reason: route.path);
      }
    });

    test(':id segments match any id', () async {
      final idClient = clientFor(
        MockApiAdapter(
          latency: Duration.zero,
          routes: const [
            MockRoute('GET', '/lessons/:id', 'health.json'),
            MockRoute('POST', '/lessons/:id/complete', 'auth/ok.json'),
          ],
        ),
      );
      expect(
        (await idClient.get(ApiEndpoints.getLessonById('abc-123'))).statusCode,
        200,
      );
      expect(
        (await idClient.post(ApiEndpoints.completeLesson('abc'))).statusCode,
        200,
      );
      // Method and segment count both have to match.
      await expectLater(
        idClient.post(ApiEndpoints.getLessonById('abc')),
        throwsA(isA<NotFoundException>()),
      );
      await expectLater(
        idClient.get('/lessons/a/b'),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('an unmatched route is a 404 envelope', () async {
      await expectLater(client.get('/nope'), throwsA(isA<NotFoundException>()));
    });
  });

  group('simulations', () {
    test('offline fails every request as a network error', () async {
      simulation = MockApiSimulation.offline;
      await expectLater(
        client.get(ApiEndpoints.health),
        throwsA(isA<NetworkException>()),
      );
      await expectLater(logIn(), throwsA(isA<NetworkException>()));
    });

    test('404 and 500 hit data endpoints but leave auth working', () async {
      simulation = MockApiSimulation.notFound;
      await logIn();
      await expectLater(
        client.get(ApiEndpoints.getProfile),
        throwsA(isA<NotFoundException>()),
      );
      simulation = MockApiSimulation.serverError;
      await expectLater(
        client.get(ApiEndpoints.getProfile),
        throwsA(isA<ServerException>()),
      );
    });

    test('401 once: the interceptor refreshes and the call succeeds', () async {
      await logIn();
      simulation = MockApiSimulation.unauthorized;
      expect((await client.get(ApiEndpoints.getProfile)).statusCode, 200);
      expect((await storage.read())!.accessToken, 'mock-access-2');
      // Later calls use the refreshed token and pass.
      expect((await client.get(ApiEndpoints.getProfile)).statusCode, 200);
      expect((await storage.read())!.accessToken, 'mock-access-2');
    });

    test('session expired: refresh fails too and the user is signed '
        'out', () async {
      await logIn();
      final events = <SessionStatus>[];
      final sub = storage.sessionChanges.listen(events.add);
      simulation = MockApiSimulation.sessionExpired;

      await expectLater(
        client.get(ApiEndpoints.getProfile),
        throwsA(isA<UnauthorizedException>()),
      );
      await Future<void>.delayed(Duration.zero);
      expect(await storage.read(), isNull);
      expect(events, [SessionStatus.signedOut]);
      await sub.cancel();
    });
  });
}
