import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'hand_landmark_painter.dart';
import 'src/silhouette.dart';

/// Figma `SignVideoPlayer` → `size`.
enum SignVideoSize { large, tile }

/// Figma `SignVideoPlayer` (flat): a muted, looping sign video with replay,
/// slow-motion and mirror controls (`large`), or a compact tile with a play
/// badge (`tile`, used inside [VideoOption]).
///
/// The actual player is injected as [video] (the video plugin sits behind an
/// interface in the feature layer). Until then a placeholder signer from
/// Figma is shown. [mirrored] flips the video horizontally.
class SignVideoPlayer extends StatelessWidget {
  const SignVideoPlayer({
    super.key,
    required this.semanticLabel,
    this.video,
    this.size = SignVideoSize.large,
    this.mirrored = false,
    this.slowMotion = false,
    this.onReplay,
    this.onToggleSlowMotion,
    this.onToggleMirror,
    this.borderRadius,
    this.unavailableMessage,
  });

  /// What the video shows, e.g. "Sign video". Never describe the NSL sign
  /// itself here unless the text is verified (CLAUDE.md content rule).
  final String semanticLabel;
  final Widget? video;
  final SignVideoSize size;
  final bool mirrored;
  final bool slowMotion;
  final VoidCallback? onReplay;
  final VoidCallback? onToggleSlowMotion;
  final VoidCallback? onToggleMirror;

  /// Overrides the Figma radius (xl for large, lg for tile), e.g. md inside
  /// a [VideoOption].
  final BorderRadius? borderRadius;

  /// When set, the video can't play (e.g. offline): this message replaces
  /// it, with a wifi-off icon, and the controls are hidden.
  final String? unavailableMessage;

  // Figma frames the placeholder art was drawn on.
  static const double _largeWidth = 364;
  static const double _largeHeight = 272;
  static const double _tileWidth = 170;
  static const double _tileHeight = 148;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final large = size == SignVideoSize.large;
    final radius =
        borderRadius ?? (large ? IsharaRadius.brXl : IsharaRadius.brLg);
    final w = large ? _largeWidth : _tileWidth;

    final placeholder = Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: SilhouettePainter(
            color: c.borderDefault,
            artboardWidth: w,
            head: large
                ? const Rect.fromLTWH(120, 84, 79, 79)
                : const Rect.fromLTWH(53, 46, 43, 43),
            body: large
                ? const Rect.fromLTWH(75, 179, 170, 93)
                : const Rect.fromLTWH(29, 98, 93, 51),
          ),
        ),
        LayoutBuilder(
          builder: (context, box) {
            final k = box.maxWidth / w;
            final hand = large
                ? const Rect.fromLTWH(200, 27, 120, 144)
                : const Rect.fromLTWH(94, 15, 64, 77);
            return Stack(
              children: [
                Positioned(
                  left: hand.left * k,
                  top: hand.top * k,
                  width: hand.width * k,
                  height: hand.height * k,
                  child: const HandLandmarkOverlay(),
                ),
              ],
            );
          },
        ),
      ],
    );

    final unavailable = unavailableMessage;
    final media = unavailable != null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(IsharaSpacing.s4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    IsharaIcons.wifiOff,
                    size: IsharaSizes.iconMd,
                    color: c.textSecondary,
                  ),
                  if (large) ...[
                    const SizedBox(height: IsharaSpacing.s2),
                    Text(
                      unavailable,
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )
        : Transform.flip(flipX: mirrored, child: video ?? placeholder);

    return Semantics(
      container: true,
      label: unavailable == null
          ? semanticLabel
          : '$semanticLabel. $unavailable',
      image: video == null && unavailable == null,
      child: AspectRatio(
        aspectRatio: large
            ? _largeWidth / _largeHeight
            : _tileWidth / _tileHeight,
        child: ClipRRect(
          borderRadius: radius,
          child: ColoredBox(
            color: c.bgSurfaceMuted,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ExcludeSemantics(child: media),
                if (unavailable != null)
                  const SizedBox.shrink()
                else if (large)
                  Positioned(
                    left: IsharaSpacing.s3,
                    bottom: IsharaSpacing.s3,
                    child: Row(
                      children: [
                        _Control(
                          tooltip: 'Replay',
                          onPressed: onReplay,
                          child: Icon(
                            IsharaIcons.rotateCcw,
                            size: IsharaSizes.videoControlIcon,
                            color: c.textPrimary,
                          ),
                        ),
                        _Control(
                          tooltip: slowMotion ? 'Normal speed' : 'Slow motion',
                          toggled: slowMotion,
                          wide: true,
                          onPressed: onToggleSlowMotion,
                          // Figma: a 0.5× toggle — the label stays, the
                          // on state is shown by fill and colour.
                          child: Text(
                            '0.5×',
                            style: context.textStyles.labelMedium.copyWith(
                              color: slowMotion ? c.accentText : c.textPrimary,
                            ),
                          ),
                        ),
                        _Control(
                          tooltip: 'Mirror video',
                          toggled: mirrored,
                          onPressed: onToggleMirror,
                          child: Icon(
                            IsharaIcons.flipHorizontal,
                            size: IsharaSizes.videoControlIcon,
                            color: mirrored ? c.accentText : c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  // The play badge scales with the tile, so a small tile
                  // (the 93.5dp reference video in Figma 23) keeps the
                  // Figma proportions.
                  LayoutBuilder(
                    builder: (context, box) {
                      final k = box.maxWidth.isFinite
                          ? box.maxWidth / _tileWidth
                          : 1.0;
                      final inset =
                          (IsharaSpacing.s2 + IsharaSizes.titleGap) * k;
                      return Stack(
                        children: [
                          Positioned(
                            left: inset,
                            bottom: inset,
                            child: ExcludeSemantics(
                              child: Container(
                                key: const ValueKey('video-tile-play'),
                                width: IsharaSizes.videoTilePlay * k,
                                height: IsharaSizes.videoTilePlay * k,
                                decoration: BoxDecoration(
                                  color: c.bgSurface,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: IsharaFilledIcon(
                                    IsharaFilledIconKind.play,
                                    size: IsharaSizes.videoTilePlayIcon * k,
                                    color: c.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A 40dp floating control (Figma) inside a 48dp touch target.
class _Control extends StatelessWidget {
  const _Control({
    required this.tooltip,
    required this.onPressed,
    required this.child,
    this.toggled,
    this.wide = false,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final Widget child;
  final bool? toggled;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final on = toggled ?? false;
    return Semantics(
      container: true,
      button: true,
      toggled: toggled,
      label: tooltip,
      onTap: onPressed,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox(
          width: wide
              ? IsharaSizes.controlHeight + IsharaSpacing.s2
              : IsharaSizes.minTouch,
          height: IsharaSizes.minTouch,
          child: Center(
            child: PressableScale(
              enabled: onPressed != null,
              child: Container(
                width: wide
                    ? IsharaSizes.controlHeight
                    : IsharaSizes.videoControl,
                height: IsharaSizes.videoControl,
                decoration: BoxDecoration(
                  color: on ? c.accentSubtle : c.bgSurface,
                  borderRadius: IsharaRadius.brFull,
                  boxShadow: IsharaElevation.level1,
                ),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
