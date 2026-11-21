import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `Logo/Mark` | `Logo/Lockup`.
enum IsharaLogoVariant { mark, lockup }

/// The Ishara logo: Danu's head mark (SVG artwork exported from Figma), or
/// the lockup with the "ishara" wordmark.
///
/// With [intro] (0 → 1) the mark assembles itself, Danphe-style: the tile
/// pops in, the body rises, the head pops, the crest feathers sprout and
/// settle, a fun/lime ripple spreads from the mark, and the wordmark slides
/// out from behind it. At 1 it is identical to the static logo. The caller
/// owns the controller and skips it under reduced motion.
class IsharaLogo extends StatelessWidget {
  const IsharaLogo({
    super.key,
    this.variant = IsharaLogoVariant.mark,
    this.scale = 1,
    this.onHero = false,
    this.intro,
  });

  static const String markAsset = 'assets/brand/logo_mark.svg';

  /// The same artwork split into layers (bottom → top) for [intro].
  static const String _layers = 'assets/brand/logo_mark_layers';
  static const String tileAsset = '$_layers/tile.svg';
  static const String bodyAsset = '$_layers/body.svg';
  static const String headAsset = '$_layers/head.svg';
  static const String crestAsset = '$_layers/crest.svg';

  final IsharaLogoVariant variant;

  /// Multiplies every dimension (Splash uses the lockup at 1.6×, 54:4331).
  final double scale;

  /// Wordmark in static/white on a teal HeroBackdrop (Splash).
  final bool onHero;

  /// Optional entrance animation, see the class docs.
  final Animation<double>? intro;

  @override
  Widget build(BuildContext context) {
    final Widget logo = switch (variant) {
      IsharaLogoVariant.mark => _mark(IsharaSizes.logoMark * scale),
      IsharaLogoVariant.lockup => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _mark(IsharaSizes.logoLockupMark * scale),
          SizedBox(width: IsharaSizes.logoLockupGap * scale),
          _wordmarkText(context),
        ],
      ),
    };
    return Semantics(
      container: true,
      label: 'Ishara',
      image: true,
      excludeSemantics: true,
      child: logo,
    );
  }

  Widget _wordmarkText(BuildContext context) {
    // Figma: 26 ExtraBold — headline/small at w800, scaled.
    final text = Text(
      'ishara',
      textScaler: TextScaler.noScaling,
      style: _wordmark(context),
    );
    final a = intro;
    if (a == null) return text;
    return ClipRect(
      child: AnimatedBuilder(
        animation: a,
        builder: (context, child) {
          final t = LogoIntro.wordmark.transform(a.value);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(-LogoIntro.wordmarkSlide * scale * (1 - t), 0),
              child: child,
            ),
          );
        },
        child: text,
      ),
    );
  }

  TextStyle _wordmark(BuildContext context) {
    final base = context.textStyles.headlineSmall;
    return base.copyWith(
      color: onHero ? context.colors.staticWhite : context.colors.textPrimary,
      fontWeight: FontWeight.w800,
      fontSize: base.fontSize! * scale,
      letterSpacing: (base.letterSpacing ?? 0) * scale,
    );
  }

  Widget _mark(double size) {
    final a = intro;
    if (a == null) return _svg(markAsset, size);
    return SizedBox.square(
      dimension: size,
      child: AnimatedBuilder(
        animation: a,
        builder: (context, _) => _AnimatedMark(
          t: a.value,
          size: size,
          ripple: context.colors.funLime,
        ),
      ),
    );
  }
}

Widget _svg(String asset, double size) => SvgPicture.asset(
  asset,
  width: size,
  height: size,
  excludeFromSemantics: true,
);

/// Timing of [IsharaLogo.intro], as fractions of the intro.
abstract final class LogoIntro {
  static const Interval tile = Interval(0, 0.35, curve: IsharaMotion.playful);
  static const Interval body = Interval(0.15, 0.5, curve: IsharaMotion.enter);
  static const Interval head = Interval(0.3, 0.62, curve: IsharaMotion.playful);
  static const Interval crest = Interval(
    0.48,
    0.85,
    curve: IsharaMotion.playful,
  );
  static const Interval ripple = Interval(0.55, 1, curve: IsharaMotion.enter);
  static const Interval wordmark = Interval(
    0.55,
    0.9,
    curve: IsharaMotion.enter,
  );

  /// Start scales / offsets (artboard px on the 48px mark).
  static const double tileStartScale = 0.6;
  static const double headStartScale = 0.4;
  static const double bodyRise = IsharaSpacing.s3;
  static const double crestStartTilt = -8; // degrees
  static const double wordmarkSlide = IsharaSpacing.s4;

  /// Ripple grows from the mark to this multiple of its size.
  static const double rippleMaxScale = 1.9;
  static const double rippleStroke = IsharaSizes.selectedBorder;
}

/// Mark artboard (48 × 48) anchor points for the layer transforms.
const double _artboard = 48;
const Offset _headCentre = Offset(24, 27);
const Offset _crestBase = Offset(24, 16);

class _AnimatedMark extends StatelessWidget {
  const _AnimatedMark({
    required this.t,
    required this.size,
    required this.ripple,
  });

  final double t;
  final double size;
  final Color ripple;

  Alignment _align(Offset p) =>
      Alignment(p.dx / _artboard * 2 - 1, p.dy / _artboard * 2 - 1);

  @override
  Widget build(BuildContext context) {
    final k = size / _artboard;
    final tile = LogoIntro.tile.transform(t);
    final body = LogoIntro.body.transform(t);
    final head = LogoIntro.head.transform(t);
    final crest = LogoIntro.crest.transform(t);
    final rippleT = LogoIntro.ripple.transform(t);

    Widget layer(
      String asset,
      double opacity, {
      Matrix4? transform,
      Alignment? at,
    }) {
      Widget w = _svg(asset, size);
      if (transform != null) {
        w = Transform(transform: transform, alignment: at, child: w);
      }
      return Opacity(opacity: opacity.clamp(0.0, 1.0), child: w);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Lime ripple spreading out once the Danphe is complete.
        if (rippleT > 0 && rippleT < 1)
          Positioned.fill(
            child: CustomPaint(
              painter: _RipplePainter(
                progress: rippleT,
                color: ripple,
                stroke: LogoIntro.rippleStroke,
              ),
            ),
          ),
        Transform.scale(
          scale:
              LogoIntro.tileStartScale + (1 - LogoIntro.tileStartScale) * tile,
          child: Opacity(
            opacity: tile.clamp(0.0, 1.0),
            child: Stack(
              children: [
                _svg(IsharaLogo.tileAsset, size),
                layer(
                  IsharaLogo.bodyAsset,
                  body,
                  transform: Matrix4.translationValues(
                    0,
                    LogoIntro.bodyRise * k * (1 - body),
                    0,
                  ),
                ),
                layer(
                  IsharaLogo.crestAsset,
                  crest,
                  at: _align(_crestBase),
                  transform: Matrix4.identity()
                    ..rotateZ(
                      LogoIntro.crestStartTilt * math.pi / 180 * (1 - crest),
                    )
                    ..scaleByDouble(1, crest.clamp(0.0, 2.0), 1, 1),
                ),
                layer(
                  IsharaLogo.headAsset,
                  head,
                  at: _align(_headCentre),
                  transform: Matrix4.diagonal3Values(
                    LogoIntro.headStartScale +
                        (1 - LogoIntro.headStartScale) * head,
                    LogoIntro.headStartScale +
                        (1 - LogoIntro.headStartScale) * head,
                    1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RipplePainter extends CustomPainter {
  const _RipplePainter({
    required this.progress,
    required this.color,
    required this.stroke,
  });

  final double progress;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = 1 + (LogoIntro.rippleMaxScale - 1) * progress;
    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * scale,
      height: size.height * scale,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.width / 2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = color.withValues(alpha: 1 - progress),
    );
  }

  @override
  bool shouldRepaint(_RipplePainter old) =>
      old.progress != progress || old.color != color;
}
