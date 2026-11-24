import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/api_config.dart';
import '../services/api/mock_api_settings.dart';
import '../services/connectivity/connectivity_service.dart';

part 'is_online.g.dart';

/// Whether the API is reachable now, updated as the network changes and
/// re-checked while offline. With the mock API it also re-checks whenever the
/// debug simulation changes, so the `/gallery` Offline toggle applies at once.
/// Invalidate it to re-check (app resume).
///
/// Widgets watch this provider; only it touches [ConnectivityService].
@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) {
  if (ApiConfig.useMockApi) ref.watch(mockApiSettingsProvider);
  return ref.watch(connectivityServiceProvider).watchOnline();
}
