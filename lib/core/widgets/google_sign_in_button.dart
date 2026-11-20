import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Figma `GoogleSignInButton`: outlined button with the Google "G" mark.
///
/// Disabled when [onPressed] is null.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.label = 'Continue with Google',
  });

  static const String logoAsset = 'assets/brand/google_g.svg';

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      enabled: onPressed != null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: const ButtonStyle(
          minimumSize: WidgetStatePropertyAll(
            Size(double.infinity, IsharaSizes.controlHeight),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              logoAsset,
              width: IsharaSizes.iconMd,
              height: IsharaSizes.iconMd,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: IsharaSpacing.s3),
            Flexible(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
