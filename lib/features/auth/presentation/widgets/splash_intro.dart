import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Choreography of the Splash intro (motion.md has no splash spec; these are
/// the feature-level values, built on [IsharaMotion] tokens).
abstract final class SplashMotion {
  /// Whole intro: 2 s (4 × `celebrate`) — the backdrop drifts in while the
  /// Danphe mark assembles itself, then the wordmark and tagline appear.
  // TODO(token-gap): IsharaMotion has no splash/intro duration token.
  static final Duration total = IsharaMotion.celebrate * 4;

  /// One orbit of the backdrop circles' ambient float.
  static final Duration driftPeriod = IsharaMotion.celebrate * 8;

  /// With reduced motion the static splash is held this long, then continues.
  static const Duration reducedHold = IsharaMotion.celebrate;

  /// Phases as fractions of [total]. HeroBackdrop's per-shape intro
  /// (staggered fade + grow + drift) and IsharaLogo's Danphe intro (tile,
  /// body, head, crest, ripple, wordmark) each run over their interval.
  static const Interval backdropIntro = Interval(0, 0.65);
  static const Interval logoIntro = Interval(0.15, 0.9);
  static const Interval taglineFade = Interval(
    0.75,
    1,
    curve: IsharaMotion.enter,
  );
}

/// Figma "01 Splash" lockup (54:4331): Logo/Lockup at 1.6×.
const double splashLockupScale = 1.6;

/// Figma `body` padding-bottom under the lockup (node 7:19).
// TODO(token-gap): 132 has no spacing token.
const double splashLockupBottomInset = 132;

/// The Splash content, driven by [progress] (0 → 1): the HeroBackdrop shapes
/// drift and grow into place one after another while the Danphe mark builds
/// itself (tile, body, head, sprouting crest, lime ripple), the wordmark
/// slides out, then the tagline fades in. At progress 1 it matches Figma 7:10.
class SplashIntro extends StatelessWidget {
  const SplashIntro({super.key, required this.progress, this.drift});

  final Animation<double> progress;

  /// Looping ambient float for the backdrop circles (null = still).
  final Animation<double>? drift;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final backdropIntro = CurvedAnimation(
      parent: progress,
      curve: SplashMotion.backdropIntro,
    );
    final logoIntro = CurvedAnimation(
      parent: progress,
      curve: SplashMotion.logoIntro,
    );
    final taglineOpacity = CurvedAnimation(
      parent: progress,
      curve: SplashMotion.taglineFade,
    );

    return ColoredBox(
      color: c.funTealHero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          HeroBackdrop(
            layout: HeroBackdropLayout.welcome,
            intro: backdropIntro,
            drift: drift,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      IsharaSpacing.screenMargin,
                      IsharaSpacing.s0,
                      IsharaSpacing.screenMargin,
                      splashLockupBottomInset,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: IsharaLogo(
                        variant: IsharaLogoVariant.lockup,
                        scale: splashLockupScale,
                        onHero: true,
                        intro: logoIntro,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: IsharaSpacing.screenMargin,
                    vertical: IsharaSpacing.s3,
                  ),
                  child: FadeTransition(
                    opacity: taglineOpacity,
                    child: Text(
                      'Learn Nepali Sign Language',
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodySmall.copyWith(
                        color: c.funLime,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
