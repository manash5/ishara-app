import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `Mascot` → `pose`.
enum DanuPose {
  wave('waving'),
  celebrate('celebrating'),
  think('thinking'),
  sad('sad'),
  namaste('greeting you with namaste'),
  point('pointing');

  const DanuPose(this.description);

  /// Spoken description for screen readers.
  final String description;

  String get asset => 'assets/mascot/$name.svg';
}

/// Danu the Danphe (Himalayan monal), Ishara's mascot. Roadmap kit only —
/// Danu appears on the Learn path, lesson results and in the logo (ui.md).
///
/// Pose changes cross-fade in [IsharaMotion.fast] (instant with reduced
/// motion). Artwork is exported from Figma into `assets/mascot/`.
class DanuMascot extends StatelessWidget {
  const DanuMascot({
    super.key,
    this.pose = DanuPose.wave,
    this.size = IsharaSizes.mascot,
    this.animated = false,
  });

  final DanuPose pose;
  final double size;

  /// Bring Danu to life (roadmap and results only), on a loop: the wave
  /// pose waves its wing, bobs its head, sways its crest and blinks; the
  /// celebrate pose cheers with both wings, hops, and its confetti
  /// twinkles; the sad pose sighs, hangs its head and crest, droops its
  /// wings and a tear rolls down. Other poses, and reduced motion, show the
  /// still artwork.
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final live = animated && !IsharaMotion.reduced(context);
    final Widget? alive = !live
        ? null
        : switch (pose) {
            DanuPose.wave => _WavingDanu(size: size),
            DanuPose.celebrate => _CelebratingDanu(size: size),
            DanuPose.sad => _SadDanu(size: size),
            _ => null,
          };
    return Semantics(
      container: true,
      image: true,
      label: 'Danu the Danphe, ${pose.description}',
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child:
            alive ??
            AnimatedSwitcher(
              duration: IsharaMotion.duration(context, IsharaMotion.fast),
              switchInCurve: IsharaMotion.enter,
              switchOutCurve: IsharaMotion.exit,
              child: SvgPicture.asset(
                pose.asset,
                key: ValueKey(pose),
                width: size,
                height: size,
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
            ),
      ),
    );
  }
}

/// The wave pose in layers (assets/mascot/wave_layers/, same 200 × 203
/// artwork), bottom → top.
abstract final class DanuWaveLayers {
  static const String _dir = 'assets/mascot/wave_layers';
  static const String back = '$_dir/back.svg'; // tail, legs, body, far wing
  static const String wing = '$_dir/wing.svg'; // the raised, waving wing
  static const String head = '$_dir/head.svg';
  static const String eye = '$_dir/eye.svg';
  static const String crest = '$_dir/crest.svg';
  static const String motion = '$_dir/motion.svg'; // the little wave lines

  static const List<String> all = [back, wing, head, eye, crest, motion];
}

/// Timing and pivots of the wave loop (artboard px on the 200 × 203 pose).
abstract final class DanuWaveMotion {
  /// One wave (there and back).
  static const Duration period = Duration(milliseconds: 1400);

  /// Blinks once every this many waves.
  static const int blinkEvery = 3;

  static const double wingSwing = 14; // degrees
  static const double headBob = 3; // degrees
  static const double crestSway = 6; // degrees
  static const double breath = 0.015; // body scale
  static const double motionDrift = 2; // artboard px

  static const Offset shoulder = Offset(125, 105);
  static const Offset neck = Offset(105, 82);
  static const Offset crestBase = Offset(105, 40);
  static const Offset eyeCentre = Offset(119, 60);
  static const Offset feet = Offset(100, 195);

  static const double artboardWidth = 200;
  static const double artboardHeight = 203;
}

class _WavingDanu extends StatefulWidget {
  const _WavingDanu({required this.size});

  final double size;

  @override
  State<_WavingDanu> createState() => _WavingDanuState();
}

class _WavingDanuState extends State<_WavingDanu>
    with SingleTickerProviderStateMixin {
  // One controller spans [blinkEvery] waves so the blink stays in step.
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: DanuWaveMotion.period * DanuWaveMotion.blinkEvery,
  )..repeat();

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    // BoxFit.contain of the 200 × 203 artboard into the square box.
    final k = size / DanuWaveMotion.artboardHeight;
    final dx = (size - DanuWaveMotion.artboardWidth * k) / 2;
    Offset px(Offset p) => Offset(dx + p.dx * k, p.dy * k);
    Widget layer(String asset) => SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
    Widget turn(double degrees, Offset pivot, Widget child) => Transform.rotate(
      angle: degrees * math.pi / 180,
      alignment: Alignment.topLeft,
      origin: px(pivot),
      child: child,
    );

    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        final cycles = _loop.value * DanuWaveMotion.blinkEvery;
        final a = 2 * math.pi * cycles; // one wave per 2π
        final wave = math.sin(a);
        // Blink near the end of the last wave in the span.
        final local = cycles - (DanuWaveMotion.blinkEvery - 1);
        final blink = local > 0.88
            ? 1 - 0.85 * math.sin(math.pi * (local - 0.88) / 0.12)
            : 1.0;
        final feet = px(DanuWaveMotion.feet);
        final eye = px(DanuWaveMotion.eyeCentre);

        return Transform(
          alignment: Alignment.topLeft,
          origin: feet,
          transform: Matrix4.diagonal3Values(
            1,
            1 + DanuWaveMotion.breath * math.sin(a * 0.5),
            1,
          ),
          child: Stack(
            children: [
              layer(DanuWaveLayers.back),
              turn(
                DanuWaveMotion.wingSwing * wave,
                DanuWaveMotion.shoulder,
                layer(DanuWaveLayers.wing),
              ),
              // Head, eye and crest move together; the crest lags a beat.
              turn(
                DanuWaveMotion.headBob * math.sin(a - 0.6),
                DanuWaveMotion.neck,
                Stack(
                  children: [
                    layer(DanuWaveLayers.head),
                    Transform(
                      alignment: Alignment.topLeft,
                      origin: eye,
                      transform: Matrix4.diagonal3Values(1, blink, 1),
                      child: layer(DanuWaveLayers.eye),
                    ),
                    turn(
                      DanuWaveMotion.crestSway * math.sin(a - 1.2),
                      DanuWaveMotion.crestBase,
                      layer(DanuWaveLayers.crest),
                    ),
                  ],
                ),
              ),
              Opacity(
                opacity: 0.55 + 0.45 * math.sin(a + math.pi / 2).abs(),
                child: Transform.translate(
                  offset: Offset(DanuWaveMotion.motionDrift * k * wave, 0),
                  child: layer(DanuWaveLayers.motion),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The celebrate pose in layers (assets/mascot/celebrate_layers/, same
/// 200 × 207 artwork), bottom → top.
abstract final class DanuCelebrateLayers {
  static const String _dir = 'assets/mascot/celebrate_layers';
  static const String back = '$_dir/back.svg'; // tail, legs, body
  static const String wingLeft = '$_dir/wing_left.svg';
  static const String wingRight = '$_dir/wing_right.svg';
  static const String head = '$_dir/head.svg';
  static const String eye = '$_dir/eye.svg';
  static const String crest = '$_dir/crest.svg';
  static const String confetti = '$_dir/confetti.svg';

  static const List<String> all = [
    back,
    wingLeft,
    wingRight,
    head,
    eye,
    crest,
    confetti,
  ];
}

/// Timing and pivots of the celebrate loop (artboard px on the 200 × 207
/// pose).
abstract final class DanuCelebrateMotion {
  /// One cheer: a wing flap and a hop.
  static const Duration period = Duration(milliseconds: 1000);

  /// Blinks once every this many cheers.
  static const int blinkEvery = 3;

  static const double wingFlap = 12; // degrees
  static const double hop = 5; // artboard px
  static const double headBob = 3; // degrees
  static const double crestSway = 6; // degrees
  static const double confettiDrift = 3; // artboard px

  static const Offset leftShoulder = Offset(71, 108);
  static const Offset rightShoulder = Offset(129, 108);
  static const Offset neck = Offset(105, 86);
  static const Offset crestBase = Offset(105, 44);
  static const Offset eyeCentre = Offset(119, 64);

  static const double artboardWidth = 200;
  static const double artboardHeight = 207;
}

class _CelebratingDanu extends StatefulWidget {
  const _CelebratingDanu({required this.size});

  final double size;

  @override
  State<_CelebratingDanu> createState() => _CelebratingDanuState();
}

class _CelebratingDanuState extends State<_CelebratingDanu>
    with SingleTickerProviderStateMixin {
  // One controller spans [blinkEvery] cheers so the blink stays in step.
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: DanuCelebrateMotion.period * DanuCelebrateMotion.blinkEvery,
  )..repeat();

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    // BoxFit.contain of the 200 × 207 artboard into the square box.
    final k = size / DanuCelebrateMotion.artboardHeight;
    final dx = (size - DanuCelebrateMotion.artboardWidth * k) / 2;
    Offset px(Offset p) => Offset(dx + p.dx * k, p.dy * k);
    Widget layer(String asset) => SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
    Widget turn(double degrees, Offset pivot, Widget child) => Transform.rotate(
      angle: degrees * math.pi / 180,
      alignment: Alignment.topLeft,
      origin: px(pivot),
      child: child,
    );

    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        final cycles = _loop.value * DanuCelebrateMotion.blinkEvery;
        final a = 2 * math.pi * cycles; // one cheer per 2π
        final flap = math.sin(a);
        // One hop per cheer: quick off the ground, soft at the top.
        final lift = math.sin(a / 2).abs();
        final local = cycles - (DanuCelebrateMotion.blinkEvery - 1);
        final blink = local > 0.88
            ? 1 - 0.85 * math.sin(math.pi * (local - 0.88) / 0.12)
            : 1.0;
        final eye = px(DanuCelebrateMotion.eyeCentre);

        return Stack(
          children: [
            Transform.translate(
              offset: Offset(0, -DanuCelebrateMotion.hop * k * lift),
              child: Stack(
                children: [
                  layer(DanuCelebrateLayers.back),
                  // Both wings pump up and out, mirrored.
                  turn(
                    -DanuCelebrateMotion.wingFlap * flap,
                    DanuCelebrateMotion.leftShoulder,
                    layer(DanuCelebrateLayers.wingLeft),
                  ),
                  turn(
                    DanuCelebrateMotion.wingFlap * flap,
                    DanuCelebrateMotion.rightShoulder,
                    layer(DanuCelebrateLayers.wingRight),
                  ),
                  // Head, eye and crest move together; the crest lags.
                  turn(
                    DanuCelebrateMotion.headBob * math.sin(a - 0.6),
                    DanuCelebrateMotion.neck,
                    Stack(
                      children: [
                        layer(DanuCelebrateLayers.head),
                        Transform(
                          alignment: Alignment.topLeft,
                          origin: eye,
                          transform: Matrix4.diagonal3Values(1, blink, 1),
                          child: layer(DanuCelebrateLayers.eye),
                        ),
                        turn(
                          DanuCelebrateMotion.crestSway * math.sin(a - 1.2),
                          DanuCelebrateMotion.crestBase,
                          layer(DanuCelebrateLayers.crest),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Confetti stays in the air: it twinkles and drifts.
            Opacity(
              opacity: 0.6 + 0.4 * math.cos(a / 2).abs(),
              child: Transform.translate(
                offset: Offset(
                  0,
                  DanuCelebrateMotion.confettiDrift * k * math.sin(a / 2),
                ),
                child: layer(DanuCelebrateLayers.confetti),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The sad pose in layers (assets/mascot/sad_layers/, same 200 × 200
/// artwork), bottom → top.
abstract final class DanuSadLayers {
  static const String _dir = 'assets/mascot/sad_layers';
  static const String back = '$_dir/back.svg'; // tail, legs, body
  static const String wings = '$_dir/wings.svg'; // both wings, hanging
  static const String head = '$_dir/head.svg';
  static const String eye = '$_dir/eye.svg';
  static const String crest = '$_dir/crest.svg';
  static const String tear = '$_dir/tear.svg';

  static const List<String> all = [back, wings, head, eye, crest, tear];
}

/// Timing and pivots of the sad loop (artboard px on the 200 × 200 pose).
abstract final class DanuSadMotion {
  /// One sigh: the head sinks and lifts, a tear rolls down.
  static const Duration period = Duration(milliseconds: 2400);

  /// Blinks once every this many sighs.
  static const int blinkEvery = 2;

  static const double headDroop = 5; // degrees, forward and down
  static const double crestDroop = 8; // degrees, lags the head
  static const double wingSag = 3; // degrees
  static const double sigh = 0.02; // body scale
  static const double tearFall = 14; // artboard px

  static const Offset neck = Offset(108, 82);
  static const Offset crestBase = Offset(108, 38);
  static const Offset eyeCentre = Offset(119, 57);
  static const Offset shoulders = Offset(100, 104);
  static const Offset feet = Offset(100, 188);

  static const double artboardSize = 200;
}

class _SadDanu extends StatefulWidget {
  const _SadDanu({required this.size});

  final double size;

  @override
  State<_SadDanu> createState() => _SadDanuState();
}

class _SadDanuState extends State<_SadDanu>
    with SingleTickerProviderStateMixin {
  // One controller spans [blinkEvery] sighs so the blink stays in step.
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: DanuSadMotion.period * DanuSadMotion.blinkEvery,
  )..repeat();

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final k = size / DanuSadMotion.artboardSize;
    Offset px(Offset p) => p * k;
    Widget layer(String asset) => SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
    Widget turn(double degrees, Offset pivot, Widget child) => Transform.rotate(
      angle: degrees * math.pi / 180,
      alignment: Alignment.topLeft,
      origin: px(pivot),
      child: child,
    );

    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        final cycles = _loop.value * DanuSadMotion.blinkEvery;
        final t = cycles % 1; // progress through this sigh
        // 0 → 1 → 0 once per sigh, slow in and out.
        final sink = (1 - math.cos(2 * math.pi * t)) / 2;
        final lag = (1 - math.cos(2 * math.pi * (t - 0.08))) / 2;
        // A slow, heavy blink at the bottom of the last sigh in the span.
        final local = cycles - (DanuSadMotion.blinkEvery - 1);
        final blink = local > 0.4 && local < 0.6
            ? 1 - 0.85 * math.sin(math.pi * (local - 0.4) / 0.2)
            : 1.0;
        // The tear wells up, rolls down and fades.
        final tearIn = (t / 0.2).clamp(0.0, 1.0);
        final tearOut = ((1 - t) / 0.3).clamp(0.0, 1.0);
        final eye = px(DanuSadMotion.eyeCentre);

        return Transform(
          alignment: Alignment.topLeft,
          origin: px(DanuSadMotion.feet),
          // A sigh: the body sinks a touch as the head drops.
          transform: Matrix4.diagonal3Values(
            1,
            1 - DanuSadMotion.sigh * sink,
            1,
          ),
          child: Stack(
            children: [
              layer(DanuSadLayers.back),
              Transform(
                alignment: Alignment.topLeft,
                origin: px(DanuSadMotion.shoulders),
                transform: Matrix4.diagonal3Values(
                  1 - DanuSadMotion.wingSag / 100 * sink,
                  1 + DanuSadMotion.wingSag / 100 * sink,
                  1,
                ),
                child: layer(DanuSadLayers.wings),
              ),
              // Head, eye, crest and tear move together; the crest lags.
              turn(
                DanuSadMotion.headDroop * sink,
                DanuSadMotion.neck,
                Stack(
                  children: [
                    layer(DanuSadLayers.head),
                    Transform(
                      alignment: Alignment.topLeft,
                      origin: eye,
                      transform: Matrix4.diagonal3Values(1, blink, 1),
                      child: layer(DanuSadLayers.eye),
                    ),
                    turn(
                      DanuSadMotion.crestDroop * lag,
                      DanuSadMotion.crestBase,
                      layer(DanuSadLayers.crest),
                    ),
                    Opacity(
                      opacity: math.min(tearIn, tearOut),
                      child: Transform.translate(
                        offset: Offset(0, DanuSadMotion.tearFall * k * t),
                        child: layer(DanuSadLayers.tear),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
