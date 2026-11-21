import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'hand_landmark_painter.dart';
import 'src/silhouette.dart';

/// Figma `CameraFeed` (flat): the front-camera preview on bg/camera with the
/// hand-landmark overlay ([HandOverlayStyle] live | hint | ghost).
///
/// The camera plugin sits behind an interface in the feature layer and is
/// injected as [preview]. Until then a Figma placeholder silhouette is shown.
/// Privacy: frames and landmarks are only displayed — nothing here stores,
/// uploads or logs them. Camera screens always use the dark theme (ui.md).
class CameraFeed extends StatelessWidget {
  const CameraFeed({
    super.key,
    this.preview,
    this.landmarks,
    this.overlay = HandOverlayStyle.live,
    this.highlighted = const {},
    this.mirror = true,
    this.semanticLabel = 'Camera preview',
  });

  final Widget? preview;

  /// 21 normalised landmarks for the current frame, or null when no hand is
  /// detected. With no [preview] the Figma reference pose is shown instead.
  final List<Offset>? landmarks;
  final HandOverlayStyle overlay;
  final Set<int> highlighted;

  /// Front camera previews are mirrored.
  final bool mirror;
  final String semanticLabel;

  // Figma frame (412×560) the placeholder art was drawn on.
  static const double _artboardWidth = 412;
  static const double _artboardHeight = 560;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final Widget overlayLayer;
    if (landmarks != null) {
      overlayLayer = HandLandmarkOverlay(
        landmarks: landmarks!,
        style: overlay,
        highlighted: highlighted,
        mirror: mirror,
      );
    } else if (preview == null) {
      // Placeholder: the Figma reference hand in its Figma position.
      final box = overlay == HandOverlayStyle.ghost
          ? const Rect.fromLTWH(180, 60, 250, 300)
          : const Rect.fromLTWH(190, 70, 240, 288);
      overlayLayer = LayoutBuilder(
        builder: (context, constraints) {
          final k = constraints.maxWidth / _artboardWidth;
          return Stack(
            children: [
              Positioned(
                left: box.left * k,
                top: box.top * k,
                width: box.width * k,
                height: box.height * k,
                child: HandLandmarkOverlay(
                  style: overlay,
                  highlighted: overlay == HandOverlayStyle.hint
                      ? (highlighted.isEmpty
                            ? HandFinger.indexFinger.landmarks
                            : highlighted)
                      : const {},
                ),
              ),
            ],
          );
        },
      );
    } else {
      overlayLayer = const SizedBox.shrink();
    }

    return Semantics(
      container: true,
      image: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: ColoredBox(
        color: c.bgCamera,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (preview != null)
                Transform.flip(flipX: mirror, child: preview)
              else
                AspectRatio(
                  aspectRatio: _artboardWidth / _artboardHeight,
                  child: CustomPaint(
                    painter: SilhouettePainter(
                      color: c.staticWhite.withValues(
                        alpha: IsharaSizes.placeholderOpacity,
                      ),
                      artboardWidth: _artboardWidth,
                      head: const Rect.fromLTWH(92, 161, 168, 168),
                      body: const Rect.fromLTWH(-5, 363, 361, 197),
                    ),
                  ),
                ),
              overlayLayer,
            ],
          ),
        ),
      ),
    );
  }
}
