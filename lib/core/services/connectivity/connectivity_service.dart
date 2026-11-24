import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../error/app_exception.dart';
import '../api/api_client.dart';
import 'health_remote_data_source.dart';

part 'connectivity_service.g.dart';

/// Online = a network link **and** the API answering `GET /health`. Any
/// HTTP response counts (a server error is still a reachable server); no
/// connection or a timeout counts as offline, as does a Wi-Fi link with no
/// internet.
class ConnectivityService {
  ConnectivityService(this._connectivity, this._health);

  final Connectivity _connectivity;
  final HealthRemoteDataSource _health;

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
      await _health.check();
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
ConnectivityService connectivityService(Ref ref) => ConnectivityService(
  Connectivity(),
  HealthRemoteDataSource(ref.watch(apiClientProvider)),
);
