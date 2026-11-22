import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/camera_setup_checks_provider.dart';
import '../providers/onboarding_completion_provider.dart';
import '../widgets/framing_guide.dart';
import '../widgets/setup_check_row.dart';

/// Figma "09 Camera setup check" (9:420): the camera preview with a framing
/// guide and a checklist sheet. Finishing onboarding lets the redirect take
/// the learner to /learn.
///
/// "Looks good" sends the onboarding answers (`POST /me/onboarding`).
/// [CameraFeed] still shows its placeholder art and the checklist is fake.
/// Privacy: no frame or landmark is stored, uploaded or logged.
class CameraSetupCheckScreen extends ConsumerWidget {
  const CameraSetupCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final checks = ref.watch(cameraSetupChecksProvider);
    final navigator = Navigator.of(context);
    final saving = ref.watch(onboardingCompletionProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: c.bgCamera,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CameraFeed(
                    semanticLabel: 'Camera preview, placeholder',
                  ),
                  const FramingGuide(),
                  // Figma `overlayBar` (9:520).
                  SafeArea(
                    bottom: false,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: IsharaSpacing.s2,
                          top: IsharaSpacing.s2,
                        ),
                        child: Row(
                          children: [
                            IsharaIconButton(
                              icon: IsharaIcons.close,
                              tooltip: 'Close',
                              variant: IsharaIconButtonVariant.onCamera,
                              onPressed: navigator.canPop()
                                  ? navigator.pop
                                  : null,
                            ),
                            const SizedBox(width: IsharaSpacing.s2),
                            Expanded(
                              child: Semantics(
                                header: true,
                                child: Text(
                                  'Check your setup',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textStyles.titleMedium
                                      .copyWith(color: c.staticWhite),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Figma `checklistSheet` (9:530).
            ContentPanel(
              children: [
                for (final check in checks) SetupCheckRow(check: check),
                IsharaButton(
                  label: saving ? 'Saving…' : 'Looks good',
                  onPressed: saving
                      ? null
                      : () async {
                          final failure = await ref
                              .read(onboardingCompletionProvider.notifier)
                              .complete();
                          if (failure != null && context.mounted) {
                            IsharaSnackbar.show(
                              context,
                              message: failure.message,
                            );
                          }
                        },
                ),
                if (MediaQuery.paddingOf(context).bottom case final b
                    when b > 0)
                  SizedBox(height: b),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
