import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/session_provider.dart';
import 'app_routes.dart';
import 'redirect.dart';

part 'app_router.g.dart';

/// Every route; `/gallery` only in debug builds.
List<RouteBase> get appRoutes => [
  for (final route in $appRoutes)
    if (kDebugMode ||
        route is! GoRoute ||
        route.path != const GalleryRoute().location)
      route,
];

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Re-run redirects whenever the (fake) session changes.
  final refresh = ValueNotifier<SessionState>(ref.read(sessionProvider));
  ref.listen(sessionProvider, (_, next) => refresh.value = next);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: const SplashRoute().location,
    refreshListenable: refresh,
    redirect: (context, state) =>
        sessionRedirect(ref.read(sessionProvider).flags, state.matchedLocation),
    routes: appRoutes,
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
}
