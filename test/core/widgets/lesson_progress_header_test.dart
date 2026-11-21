import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  double widthFactor(WidgetTester tester) => tester
      .widget<FractionallySizedBox>(
        find.byKey(const ValueKey('lesson-progress-value')),
      )
      .widthFactor!;

  Widget header(double progress, {VoidCallback? onClose}) => SizedBox(
    width: 412,
    child: LessonProgressHeader(
      progress: progress,
      hearts: 5,
      onClose: onClose ?? () {},
    ),
  );

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('close, progress pill, hearts (${mode.name})', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(tester, header(0.4), mode: mode);
      await tester.pumpAndSettle();
      expect(
        IconTheme.of(tester.element(find.byIcon(IsharaIcons.close))).color,
        c.textSecondary,
      );
      expect(widthFactor(tester), closeTo(0.4, 1e-9));
      final track = tester.widget<ColoredBox>(
        find.descendant(
          of: find.byType(LessonProgressHeader),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(track.color, c.borderDefault);
      final value =
          tester
                  .widget<DecoratedBox>(
                    find.descendant(
                      of: find.byKey(const ValueKey('lesson-progress-value')),
                      matching: find.byType(DecoratedBox),
                    ),
                  )
                  .decoration
              as BoxDecoration;
      expect(value.color, c.accentDefault);
      expect(textColor(tester, '5'), c.dangerDefault);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Lesson progress')),
        matchesSemantics(label: 'Lesson progress', value: '40%'),
      );
      expect(find.bySemanticsLabel('5 hearts left'), findsOneWidget);
      expect(
        tester.getSize(find.byType(LessonProgressHeader)).height,
        IsharaSizes.lessonHeaderHeight,
      );
      handle.dispose();
    });
  }

  testWidgets('progress animates in standard; close fires', (tester) async {
    var closes = 0;
    await pumpThemed(tester, header(0.2, onClose: () => closes++));
    await tester.pumpAndSettle();
    await pumpThemed(tester, header(0.8, onClose: () => closes++));
    await tester.pump(IsharaMotion.standard ~/ 2);
    expect(widthFactor(tester), inExclusiveRange(0.2, 0.8));
    await tester.pumpAndSettle();
    expect(widthFactor(tester), closeTo(0.8, 1e-9));
    await tester.tap(find.byIcon(IsharaIcons.close));
    await tester.pumpAndSettle();
    expect(closes, 1);
  });

  testWidgets('progress is clamped to 0–1', (tester) async {
    await pumpThemed(tester, header(1.7));
    await tester.pumpAndSettle();
    expect(widthFactor(tester), 1);
  });
}
