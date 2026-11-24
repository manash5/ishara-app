import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/api_endpoints.dart';
import 'package:ishara_app/core/services/api/api_response.dart';
import 'package:ishara_app/core/services/api/mock_api_adapter.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';

import '../../../helpers/mock_api.dart';

void main() {
  late TokenStorage storage;
  late ApiClient client;
  var simulation = MockApiSimulation.none;
  final now = DateTime.utc(2026, 11, 22, 9);

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage();
    simulation = MockApiSimulation.none;
    client = ApiClient(
      tokenStorage: storage,
      adapter: MockApiAdapter(
        simulation: () => simulation,
        bundle: FixtureBundle(),
        latency: Duration.zero,
        clock: () => now,
      ),
      retryDelays: const [],
      enableLogging: false,
    );
  });
  tearDown(() => storage.dispose());

  Map<String, dynamic> data(Object? body) =>
      ApiEnvelope.fromJson(body, (d) => d! as Map<String, dynamic>).requireData;

  Future<AuthTokens> logIn([String email = 'learner@ishara.test']) async {
    final response = await client.post(
      ApiEndpoints.userLogin,
      data: {'email': email, 'password': 'any password'},
    );
    final tokens = ApiEnvelope.fromJson(
      response.data,
      AuthTokens.fromJson,
    ).requireData;
    await storage.save(tokens);
    return tokens;
  }

  group('auth', () {
    test('any email and password logs in with fresh tokens', () async {
      final tokens = await logIn('someone@example.com');
      expect(tokens.accessToken, 'mock-access-1');
      expect(tokens.refreshToken, 'mock-refresh-1');
      expect(tokens.expiresAt, now.add(MockApiAdapter.sessionLength));
    });

    test('the session carries the profile', () async {
      final response = await client.post(
        ApiEndpoints.userLogin,
        data: {'email': 'a@b.c', 'password': 'x'},
      );
      expect(data(response.data)['user']['id'], FixtureIds.user);
    });

    test('reserved values return the error cases', () async {
      Future<void> fails<E>(String path, Map<String, Object> body) =>
          expectLater(client.post(path, data: body), throwsA(isA<E>()));

      await fails<UnauthorizedException>(ApiEndpoints.userLogin, {
        'email': MockApiAdapter.wrongEmail,
        'password': 'whatever1',
      });
      await fails<ConflictException>(ApiEndpoints.userRegister, {
        'email': MockApiAdapter.takenEmail,
        'password': 'long enough',
        'displayName': 'A',
      });
      await fails<ValidationException>(ApiEndpoints.userRegister, {
        'email': 'new@ishara.test',
        'password': 'short',
        'displayName': 'A',
      });
      await fails<UnauthorizedException>(ApiEndpoints.googleLogin, {
        'idToken': MockApiAdapter.invalidGoogleToken,
      });
      await fails<UnauthorizedException>(ApiEndpoints.refreshToken, {
        'refreshToken': MockApiAdapter.expiredRefreshToken,
      });
      await fails<ValidationException>(ApiEndpoints.resetPassword, {
        'email': 'a@b.c',
        'code': MockApiAdapter.invalidResetCode,
        'newPassword': 'long enough',
      });
    });

    test('register succeeds with 201 and a new learner', () async {
      final response = await client.post(
        ApiEndpoints.userRegister,
        data: {
          'email': 'new@ishara.test',
          'password': 'long enough',
          'displayName': 'New',
        },
      );
      expect(response.statusCode, 201);
      expect(data(response.data)['user']['onboardingDone'], isFalse);
    });

    test('validation errors carry the server message', () async {
      await expectLater(
        client.post(
          ApiEndpoints.resetPassword,
          data: {'code': MockApiAdapter.invalidResetCode},
        ),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.message,
            'message',
            'That code is invalid or has expired.',
          ),
        ),
      );
    });
  });

  group('data routes', () {
    test('lessons/:id echoes the id', () async {
      final response = await client.get(ApiEndpoints.getLessonById('abc'));
      expect(data(response.data)['lesson']['id'], 'abc');
    });

    test('complete is idempotent on clientEventId', () async {
      Future<Map<String, dynamic>> complete(String event) async {
        final response = await client.post(
          ApiEndpoints.completeLesson(FixtureIds.currentLesson),
          data: {'clientEventId': event, 'mistakes': 0, 'durationSeconds': 60},
        );
        return response.data as Map<String, dynamic>;
      }

      final first = await complete('e-1');
      final replay = await complete('e-1');
      final other = await complete('e-2');
      expect(first['message'], 'Lesson completed');
      expect(replay['message'], 'Already recorded');
      expect(replay['data'], first['data']);
      expect(other['message'], 'Lesson completed');
      expect((first['data'] as Map)['lessonId'], FixtureIds.currentLesson);
    });

    test('progress sync answers each event, duplicates included', () async {
      await client.post(
        ApiEndpoints.completeLesson(FixtureIds.currentLesson),
        data: {'clientEventId': 'e-1'},
      );
      final response = await client.post(
        ApiEndpoints.syncProgress,
        data: {
          'events': [
            {'clientEventId': 'e-1', 'lessonId': FixtureIds.currentLesson},
            {'clientEventId': 'e-2', 'lessonId': FixtureIds.firstLesson},
          ],
        },
      );
      final results = data(response.data)['results'] as List;
      expect(results.map((r) => (r as Map)['status']), [
        'duplicate',
        'applied',
      ]);
      expect((results[1] as Map)['result']['lessonId'], FixtureIds.firstLesson);
    });

    test('signs list picks the fixture from the query', () async {
      Future<int> count(Map<String, Object> query) async {
        final response = await client.get(
          ApiEndpoints.getSigns,
          queryParameters: query,
        );
        return ((response.data as Map)['data'] as List).length;
      }

      expect(await count({}), 8);
      expect(await count({'page': 2}), 4);
      expect(await count({'category': 'greetings'}), 3);
      expect(await count({'search': 'thank'}), 1);
    });

    test('sign detail: full for Namaste, built for others, else 404', () async {
      final namaste = data(
        (await client.get(ApiEndpoints.getSignById(FixtureIds.namaste))).data,
      );
      expect(namaste['etiquetteTip'], isNotNull);
      final sorry = data(
        (await client.get(ApiEndpoints.getSignById(FixtureIds.sorry))).data,
      );
      expect(sorry['name'], 'Sorry');
      expect(sorry['etiquetteTip'], isNull);
      await expectLater(
        client.get(ApiEndpoints.getSignById('unknown')),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('the league ends 3d 14h after the request', () async {
      final board = data(
        (await client.get(ApiEndpoints.getWeeklyLeaderboard)).data,
      );
      expect(
        DateTime.parse(board['endsAt'] as String),
        now.add(MockApiAdapter.leagueTimeLeft),
      );
    });

    test('PUT /me echoes the changed fields', () async {
      final response = await client.put(
        ApiEndpoints.getProfile,
        data: {'dailyGoalMinutes': 15, 'dominantHand': 'left'},
      );
      final me = data(response.data);
      expect((me['dailyGoalMinutes'], me['dominantHand']), (15, 'left'));
    });

    test('route params match whole segments only', () async {
      await expectLater(
        client.post(ApiEndpoints.getLessonById('abc')),
        throwsA(isA<NotFoundException>()),
      );
      await expectLater(
        client.get('/lessons/a/b'),
        throwsA(isA<NotFoundException>()),
      );
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
        client.get(ApiEndpoints.getPath),
        throwsA(isA<ServerException>()),
      );
    });

    test('401 once: the interceptor refreshes and the call succeeds', () async {
      await logIn();
      simulation = MockApiSimulation.unauthorized;
      expect((await client.get(ApiEndpoints.getProfile)).statusCode, 200);
      expect((await storage.read())!.accessToken, 'mock-access-2');
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
