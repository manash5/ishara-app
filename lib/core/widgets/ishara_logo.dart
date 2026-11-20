import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `Logo/Mark` | `Logo/Lockup`.
enum IsharaLogoVariant { mark, lockup }

/// The Ishara logo: Danu's head mark (SVG artwork exported from Figma), or
/// the lockup with the "ishara" wordmark.
class IsharaLogo extends StatelessWidget {
  const IsharaLogo({super.key, this.variant = IsharaLogoVariant.mark});

  static const String markAsset = 'assets/brand/logo_mark.svg';

  final IsharaLogoVariant variant;

  @override
  Widget build(BuildContext context) {
    final Widget logo = switch (variant) {
      IsharaLogoVariant.mark => _mark(IsharaSizes.logoMark),
      IsharaLogoVariant.lockup => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _mark(IsharaSizes.logoLockupMark),
          const SizedBox(width: IsharaSizes.logoLockupGap),
          // Figma: 26 ExtraBold — headline/small at w800.
          Text(
            'ishara',
            style: context.textStyles.headlineSmall.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
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

  Widget _mark(double size) => SvgPicture.asset(
    markAsset,
    width: size,
    height: size,
    excludeFromSemantics: true,
  );
}
