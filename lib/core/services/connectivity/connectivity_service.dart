import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../error/app_exception.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

part 'connectivity_service.g.dart';

/// Online = a network link **and** the API answering `GET /health`. A Wi-Fi
/// link with no internet (or a down server) counts as offline.
class ConnectivityService {
  ConnectivityService(this._connectivity, this._api);

  final Connectivity _connectivity;
  final ApiClient _api;

  Future<bool> isOnline() async =>
      _reachable(await _connectivity.checkConnectivity());

  /// Emits whenever being online changes.
  Stream<bool> get onlineChanges =>
      _connectivity.onConnectivityChanged.asyncMap(_reachable).distinct();

  Future<bool> _reachable(List<ConnectivityResult> links) async {
    if (links.every((l) => l == ConnectivityResult.none)) return false;
    try {
      // One quick probe: no retries with back-off.
      await _api.get(
        ApiEndpoints.health,
        options: Options()..disableRetry = true,
      );
      return true;
    } on AppException {
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) =>
    ConnectivityService(Connectivity(), ref.watch(apiClientProvider));

/// Whether the API is reachable now, updated as the network changes.
@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) async* {
  final service = ref.watch(connectivityServiceProvider);
  yield await service.isOnline();
  yield* service.onlineChanges;
}
