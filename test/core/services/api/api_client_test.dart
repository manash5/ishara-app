import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/api_endpoints.dart';
import 'package:ishara_app/core/services/api/api_response.dart';
import 'package:ishara_app/core/services/api/mock_api_adapter.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';

import '../../../helpers/fake_http_adapter.dart';

void main() {
  late TokenStorage storage;
  late FakeHttpAdapter adapter;
  late ApiClient client;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage();
    adapter = FakeHttpAdapter((_) => envelope({'name': 'Namaste'}));
    client = ApiClient(
      tokenStorage: storage,
      adapter: adapter,
      retryDelays: const [Duration.zero, Duration.zero, Duration.zero],
      enableLogging: false,
    );
  });
  tearDown(() => storage.dispose());

  test('uses the configured base URL, timeouts and JSON headers', () {
    final options = client.dio.options;
    expect(options.baseUrl, ApiEndpoints.baseUrl);
    expect(options.connectTimeout, const Duration(seconds: 30));
    expect(options.receiveTimeout, const Duration(seconds: 30));
    expect(options.headers['Accept'], 'application/json');
  });

  test('get/post/put/delete send the method, query and body', () async {
    await client.get('/signs', queryParameters: {'q': 'hello'});
    await client.post('/me/onboarding', data: {'dailyGoalXp': 20});
    await client.put('/me', data: {'displayName': 'A'});
    await client.delete('/me');
    expect(adapter.requests.map((r) => r.method), [
      'GET',
      'POST',
      'PUT',
      'DELETE',
    ]);
    expect(adapter.requests.first.queryParameters, {'q': 'hello'});
    expect(adapter.requests[1].data, {'dailyGoalXp': 20});
  });

  test('the body parses as an envelope', () async {
    final response = await client.get('/signs/1');
    final envelope = ApiEnvelope.fromJson(
      response.data,
      (d) => (d! as Map<String, dynamic>)['name'],
    );
    expect(envelope.requireData, 'Namaste');
  });

  test('errors surface as AppException, never DioException', () async {
    adapter.handler = (_) => envelope(null, status: 404);
    await expectLater(
      client.get('/signs/x'),
      throwsA(isA<NotFoundException>()),
    );
    adapter.handler = (_) =>
        envelope(null, status: 422, message: 'Pick a goal');
    await expectLater(
      client.post('/me/onboarding'),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.message,
          'message',
          'Pick a goal',
        ),
      ),
    );
  });

  test('retries a timeout 3 times', () async {
    adapter.handler = (options) => throw DioException.connectionTimeout(
      timeout: const Duration(seconds: 30),
      requestOptions: options,
    );
    await expectLater(
      client.get(ApiEndpoints.health),
      throwsA(isA<NetworkException>()),
    );
    expect(adapter.requests, hasLength(4));
  });

  test('never retries a 500', () async {
    adapter.handler = (_) => envelope(null, status: 500);
    await expectLater(
      client.get(ApiEndpoints.health),
      throwsA(isA<ServerException>()),
    );
    expect(adapter.requests, hasLength(1));
  });

  test('the provider attaches the mock adapter when USE_MOCK_API is on', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final dio = container.read(apiClientProvider).dio;
    expect(ApiEndpoints.useMockApi, isTrue);
    expect(dio.httpClientAdapter, isA<MockApiAdapter>());
    expect(dio.options.baseUrl, ApiEndpoints.mockBaseUrl);
  });
}
