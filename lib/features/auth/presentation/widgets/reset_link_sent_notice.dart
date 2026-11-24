import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// Figma `sentNotice` (7:314): success/subtle card, radius lg, padding 16,
/// check icon (20, success/default) + body/medium success/text copy.
///
/// Fades in when it appears (motion.md: plain fade, `standard`).
// TODO(figma-gap): no shared inline notice/banner component; see report.
class ResetLinkSentNotice extends StatelessWidget {
  const ResetLinkSentNotice({super.key, this.message = defaultMessage});

  static const defaultMessage =
      'Code sent. Check your inbox — it expires in 1 hour.';

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: IsharaMotion.duration(context, IsharaMotion.standard),
      curve: IsharaMotion.enter,
      builder: (context, t, child) => Opacity(opacity: t, child: child),
      child: Semantics(
        liveRegion: true,
        container: true,
        child: Container(
          padding: const EdgeInsets.all(IsharaSpacing.s4),
          decoration: BoxDecoration(
            color: c.successSubtle,
            borderRadius: IsharaRadius.brLg,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                IsharaIcons.check,
                size: IsharaSizes.iconMd,
                color: c.successDefault,
              ),
              const SizedBox(width: IsharaSpacing.s3),
              Expanded(
                child: Text(
                  message,
                  style: context.textStyles.bodyMedium.copyWith(
                    color: c.successText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
