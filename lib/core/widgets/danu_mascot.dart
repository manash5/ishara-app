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
  /// wings and a tear rolls down; the point pose jabs its wing out twice
  /// with a hop ("this way!"); the namaste pose bows deeply, eyes closed;
  /// the think pose taps its chin while thought dots rise and a cloud with a
  /// signing hand pops up above it (overflowing the box, up and right).
  /// Reduced motion shows the still artwork.
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
            DanuPose.point => _PointingDanu(size: size),
            DanuPose.think => _ThinkingDanu(size: size),
            DanuPose.namaste => _BowingDanu(size: size),
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

/// Shared helpers for the layered loops below: every layer is the full
/// artboard drawn into the same square, so pivots are artboard px.
class _Rig {
  _Rig(this.size, double artboardWidth, double artboardHeight)
    : k = size / artboardHeight,
      dx = (size - artboardWidth * (size / artboardHeight)) / 2;

  final double size;

  /// Artboard px → logical px.
  final double k;
  final double dx;

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

  Widget squash(double sx, double sy, Offset pivot, Widget child) => Transform(
    alignment: Alignment.topLeft,
    origin: px(pivot),
    transform: Matrix4.diagonal3Values(sx, sy, 1),
    child: child,
  );
}

/// 0 → 1 → 0 over [start, end] of [t] (a smooth bump), else 0.
double _bump(double t, double start, double end) => t <= start || t >= end
    ? 0
    : math.sin(math.pi * (t - start) / (end - start));

/// 0 → 1 over [start, end] of [t], eased in and out.
double _ease(double t, double start, double end) {
  final x = ((t - start) / (end - start)).clamp(0.0, 1.0);
  return (1 - math.cos(math.pi * x)) / 2;
}

/// The point pose in layers (assets/mascot/point_layers/, same 200 × 203
/// artwork), bottom → top. The wing points to the right; mirror the whole
/// mascot to point left.
abstract final class DanuPointLayers {
  static const String _dir = 'assets/mascot/point_layers';
  static const String back = '$_dir/back.svg'; // tail, legs, body, far wing
  static const String wing = '$_dir/wing.svg'; // the outstretched wing
  static const String head = '$_dir/head.svg';
  static const String eye = '$_dir/eye.svg';
  static const String crest = '$_dir/crest.svg';

  static const List<String> all = [back, wing, head, eye, crest];
}

/// Timing and pivots of the point loop (artboard px on the 200 × 203 pose):
/// "this way, this way!" — two quick jabs with a hop each, then a breath.
abstract final class DanuPointMotion {
  static const Duration period = Duration(milliseconds: 1600);

  /// Blinks once every this many loops.
  static const int blinkEvery = 2;

  /// The two jabs, as fractions of the loop.
  static const (double, double) firstJab = (0, 0.22);
  static const (double, double) secondJab = (0.28, 0.5);

  static const double reach = 0.25; // wing length, stretched from the shoulder
  static const double wingLift = 16; // degrees, the tip swings up
  static const double headLean = 9; // degrees, towards where it points
  static const double crestFlick = 16; // degrees, lags the head
  static const double lean = 5; // artboard px, the body follows the jab
  static const double hop = 7; // artboard px, a little hop per jab
  static const double stretch = 0.04; // body scale on each hop

  static const Offset shoulder = Offset(124, 105);
  static const Offset neck = Offset(105, 82);
  static const Offset crestBase = Offset(105, 40);
  static const Offset eyeCentre = Offset(119, 60);
  static const Offset feet = Offset(100, 195);

  static const double artboardWidth = 200;
  static const double artboardHeight = 203;

  /// How far out the wing is (0 → 1 → 0, twice) at [t] through a loop.
  static double thrust(double t) =>
      _bump(t, firstJab.$1, firstJab.$2) + _bump(t, secondJab.$1, secondJab.$2);
}

class _PointingDanu extends StatefulWidget {
  const _PointingDanu({required this.size});

  final double size;

  @override
  State<_PointingDanu> createState() => _PointingDanuState();
}

class _PointingDanuState extends State<_PointingDanu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: DanuPointMotion.period * DanuPointMotion.blinkEvery,
  )..repeat();

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = _Rig(
      widget.size,
      DanuPointMotion.artboardWidth,
      DanuPointMotion.artboardHeight,
    );
    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        final cycles = _loop.value * DanuPointMotion.blinkEvery;
        final t = cycles % 1;
        final thrust = DanuPointMotion.thrust(t);
        // The crest flicks a beat behind the head.
        final flick = DanuPointMotion.thrust((t - 0.06) % 1);
        // Blink in the pause after the jabs, on the last loop of the span.
        final local = cycles - (DanuPointMotion.blinkEvery - 1);
        final blink = 1 - 0.85 * _bump(local, 0.7, 0.82);

        return Transform.translate(
          offset: Offset(
            DanuPointMotion.lean * r.k * thrust,
            -DanuPointMotion.hop * r.k * thrust,
          ),
          child: r.squash(
            1 - DanuPointMotion.stretch / 2 * thrust,
            1 + DanuPointMotion.stretch * thrust,
            DanuPointMotion.feet,
            Stack(
              children: [
                r.layer(DanuPointLayers.back),
                // The wing reaches out from the shoulder (so it stays
                // attached) and swings up.
                r.squash(
                  1 + DanuPointMotion.reach * thrust,
                  1,
                  DanuPointMotion.shoulder,
                  r.turn(
                    -DanuPointMotion.wingLift * thrust,
                    DanuPointMotion.shoulder,
                    r.layer(DanuPointLayers.wing),
                  ),
                ),
                r.turn(
                  DanuPointMotion.headLean * thrust,
                  DanuPointMotion.neck,
                  Stack(
                    children: [
                      r.layer(DanuPointLayers.head),
                      r.squash(
                        1,
                        blink,
                        DanuPointMotion.eyeCentre,
                        r.layer(DanuPointLayers.eye),
                      ),
                      r.turn(
                        DanuPointMotion.crestFlick * flick,
                        DanuPointMotion.crestBase,
                        r.layer(DanuPointLayers.crest),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The namaste pose in layers (assets/mascot/namaste_layers/, same
/// 200 × 203 artwork), bottom → top.
abstract final class DanuNamasteLayers {
  static const String _dir = 'assets/mascot/namaste_layers';
  static const String tail = '$_dir/tail.svg'; // tail and legs
  static const String body = '$_dir/body.svg';
  static const String head = '$_dir/head.svg';
  static const String eye = '$_dir/eye.svg';
  static const String crest = '$_dir/crest.svg';
  static const String wings = '$_dir/wings.svg'; // joined at the chest

  static const List<String> all = [tail, body, head, eye, crest, wings];
}

/// Timing and pivots of the namaste loop (artboard px on the 200 × 203
/// pose): Danu bows deeply from the hips, eyes closed, holds, and rises.
abstract final class DanuNamasteMotion {
  static const Duration period = Duration(milliseconds: 2800);

  /// Phases of one bow, as fractions of the loop.
  static const double downEnd = 0.28;
  static const double holdEnd = 0.55;
  static const double upEnd = 0.85;

  static const double bow = 24; // degrees, the body tips forward
  static const double nod = 14; // degrees more for the head
  static const double crestFlop = 12; // degrees, lags the bow
  static const double tailLift = 10; // degrees, the tail rises to balance

  static const Offset hips = Offset(100, 170);
  static const Offset neck = Offset(105, 82);
  static const Offset crestBase = Offset(105, 40);
  static const Offset eyeCentre = Offset(119, 60);
  static const Offset tailRoot = Offset(84, 140);

  static const double artboardWidth = 200;
  static const double artboardHeight = 203;

  /// How far down Danu is (0 upright → 1 full bow) at [t] through a bow.
  static double depth(double t) =>
      t < holdEnd ? _ease(t, 0, downEnd) : 1 - _ease(t, holdEnd, upEnd);
}

class _BowingDanu extends StatefulWidget {
  const _BowingDanu({required this.size});

  final double size;

  @override
  State<_BowingDanu> createState() => _BowingDanuState();
}

class _BowingDanuState extends State<_BowingDanu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: DanuNamasteMotion.period,
  )..repeat();

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = _Rig(
      widget.size,
      DanuNamasteMotion.artboardWidth,
      DanuNamasteMotion.artboardHeight,
    );
    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        final t = _loop.value;
        final depth = DanuNamasteMotion.depth(t);
        final lag = DanuNamasteMotion.depth((t - 0.08) % 1);
        // Eyes close as Danu bows and open again on the way up.
        final eyes = 1 - 0.85 * math.min(1.0, depth * 1.6);

        return Stack(
          children: [
            r.turn(
              -DanuNamasteMotion.tailLift * depth,
              DanuNamasteMotion.tailRoot,
              r.layer(DanuNamasteLayers.tail),
            ),
            r.turn(
              DanuNamasteMotion.bow * depth,
              DanuNamasteMotion.hips,
              Stack(
                children: [
                  r.layer(DanuNamasteLayers.body),
                  r.turn(
                    DanuNamasteMotion.nod * depth,
                    DanuNamasteMotion.neck,
                    Stack(
                      children: [
                        r.layer(DanuNamasteLayers.head),
                        r.squash(
                          1,
                          eyes,
                          DanuNamasteMotion.eyeCentre,
                          r.layer(DanuNamasteLayers.eye),
                        ),
                        r.turn(
                          DanuNamasteMotion.crestFlop * lag,
                          DanuNamasteMotion.crestBase,
                          r.layer(DanuNamasteLayers.crest),
                        ),
                      ],
                    ),
                  ),
                  r.layer(DanuNamasteLayers.wings),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The think pose in layers (assets/mascot/think_layers/, same 200 × 204
/// artwork), bottom → top, plus a thought cloud drawn in theme colours.
abstract final class DanuThinkLayers {
  static const String _dir = 'assets/mascot/think_layers';
  static const String back = '$_dir/back.svg'; // tail, legs, body, far wing
  static const String head = '$_dir/head.svg';
  static const String eye = '$_dir/eye.svg';
  static const String crest = '$_dir/crest.svg';
  static const String wing = '$_dir/wing.svg'; // on the chin
  static const String dot1 = '$_dir/dot1.svg'; // smallest, nearest the head
  static const String dot2 = '$_dir/dot2.svg';
  static const String dot3 = '$_dir/dot3.svg';

  static const List<String> dots = [dot1, dot2, dot3];
  static const List<String> all = [back, head, eye, crest, wing, ...dots];
}

/// Timing and pivots of the think loop (artboard px on the 200 × 204 pose):
/// Danu taps its chin, the thought dots rise one by one, a cloud with a
/// signing hand pops up above, then it all drifts away.
abstract final class DanuThinkMotion {
  static const Duration period = Duration(milliseconds: 3600);

  /// When each dot pops in, and when the cloud does.
  static const List<double> dotAt = [0.06, 0.16, 0.26];
  static const double popLength = 0.1;
  static const double cloudAt = 0.34;

  /// When the dots and cloud fade away.
  static const double fadeStart = 0.82;
  static const double fadeEnd = 0.96;

  static const int chinTaps = 3;
  static const double tapEnd = 0.36;
  static const double tap = 7; // degrees
  static const double headTilt = 8; // degrees, looking up at the cloud
  static const double ponder = 3; // degrees, a slow side-to-side
  static const double crestSway = 8; // degrees
  static const double lookUp = 3; // artboard px, the eye rolls up
  static const double handWiggle = 12; // degrees, in the cloud

  static const Offset wingRoot = Offset(120, 122);
  static const Offset neck = Offset(105, 83);
  static const Offset crestBase = Offset(105, 41);
  static const Offset eyeCentre = Offset(119, 61);
  static const List<Offset> dotCentres = [
    Offset(150, 41.8),
    Offset(158, 30.8),
    Offset(168, 17.8),
  ];

  /// The cloud's box, above and right of the artboard (it overflows).
  static const Rect cloud = Rect.fromLTWH(150, -44, 80, 54);

  static const double artboardWidth = 200;
  static const double artboardHeight = 204;

  /// Pop-in scale (0 → overshoot → 1) of something that appears at [at].
  static double pop(double t, double at) {
    final x = ((t - at) / popLength).clamp(0.0, 1.0);
    return IsharaMotion.playful.transform(x);
  }

  /// Opacity of the dots and cloud as they drift away at the end.
  static double fade(double t) => 1 - _ease(t, fadeStart, fadeEnd);
}

class _ThinkingDanu extends StatefulWidget {
  const _ThinkingDanu({required this.size});

  final double size;

  @override
  State<_ThinkingDanu> createState() => _ThinkingDanuState();
}

class _ThinkingDanuState extends State<_ThinkingDanu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: DanuThinkMotion.period,
  )..repeat();

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final r = _Rig(
      widget.size,
      DanuThinkMotion.artboardWidth,
      DanuThinkMotion.artboardHeight,
    );
    const box = DanuThinkMotion.cloud;
    final cloudTopLeft = r.px(box.topLeft);
    Widget popAt(double scale, Offset centre, Widget child) => Transform(
      alignment: Alignment.topLeft,
      origin: r.px(centre),
      transform: Matrix4.diagonal3Values(scale, scale, 1),
      child: child,
    );

    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        final t = _loop.value;
        final fade = DanuThinkMotion.fade(t);
        final up = _ease(t, DanuThinkMotion.cloudAt, 0.5) * fade;
        final taps = t < DanuThinkMotion.tapEnd
            ? math
                  .sin(
                    math.pi *
                        DanuThinkMotion.chinTaps *
                        t /
                        DanuThinkMotion.tapEnd,
                  )
                  .abs()
            : 0.0;
        final blink = 1 - 0.85 * _bump(t, 0.9, 0.98);
        final cloud = DanuThinkMotion.pop(t, DanuThinkMotion.cloudAt);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            r.layer(DanuThinkLayers.back),
            r.turn(
              -DanuThinkMotion.headTilt * up +
                  DanuThinkMotion.ponder * math.sin(2 * math.pi * t),
              DanuThinkMotion.neck,
              Stack(
                children: [
                  r.layer(DanuThinkLayers.head),
                  Transform.translate(
                    offset: Offset(0, -DanuThinkMotion.lookUp * r.k * up),
                    child: r.squash(
                      1,
                      blink,
                      DanuThinkMotion.eyeCentre,
                      r.layer(DanuThinkLayers.eye),
                    ),
                  ),
                  r.turn(
                    DanuThinkMotion.crestSway * math.sin(2 * math.pi * t - 1),
                    DanuThinkMotion.crestBase,
                    r.layer(DanuThinkLayers.crest),
                  ),
                ],
              ),
            ),
            r.turn(
              -DanuThinkMotion.tap * taps,
              DanuThinkMotion.wingRoot,
              r.layer(DanuThinkLayers.wing),
            ),
            for (final (i, dot) in DanuThinkLayers.dots.indexed)
              Opacity(
                opacity: fade,
                child: popAt(
                  DanuThinkMotion.pop(t, DanuThinkMotion.dotAt[i]),
                  DanuThinkMotion.dotCentres[i],
                  r.layer(dot),
                ),
              ),
            Positioned(
              left: cloudTopLeft.dx,
              top: cloudTopLeft.dy,
              width: box.width * r.k,
              height: box.height * r.k,
              child: Opacity(
                key: const Key('danu-thought-cloud'),
                opacity: fade,
                child: Transform.scale(
                  scale: cloud,
                  alignment: Alignment.bottomLeft,
                  child: CustomPaint(
                    painter: _CloudPainter(
                      fill: c.bgSurface,
                      outline: c.funLavender,
                      outlineWidth: IsharaSizes.selectedBorder,
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle:
                            DanuThinkMotion.handWiggle *
                            math.pi /
                            180 *
                            math.sin(4 * math.pi * t),
                        child: Icon(
                          IsharaIcons.hand,
                          size: box.height * r.k * 0.42,
                          color: c.accentText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A puffy thought cloud filling its box: overlapping round puffs on a
/// flat-ish base, filled and outlined.
class _CloudPainter extends CustomPainter {
  const _CloudPainter({
    required this.fill,
    required this.outline,
    required this.outlineWidth,
  });

  final Color fill;
  final Color outline;
  final double outlineWidth;

  /// Puffs as (centre x, centre y, radius) fractions of the box.
  static const List<(double, double, double)> puffs = [
    (0.24, 0.6, 0.22),
    (0.42, 0.36, 0.28),
    (0.66, 0.38, 0.25),
    (0.8, 0.62, 0.2),
    (0.52, 0.68, 0.26),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final inset = outlineWidth / 2;
    final s = Size(size.width - inset * 2, size.height - inset * 2);
    var path = Path();
    for (final (x, y, r) in puffs) {
      final radius = r * s.height;
      final puff = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(inset + x * s.width, inset + y * s.height),
            radius: radius,
          ),
        );
      path = Path.combine(PathOperation.union, path, puff);
    }
    canvas
      ..drawPath(path, Paint()..color = fill)
      ..drawPath(
        path,
        Paint()
          ..color = outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = outlineWidth,
      );
  }

  @override
  bool shouldRepaint(_CloudPainter old) =>
      old.fill != fill ||
      old.outline != outline ||
      old.outlineWidth != outlineWidth;
}
