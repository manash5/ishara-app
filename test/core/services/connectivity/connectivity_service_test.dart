import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/api_endpoints.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';
import 'package:ishara_app/core/services/connectivity/connectivity_service.dart';
import 'package:ishara_app/core/services/connectivity/health_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/mock_api.dart';

import 'package:ishara_app/core/connectivity/is_online.dart';

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
      HealthRemoteDataSource(
        ApiClient(
          tokenStorage: storage,
          adapter: adapter,
          retryDelays: const [Duration.zero],
          enableLogging: false,
        ),
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

  test('a server that answers with an error is still reachable', () async {
    links([ConnectivityResult.mobile]);
    healthy = false;
    expect(await service.isOnline(), isTrue);
  });

  test('a link with no route to the API counts as offline', () async {
    links([ConnectivityResult.wifi]);
    adapter.handler = (o) =>
        throw DioException.connectionError(requestOptions: o, reason: 'x');
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

  Future<void> settle([int ms = 20]) =>
      Future<void>.delayed(Duration(milliseconds: ms));

  /// Waits (real time, up to 5 s) until [done] holds; the expectation after
  /// it reports a failure.
  Future<void> until(bool Function() done) async {
    for (var i = 0; i < 100 && !done(); i++) {
      await settle(50);
    }
  }

  test('watchOnline: now, on each link change, distinct', () async {
    final changes = StreamController<List<ConnectivityResult>>();
    links([ConnectivityResult.wifi]);
    when(() => connectivity.onConnectivityChanged)
        .thenAnswer((_) => changes.stream);
    final seen = <bool>[];
    final sub = service.watchOnline().listen(seen.add);
    await settle();

    changes.add([ConnectivityResult.mobile]);
    await settle();
    changes.add([ConnectivityResult.none]);
    await settle();

    expect(seen, [true, false]);
    await sub.cancel();
  });

  test('watchOnline re-checks while offline and notices the API coming '
      'back, then stops polling', () async {
    final changes = StreamController<List<ConnectivityResult>>();
    links([ConnectivityResult.wifi]);
    when(() => connectivity.onConnectivityChanged)
        .thenAnswer((_) => changes.stream);
    var reachable = false;
    adapter.handler = (o) => reachable
        ? envelope({'status': 'ok'})
        : throw DioException.connectionError(requestOptions: o, reason: 'x');

    final seen = <bool>[];
    final sub = service
        .watchOnline(pollWhileOffline: const Duration(milliseconds: 40))
        .listen(seen.add);
    await settle();
    expect(seen, [false]);

    await settle(60);
    expect(seen, [false], reason: 'still unreachable');
    expect(adapter.requests.length, greaterThan(1), reason: 'it re-checked');

    reachable = true;
    await settle(80);
    expect(seen, [false, true]);
    final probes = adapter.requests.length;

    await settle(120);
    expect(adapter.requests.length, probes, reason: 'online: no polling');
    await sub.cancel();
  });

  test('isOnlineProvider re-checks when the gallery toggles Offline', () async {
    // Broadcast, like the plugin's: the provider listens again on rebuild.
    final changes = StreamController<List<ConnectivityResult>>.broadcast();
    links([ConnectivityResult.wifi]);
    when(() => connectivity.onConnectivityChanged)
        .thenAnswer((_) => changes.stream);
    late final ProviderContainer container;
    container = ProviderContainer(
      overrides: [
        connectivityServiceProvider.overrideWith(
          (ref) => ConnectivityService(
            connectivity,
            HealthRemoteDataSource(
              mockApiClient(
                simulation: () => container.read(mockApiSettingsProvider),
              ),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final seen = <bool?>[];
    container.listen(
      isOnlineProvider,
      (_, next) => seen.add(next.value),
      fireImmediately: true,
    );
    await until(() => seen.lastOrNull == true);
    expect(seen.last, isTrue);

    container
        .read(mockApiSettingsProvider.notifier)
        .simulate(MockApiSimulation.offline);
    // The provider rebuilds and re-probes through the mock API.
    await until(() => seen.lastOrNull == false);
    expect(seen.last, isFalse);

    container
        .read(mockApiSettingsProvider.notifier)
        .simulate(MockApiSimulation.none);
    await until(() => seen.lastOrNull == true);
    expect(seen.last, isTrue);
  });
}
