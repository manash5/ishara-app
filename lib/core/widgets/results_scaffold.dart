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
    this.danuRise = IsharaSizes.resultMascotOverlap,
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

  /// How far [danu] rises above the panel's top (the rest overlaps it).
  final double danuRise;

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
                                  top: -danuRise,
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
/// then plays [pose] on a loop (wave: the Learn roadmap animation;
/// celebrate: cheering wings, a hop and twinkling confetti). Reduced
/// motion shows the still pose.
///
/// Pass it as [ResultsScaffold.danu]: it sits at the hero's right edge,
/// drawn over the panel's top.
class ResultsDanu extends StatelessWidget {
  const ResultsDanu({
    super.key,
    this.size = IsharaSizes.resultMascot,
    this.pose = DanuPose.wave,
  });

  final double size;
  final DanuPose pose;

  @override
  Widget build(BuildContext context) => PopIn(
    delay: IsharaMotion.fast,
    child: DanuMascot(pose: pose, size: size, animated: true),
  );
}
