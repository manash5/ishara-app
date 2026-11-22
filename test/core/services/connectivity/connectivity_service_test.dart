import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/api_endpoints.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';
import 'package:ishara_app/core/services/connectivity/connectivity_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_http_adapter.dart';

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  late _MockConnectivity connectivity;
  late FakeHttpAdapter adapter;
  late TokenStorage storage;
  late ConnectivityService service;
  var healthy = true;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage();
    connectivity = _MockConnectivity();
    healthy = true;
    adapter = FakeHttpAdapter(
      (_) => healthy ? envelope({'status': 'ok'}) : envelope(null, status: 503),
    );
    service = ConnectivityService(
      connectivity,
      ApiClient(
        tokenStorage: storage,
        adapter: adapter,
        retryDelays: const [Duration.zero],
        enableLogging: false,
      ),
    );
  });
  tearDown(() => storage.dispose());

  void links(List<ConnectivityResult> value) =>
      when(() => connectivity.checkConnectivity())
          .thenAnswer((_) async => value);

  test('online with a link and a healthy API', () async {
    links([ConnectivityResult.wifi]);
    expect(await service.isOnline(), isTrue);
    expect(adapter.to(ApiEndpoints.health), hasLength(1));
  });

  test('offline with no link, without probing the API', () async {
    links([ConnectivityResult.none]);
    expect(await service.isOnline(), isFalse);
    expect(adapter.requests, isEmpty);
  });

  test('a link whose health check fails counts as offline', () async {
    links([ConnectivityResult.mobile]);
    healthy = false;
    expect(await service.isOnline(), isFalse);
  });

  test('the probe is not retried', () async {
    links([ConnectivityResult.wifi]);
    adapter.handler = (o) => throw DioException.connectionError(
      requestOptions: o,
      reason: 'no route',
    );
    expect(await service.isOnline(), isFalse);
    expect(adapter.requests, hasLength(1));
  });

  test('onlineChanges re-checks on each link change, distinct', () async {
    final changes = StreamController<List<ConnectivityResult>>();
    when(() => connectivity.onConnectivityChanged)
        .thenAnswer((_) => changes.stream);
    final seen = <bool>[];
    final sub = service.onlineChanges.listen(seen.add);

    changes.add([ConnectivityResult.wifi]);
    changes.add([ConnectivityResult.mobile]);
    changes.add([ConnectivityResult.none]);
    await changes.close();
    await sub.asFuture<void>();

    expect(seen, [true, false]);
  });
}
