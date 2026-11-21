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

  /// Bring Danu to life (roadmap only): the wave pose waves its wing, bobs
  /// its head, sways its crest and blinks, on a loop. Other poses, and
  /// reduced motion, show the still artwork.
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final live =
        animated && pose == DanuPose.wave && !IsharaMotion.reduced(context);
    return Semantics(
      container: true,
      image: true,
      label: 'Danu the Danphe, ${pose.description}',
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: live
            ? _WavingDanu(size: size)
            : AnimatedSwitcher(
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
