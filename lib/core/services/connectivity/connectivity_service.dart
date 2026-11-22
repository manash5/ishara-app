import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../error/app_exception.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../api/mock_api_settings.dart';

part 'connectivity_service.g.dart';

/// Online = a network link **and** the API answering `GET /health`. Any
/// HTTP response counts (a server error is still a reachable server); no
/// connection or a timeout counts as offline, as does a Wi-Fi link with no
/// internet.
class ConnectivityService {
  ConnectivityService(this._connectivity, this._api);

  final Connectivity _connectivity;
  final ApiClient _api;

  Future<bool> isOnline() async =>
      _reachable(await _connectivity.checkConnectivity());

  /// How often to re-check while offline, so a server that comes back (or
  /// a link the plugin didn't report) is noticed.
  static const offlinePollInterval = Duration(seconds: 20);

  /// Whether the API is reachable: now, on every network change, and every
  /// [pollWhileOffline] while offline. Emits only changes.
  Stream<bool> watchOnline({Duration pollWhileOffline = offlinePollInterval}) {
    late final StreamController<bool> controller;
    StreamSubscription<List<ConnectivityResult>>? links;
    Timer? poll;
    bool? last;

    Future<void> probe([List<ConnectivityResult>? changed]) async {
      poll?.cancel();
      final online = await _reachable(
        changed ?? await _connectivity.checkConnectivity(),
      );
      if (controller.isClosed) return;
      if (!online) poll = Timer(pollWhileOffline, probe);
      if (online != last) {
        last = online;
        controller.add(online);
      }
    }

    controller = StreamController<bool>(
      onListen: () {
        unawaited(probe());
        links = _connectivity.onConnectivityChanged.listen(
          (changed) => unawaited(probe(changed)),
        );
      },
      onCancel: () {
        poll?.cancel();
        // Not awaited: with no listener left, close() never completes.
        unawaited(links?.cancel());
        unawaited(controller.close());
      },
    );
    return controller.stream;
  }

  Future<bool> _reachable(List<ConnectivityResult> links) async {
    if (links.every((l) => l == ConnectivityResult.none)) return false;
    try {
      // One quick probe: no retries with back-off.
      await _api.get(
        ApiEndpoints.health,
        options: Options()..disableRetry = true,
      );
      return true;
    } on NetworkException {
      return false;
    } on AppException {
      // The server answered (even with an error): it is reachable.
      return true;
    }
  }
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) =>
    ConnectivityService(Connectivity(), ref.watch(apiClientProvider));

/// Whether the API is reachable now, updated as the network changes and
/// re-checked while offline. With the mock API it also re-checks whenever the
/// debug simulation changes, so the `/gallery` Offline toggle applies at once.
/// Invalidate it to re-check (app resume).
@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) {
  if (ApiEndpoints.useMockApi) ref.watch(mockApiSettingsProvider);
  return ref.watch(connectivityServiceProvider).watchOnline();
}
