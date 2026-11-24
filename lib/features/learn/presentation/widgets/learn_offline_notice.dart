import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/connectivity/is_online.dart';

/// Figma "12 Learn – offline": the roadmap stays (cached) and this
/// [IsharaSnackbar] sits above the bottom bar while offline. OK hides it
/// until the next time the connection drops.
class LearnOfflineNotice extends ConsumerStatefulWidget {
  const LearnOfflineNotice({super.key});

  static const message = 'You’re offline. Fingerspelling practice still works.';

  @override
  ConsumerState<LearnOfflineNotice> createState() => _LearnOfflineNoticeState();
}

class _LearnOfflineNoticeState extends ConsumerState<LearnOfflineNotice> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(isOnlineProvider, (_, next) {
      // Back online: show it again on the next drop.
      if (next.value == true && _dismissed) setState(() => _dismissed = false);
    });
    final offline = ref.watch(isOnlineProvider).value == false;
    final show = offline && !_dismissed;
    return AnimatedSwitcher(
      duration: IsharaMotion.duration(context, IsharaMotion.fast),
      child: show
          ? IsharaSnackbar(
              key: const Key('learn-offline-notice'),
              message: LearnOfflineNotice.message,
              icon: IsharaIcons.wifiOff,
              actionLabel: 'OK',
              onAction: () => setState(() => _dismissed = true),
            )
          : const SizedBox.shrink(),
    );
  }
}
