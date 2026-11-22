import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'content_panel.dart';
import 'danu_mascot.dart';
import 'hero_backdrop.dart';
import 'ishara_button.dart';

/// Shared layout of the lesson results (Figma 26 Lesson complete, 27
/// Streak): a [HeroBackdrop] header with [hero], overlapped by a
/// [ContentPanel] whose Continue button sits at the bottom, plus one short
/// confetti burst (motion.md "playful": results only).
class ResultsScaffold extends StatelessWidget {
  const ResultsScaffold({
    super.key,
    required this.hero,
    required this.heroPadding,
    required this.children,
    required this.onContinue,
    this.backdrop = HeroBackdropLayout.header,
    this.danu,
  });

  /// Hero content under the status bar.
  final Widget hero;

  /// Figma `heroContent` padding (the bottom includes the panel overlap).
  final EdgeInsets heroPadding;

  /// ContentPanel children above the Continue button.
  final List<Widget> children;
  final VoidCallback onContinue;
  final HeroBackdropLayout backdrop;

  /// Optional Danu at the right edge where hero meets panel, overlapping the
  /// panel's top (26). Painted above both.
  final Widget? danu;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // White status bar icons over the teal hero in both themes.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: c.bgSurface,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HeroBackdrop(
                        layout: backdrop,
                        child: SafeArea(
                          bottom: false,
                          child: Padding(padding: heroPadding, child: hero),
                        ),
                      ),
                      Expanded(
                        // Teal behind the panel's rounded top corners, so
                        // they read as the hero continuing underneath.
                        child: ColoredBox(
                          color: c.funTealHero,
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            children: [
                              ContentPanel(
                                padding: const EdgeInsets.fromLTRB(
                                  IsharaSpacing.s6,
                                  IsharaSpacing.s6,
                                  IsharaSpacing.s6,
                                  IsharaSpacing.s4,
                                ),
                                children: [
                                  ...children,
                                  const Spacer(),
                                  SafeArea(
                                    top: false,
                                    child: IsharaButton(
                                      label: 'Continue',
                                      onPressed: onContinue,
                                    ),
                                  ),
                                ],
                              ),
                              if (danu != null)
                                Positioned(
                                  right: IsharaSpacing.screenMargin,
                                  top: -IsharaSizes.resultMascotOverlap,
                                  child: danu!,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned.fill(child: ConfettiBurst()),
          ],
        ),
      ),
    );
  }
}

/// Danu on the results hero (26, 27): pops in just after the badge/flame,
/// then waves on a loop with the same layered animation as on the Learn
/// roadmap. Reduced motion shows the still wave pose.
///
/// Place Danu on the left of the hero: the [HeroBackdrop] header shapes
/// all sit on the right.
class ResultsDanu extends StatelessWidget {
  const ResultsDanu({super.key, this.size = IsharaSizes.resultMascot});

  final double size;

  @override
  Widget build(BuildContext context) => PopIn(
    delay: IsharaMotion.fast,
    child: DanuMascot(pose: DanuPose.wave, size: size, animated: true),
  );
}
