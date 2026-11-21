import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/auth_link.dart';

/// Figma `body` gap between copy and CTAs, and its bottom padding (7:42).
// TODO(token-gap): 28 has no spacing token.
const double _welcomeBodyGap = 28;

/// Figma bottom padding 28 minus the 14 the "I already have an account"
/// link gains from its 48dp touch target (text is 20 tall).
const double _welcomeBottomInset =
    _welcomeBodyGap - (IsharaSizes.minTouch - IsharaSpacing.s5) / 2;

/// Figma "02 Welcome" (7:33): full-screen HeroBackdrop, headline, subtitle,
/// "Get started" TextLinkCTA and a secondary log-in link.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: c.funTealHero,
        body: HeroBackdrop(
          layout: HeroBackdropLayout.welcome,
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      IsharaSpacing.screenMargin,
                      IsharaSpacing.s0,
                      IsharaSpacing.screenMargin,
                      _welcomeBottomInset,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Figma copy is 340 wide: one extra margin on the end.
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: IsharaSpacing.screenMargin,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                header: true,
                                child: Text(
                                  'Learn Nepali Sign Language, one sign at a '
                                  'time',
                                  style: s.displaySmall.copyWith(
                                    color: c.staticWhite,
                                  ),
                                ),
                              ),
                              const SizedBox(height: IsharaSpacing.s3),
                              Text(
                                'Short daily lessons with a camera coach.',
                                style: s.bodyMedium.copyWith(
                                  color: c.staticWhite.withValues(
                                    alpha: authHeroMutedOpacity,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: _welcomeBodyGap),
                        TextLinkCTA(
                          label: 'Get started',
                          onPressed: () =>
                              const SignUpRoute().push<void>(context),
                        ),
                        // Figma gap 14 is supplied by the link's touch target.
                        AuthLink(
                          label: 'I already have an account',
                          tone: AuthLinkTone.hero,
                          onPressed: () =>
                              const LogInRoute().push<void>(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
