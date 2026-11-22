import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/lesson_tip_card.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/watch_exercise_view.dart';

import '../../../../helpers/pump_themed.dart';
import '../lesson_test_utils.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('shows the new sign, its video, description and tip '
        '(${mode.name})', (tester) async {
      final e = fakeExercise<WatchExercise>();
      await pumpExercise(tester, WatchExerciseView(exercise: e), mode: mode);
      expect(find.text('NEW SIGN'), findsOneWidget);
      expect(textColor(tester, 'NEW SIGN'), c.accentText);
      expect(find.text('Thank you'), findsOneWidget);
      expect(textColor(tester, 'Thank you'), c.textPrimary);
      expect(find.text('Watch closely, then try it yourself.'), findsOneWidget);
      expect(find.text(e.description), findsOneWidget);
      expect(textColor(tester, e.description), c.textSecondary);
      expect(find.byType(LessonTipCard), findsOneWidget);
      expect(find.text(e.tip), findsOneWidget);
      expect(
        tester.widget<Icon>(find.byIcon(IsharaIcons.lightbulb)).color,
        c.accentText,
      );
      expect(find.bySemanticsLabel('Sign video: Thank you'), findsOneWidget);
    });
  }

  testWidgets('slow motion and mirror toggle on the video', (tester) async {
    await pumpExercise(
      tester,
      WatchExerciseView(exercise: fakeExercise<WatchExercise>()),
    );
    SignVideoPlayer player() =>
        tester.widget<SignVideoPlayer>(find.byType(SignVideoPlayer));
    expect(player().slowMotion, isFalse);
    await tester.tap(find.bySemanticsLabel('Slow motion'));
    await tester.pump();
    expect(player().slowMotion, isTrue);
    await tester.tap(find.bySemanticsLabel('Mirror video'));
    await tester.pump();
    expect(player().mirrored, isTrue);
  });
}
