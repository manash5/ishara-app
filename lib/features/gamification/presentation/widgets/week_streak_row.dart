import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/weekdays.dart';

/// Figma 27 `week`: Monday→Sunday, each day a label and a 32dp circle —
/// accent with a check when practised, surface-muted otherwise. Today's
/// label is text/primary.
class WeekStreakRow extends StatelessWidget {
  const WeekStreakRow({
    super.key,
    required this.practised,
    required this.todayIndex,
  });

  /// Seven values, Monday first.
  final List<bool> practised;
  final int todayIndex;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
      decoration: BoxDecoration(
        color: c.bgSurface,
        borderRadius: IsharaRadius.brLg,
        border: Border.all(color: c.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < Weekdays.initials.length; i++)
            Semantics(
              container: true,
              label:
                  '${Weekdays.names[i]}, '
                  '${practised[i] ? 'practised' : 'not practised'}'
                  '${i == todayIndex ? ', today' : ''}',
              excludeSemantics: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Weekdays.initials[i],
                    style: context.textStyles.labelMedium.copyWith(
                      color: i == todayIndex ? c.textPrimary : c.textTertiary,
                    ),
                  ),
                  const SizedBox(height: IsharaSizes.streakDayGap),
                  Container(
                    width: IsharaSizes.streakDay,
                    height: IsharaSizes.streakDay,
                    decoration: BoxDecoration(
                      color: practised[i] ? c.accentDefault : c.bgSurfaceMuted,
                      shape: BoxShape.circle,
                    ),
                    child: practised[i]
                        ? Icon(
                            IsharaIcons.check,
                            size: IsharaSizes.iconSm,
                            color: c.textOnAccent,
                          )
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
