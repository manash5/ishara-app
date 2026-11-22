import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/router/app_router.dart';
import 'core/theme/theme.dart';
import 'core/services/connectivity/connectivity_service.dart';
import 'core/sync/sync_controller.dart';
import 'features/lesson/presentation/providers/lesson_sync_listener.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

/// Root widget: Ishara light/dark themes (the learner's saved choice,
/// system by default), go_router, and the offline lesson queue flushed on
/// reconnect and on app resume (data-layer rule).
class IsharaApp extends ConsumerStatefulWidget {
  const IsharaApp({super.key});

  @override
  ConsumerState<IsharaApp> createState() => _IsharaAppState();
}

class _IsharaAppState extends ConsumerState<IsharaApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () {
        // Re-check the connection (the plugin may have missed a change)
        // and send anything queued while the app was away.
        ref.invalidate(isOnlineProvider);
        ref.read(syncControllerProvider.notifier).flush();
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keeps syncing alive: the queue flushes whenever the app comes online,
    // and synced lessons refresh the learner's stats.
    ref.listen(syncControllerProvider, (_, _) {});
    ref.listen(lessonSyncListenerProvider, (_, _) {});
    return MaterialApp.router(
      title: 'Ishara',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
