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
  });

  final DanuPose pose;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      image: true,
      label: 'Danu the Danphe, ${pose.description}',
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: AnimatedSwitcher(
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
