import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/onboarding_choices_provider.dart';
import '../providers/onboarding_completion_provider.dart';
import '../widgets/onboarding_bar.dart';
import '../widgets/privacy_point.dart';

/// Figma "08 Camera permission" (9:359): step 3 of 3. A teal
/// [HeroBackdrop] header with a [ContentPanel] explaining camera privacy.
///
/// "Allow camera" does not ask the OS yet; "Not now" skips the setup check
/// and finishes onboarding (`POST /me/onboarding`; camera exercises can be
/// skipped).
class CameraPermissionScreen extends ConsumerWidget {
  const CameraPermissionScreen({super.key});

  // Figma `heroContent` 55:3717 / `badge` 55:3718 (badge shared with Ranks).
  static const double _badgeSize = IsharaSizes.heroBadge;
  static const double _badgeIcon = IsharaSizes.heroBadgeIcon;
  static const double _heroBottomPadding = 44;
  static const double _heroSubtitleOpacity = IsharaSizes.heroCaptionOpacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final s = context.textStyles;
    final navigator = Navigator.of(context);
    final saving = ref.watch(onboardingCompletionProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: c.bgSurface,
        body: Stack(
          children: [
            const Positioned.fill(child: HeroBackdrop()),
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SafeArea(
                        bottom: false,
                        child: OnboardingBar(
                          step: 3,
                          onHero: true,
                          onBack: navigator.canPop() ? navigator.pop : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          IsharaSpacing.screenMargin,
                          IsharaSpacing.s4,
                          IsharaSpacing.screenMargin,
                          _heroBottomPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ExcludeSemantics(
                              child: Container(
                                width: _badgeSize,
                                height: _badgeSize,
                                decoration: BoxDecoration(
                                  color: c.funLime,
                                  borderRadius: IsharaRadius.brLg,
                                ),
                                child: Icon(
                                  IsharaIcons.camera,
                                  size: _badgeIcon,
                                  color: c.funTealHero,
                                ),
                              ),
                            ),
                            const SizedBox(height: IsharaSpacing.s5),
                            Semantics(
                              header: true,
                              child: Text(
                                'Let Ishara see your hands',
                                style: s.headlineSmall.copyWith(
                                  color: c.staticWhite,
                                ),
                              ),
                            ),
                            const SizedBox(height: IsharaSpacing.s2),
                            Text(
                              'The camera checks your signs and gives '
                              'instant feedback.',
                              style: s.bodyMedium.copyWith(
                                color: c.staticWhite.withValues(
                                  alpha: _heroSubtitleOpacity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ContentPanel(
                          children: [
                            const SectionHeader(title: 'Your privacy'),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                PrivacyPoint(
                                  icon: IsharaIcons.shieldCheck,
                                  text:
                                      'Processed on your phone — video never '
                                      'leaves it',
                                ),
                                SizedBox(height: IsharaSpacing.listGap),
                                PrivacyPoint(
                                  icon: IsharaIcons.hand,
                                  text: 'Only 21 points on each hand are read',
                                ),
                                SizedBox(height: IsharaSpacing.listGap),
                                PrivacyPoint(
                                  icon: IsharaIcons.cameraOff,
                                  text: 'Skip camera exercises anytime',
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                IsharaButton(
                                  label: 'Allow camera',
                                  onPressed: () {
                                    // TODO(onboarding): request the OS camera
                                    // permission once the plugin lands.
                                    ref
                                        .read(
                                          onboardingChoicesProvider.notifier,
                                        )
                                        .setCameraAllowed(true);
                                    const CameraCheckRoute().push<void>(
                                      context,
                                    );
                                  },
                                ),
                                const SizedBox(height: IsharaSpacing.s2),
                                IsharaButton(
                                  label: saving ? 'Saving…' : 'Not now',
                                  variant: IsharaButtonVariant.text,
                                  onPressed: saving
                                      ? null
                                      : () async {
                                          ref
                                              .read(
                                                onboardingChoicesProvider
                                                    .notifier,
                                              )
                                              .setCameraAllowed(false);
                                          final failure = await ref
                                              .read(
                                                onboardingCompletionProvider
                                                    .notifier,
                                              )
                                              .complete();
                                          if (failure != null &&
                                              context.mounted) {
                                            IsharaSnackbar.show(
                                              context,
                                              message: failure.message,
                                            );
                                          }
                                        },
                                ),
                                SizedBox(
                                  height: MediaQuery.paddingOf(context).bottom,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
