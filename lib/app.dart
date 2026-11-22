import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/router/app_router.dart';
import 'core/theme/theme.dart';
import 'features/lesson/presentation/providers/progress_sync_provider.dart';
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
      onResume: () => ref.read(progressSyncProvider.notifier).flush(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the sync provider alive: it flushes whenever the app comes online.
    ref.listen(progressSyncProvider, (_, _) {});
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
