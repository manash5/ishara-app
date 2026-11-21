import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// Figma `or` row (7:189 / 7:264): border/default hairlines around a
/// body/small text/tertiary "or".
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget line() => Expanded(child: Divider(color: c.borderDefault));
    return Row(
      children: [
        line(),
        const SizedBox(width: IsharaSpacing.s3),
        Text(
          'or',
          style: context.textStyles.bodySmall.copyWith(color: c.textTertiary),
        ),
        const SizedBox(width: IsharaSpacing.s3),
        line(),
      ],
    );
  }
}
