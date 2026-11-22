import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/weekdays.dart';

// TODO(core): Figma `xpChart` (node 12:1396) has no shared widget or size
// tokens yet — these mirror the Figma frame until core adds them.
const double _barAreaHeight = 74; // 128 card − 2×16 padding − 16 label − 6 gap
const double _barWidth = 22;
const double _barRadius = 6;
const double _labelGap = 6;

/// Figma "16 Profile" → `thisWeek/xpChart`: seven daily XP bars, today in
/// accent, the rest in bg/surface-muted.
class WeeklyXpChart extends StatelessWidget {
  const WeeklyXpChart({
    super.key,
    required this.weeklyXp,
    required this.todayIndex,
  }) : assert(weeklyXp.length == 7);

  /// XP per day, Monday first.
  final List<int> weeklyXp;
  final int todayIndex;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final peak = math.max(1, weeklyXp.reduce(math.max));
    final summary = [
      for (var i = 0; i < 7; i++)
        '${Weekdays.names[i]}${i == todayIndex ? ' (today)' : ''} ${weeklyXp[i]} XP',
    ].join(', ');

    return Semantics(
      container: true,
      label: 'XP this week: $summary',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
        decoration: BoxDecoration(
          color: c.bgSurface,
          borderRadius: IsharaRadius.brLg,
          border: Border.all(color: c.borderSubtle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < 7; i++)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: _barAreaHeight,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: IsharaMotion.duration(
                          context,
                          IsharaMotion.standard,
                        ),
                        curve: IsharaMotion.move,
                        width: _barWidth,
                        height: _barAreaHeight * weeklyXp[i] / peak,
                        decoration: BoxDecoration(
                          color: i == todayIndex
                              ? c.accentDefault
                              : c.bgSurfaceMuted,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(_barRadius),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: _labelGap),
                  Text(
                    Weekdays.initials[i],
                    style: s.labelMedium.copyWith(
                      color: i == todayIndex ? c.textPrimary : c.textTertiary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
