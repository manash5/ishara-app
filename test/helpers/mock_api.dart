import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/mock_api_adapter.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';
import 'package:ishara_app/features/recognition/data/recognition_providers.dart';
import 'package:ishara_app/features/recognition/data/sign_template_source.dart';

import 'test_hive.dart';

import 'package:ishara_app/core/connectivity/is_online.dart';

/// Reads `assets/mock_api/` straight from disk, so fixture loads finish
/// within a widget test's frame instead of going through the asset channel.
class FixtureBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(File(key).readAsBytesSync());

  @override
  Future<String> loadString(String key, {bool cache = true}) async =>
      File(key).readAsStringSync();
}

/// The decoded fixture `assets/mock_api/<name>.json`.
Map<String, dynamic> fixture(String name) => jsonDecode(
  File('${MockApiAdapter.fixtureRoot}$name.json').readAsStringSync(),
) as Map<String, dynamic>;

/// The `data` of fixture [name].
T fixtureData<T>(String name) => fixture(name)['data'] as T;

/// A zero-latency mock API client over the fixtures.
ApiClient mockApiClient({
  MockApiSimulation Function()? simulation,
  TokenStorage? tokens,
  Duration latency = Duration.zero,
}) {
  if (tokens == null) FlutterSecureStorage.setMockInitialValues({});
  return ApiClient(
    tokenStorage: tokens ?? TokenStorage(),
    adapter: MockApiAdapter(
      simulation: simulation,
      bundle: FixtureBundle(),
      latency: latency,
    ),
    retryDelays: const [],
    enableLogging: false,
  );
}

/// Overrides that make screens load the fixtures instantly, with the
/// in-memory test Hive. [simulation] fakes offline / 404 / 500 (see
/// `MockApiSimulation`).
List<Override> mockApiOverrides({
  MockApiSimulation? simulation,
  Duration latency = Duration.zero,
}) {
  FlutterSecureStorage.setMockInitialValues({});
  return [
    // Shares the app's TokenStorage, so a failed refresh reaches the session.
    apiClientProvider.overrideWith(
      (ref) => mockApiClient(
        simulation: simulation == null ? null : () => simulation,
        latency: latency,
        tokens: ref.watch(tokenStorageProvider),
      ),
    ),
    hiveServiceProvider.overrideWithValue(TestHive.instance),
    // Greeting templates read from disk (instant under fake time).
    signTemplateSourceProvider.overrideWithValue(
      SignTemplateSource(FixtureBundle()),
    ),
    // No connectivity plugin in tests: online unless simulating offline.
    isOnlineProvider.overrideWith(
      (ref) => Stream.value(simulation != MockApiSimulation.offline),
    ),
  ];
}

/// Stable ids from the fixtures.
abstract final class FixtureIds {
  static const user = 'c1f404b1-361e-5a17-9c75-ec33753089dc';
  static const currentLesson = 'bd40c5dd-7e41-5609-bc81-7a678fe0967c';
  static const firstLesson = '140564a7-babd-5c9d-ae0d-5aa411db5041';
  static const namaste = '91a1aaec-304d-5c72-8be7-3404cc351df2';
  static const thankYou = '9010db34-4029-511e-bbed-d00a6b244f75';
  static const sorry = '386bd0e8-8cf0-51ae-8f63-59b5e755b82b';
  static const please = '1b0bf8c5-93aa-5fd0-82a0-882635a496c3';
}

/// Lets mock API requests finish. Dio schedules zero-length timers, which a
/// bare `tester.pump()` never fires.
Future<void> pumpApi(WidgetTester tester) async {
  await tester.pump(Duration.zero);
  await tester.pump();
}
