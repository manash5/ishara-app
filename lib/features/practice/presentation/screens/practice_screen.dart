import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../recognition/presentation/providers/camera_session_state.dart';
import '../../../recognition/presentation/providers/fingerspell_session.dart';

/// Free fingerspelling practice (the bottom bar's centre camera action).
/// No Figma frame yet: built from existing widgets in the camera (dark)
/// theme. On-device only ("Works offline"), no XP. The recognised letter is
/// practice feedback, never "verified".
class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  static const title = 'Practice';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Camera screens always use the dark theme (ui.md).
    return Theme(
      data: AppTheme.dark,
      child: const AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _PracticeBody(),
      ),
    );
  }
}

class _PracticeBody extends ConsumerWidget {
  const _PracticeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final s = context.textStyles;
    // Free practice: no target word.
    final session = ref.watch(fingerspellSessionProvider(''));
    final shown = session.candidate ?? session.accepted;
    return Scaffold(
      backgroundColor: c.bgCamera,
      appBar: IsharaTopAppBar(
        title: PracticeScreen.title,
        leading: IsharaAppBarLeading.close,
        onLeading: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                IsharaSpacing.screenMargin,
                IsharaSpacing.s2,
                IsharaSpacing.screenMargin,
                IsharaSpacing.s3,
              ),
              child: Text(
                'Fingerspell any letter and hold it still.',
                style: s.bodyMedium.copyWith(color: c.textSecondary),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: IsharaRadius.brSheet,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraFeed(
                      landmarks: session.landmarks,
                      overlay: session.landmarks == null
                          ? HandOverlayStyle.ghost
                          : HandOverlayStyle.live,
                    ),
                    Positioned(
                      left: IsharaSpacing.s4,
                      top: IsharaSpacing.s4,
                      child: session.hand == HandStatus.noHand
                          ? const IsharaChip(
                              label: 'Show your hand in the frame',
                              tone: IsharaChipTone.neutral,
                              icon: IsharaIcons.hand,
                            )
                          : const IsharaChip(
                              label: 'Hand detected',
                              tone: IsharaChipTone.success,
                              icon: IsharaIcons.check,
                            ),
                    ),
                    if (kDebugMode)
                      Positioned(
                        right: IsharaSpacing.s4,
                        top: IsharaSpacing.s4,
                        child: IsharaChip(
                          key: const Key('recognition-debug-stats'),
                          label:
                              '${session.stats.fps.round()} fps · '
                              '${session.stats.latencyMs.toStringAsFixed(1)}'
                              ' ms',
                          tone: IsharaChipTone.neutral,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(IsharaSpacing.screenMargin),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      liveRegion: true,
                      label: shown == null
                          ? 'No letter yet'
                          : 'Practice feedback: $shown',
                      excludeSemantics: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Practice feedback',
                            style: s.labelMedium.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                          Text(
                            shown ?? '—',
                            key: const Key('practice-letter'),
                            style: s.displaySmall.copyWith(
                              color: session.accepted == shown && shown != null
                                  ? c.successText
                                  : c.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const IsharaChip(
                    label: 'Works offline',
                    tone: IsharaChipTone.neutral,
                    icon: IsharaIcons.wifiOff,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
