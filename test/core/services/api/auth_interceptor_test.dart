import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/api_endpoints.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';

import '../../../helpers/fake_http_adapter.dart';

void main() {
  late TokenStorage storage;
  late FakeHttpAdapter adapter;
  late ApiClient client;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage();
    await storage.save(AuthTokens.fromJson(tokensJson('old')));
    adapter = FakeHttpAdapter((_) => envelope(null));
    client = ApiClient(
      tokenStorage: storage,
      adapter: adapter,
      retryDelays: const [],
      enableLogging: false,
    );
  });
  tearDown(() => storage.dispose());

  String? authHeader(String path) =>
      adapter.to(path).last.headers['Authorization'] as String?;

  test('adds the bearer token to protected requests', () async {
    await client.get(ApiEndpoints.getProfile);
    await client.post(ApiEndpoints.logout);
    expect(authHeader('/me'), 'Bearer old');
    // Logout ends the session, so it needs the token too.
    expect(authHeader('/auth/logout'), 'Bearer old');
  });

  test('skips /health and the public /auth/* paths', () async {
    for (final path in [
      ApiEndpoints.health,
      ApiEndpoints.userLogin,
      ApiEndpoints.userRegister,
      ApiEndpoints.googleLogin,
      ApiEndpoints.forgotPassword,
    ]) {
      await client.post(path);
      expect(authHeader(path), isNull, reason: path);
    }
  });

  test('concurrent 401s share one refresh and all retry with the new '
      'token', () async {
    adapter.handler = (options) async {
      if (options.path == ApiEndpoints.refreshToken) {
        expect(options.data, {'refreshToken': 'refresh-old'});
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return envelope(tokensJson('new'));
      }
      return options.headers['Authorization'] == 'Bearer new'
          ? envelope({'ok': true})
          : envelope(null, status: 401);
    };

    final responses = await Future.wait([
      client.get(ApiEndpoints.getProfile),
      client.get(ApiEndpoints.getPath),
      client.get(ApiEndpoints.getSigns),
    ]);

    expect(responses.map((r) => r.statusCode), [200, 200, 200]);
    expect(adapter.to(ApiEndpoints.refreshToken), hasLength(1));
    // The refresh itself carries no bearer token.
    expect(authHeader(ApiEndpoints.refreshToken), isNull);
    expect((await storage.read())!.accessToken, 'new');
  });

  test('a request is retried only once', () async {
    adapter.handler = (options) => options.path == ApiEndpoints.refreshToken
        ? envelope(tokensJson('new'))
        : envelope(null, status: 401);
    await expectLater(
      client.get(ApiEndpoints.getProfile),
      throwsA(isA<UnauthorizedException>()),
    );
    expect(adapter.to('/me'), hasLength(2));
    expect(adapter.to(ApiEndpoints.refreshToken), hasLength(1));
  });

  test('a failed refresh clears the tokens and signs out', () async {
    adapter.handler = (_) => envelope(null, status: 401);
    final events = <SessionStatus>[];
    final sub = storage.sessionChanges.listen(events.add);

    await expectLater(
      client.get(ApiEndpoints.getProfile),
      throwsA(isA<UnauthorizedException>()),
    );
    await Future<void>.delayed(Duration.zero);

    expect(await storage.read(), isNull);
    expect(events, [SessionStatus.signedOut]);
    await sub.cancel();
  });

  test('a 401 on a public path never refreshes', () async {
    adapter.handler = (_) => envelope(null, status: 401);
    await expectLater(
      client.post(ApiEndpoints.userLogin),
      throwsA(isA<UnauthorizedException>()),
    );
    expect(adapter.to(ApiEndpoints.refreshToken), isEmpty);
    expect(await storage.read(), isNotNull);
  });
}
