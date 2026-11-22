import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/recognise_exercise_view.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';
import '../lesson_test_utils.dart';

void main() {
  final e = fakeExercise<RecogniseExercise>();

  Widget view(LessonPlayerState s, {ValueChanged<int>? onSelect}) =>
      RecogniseExerciseView(
        exercise: e,
        state: s,
        onSelect: onSelect ?? (_) {},
      );

  AnswerState stateOf(WidgetTester tester, String label) => tester
      .widget<AnswerOption>(find.widgetWithText(AnswerOption, label))
      .state;

  for (final mode in themeModes) {
    testWidgets('prompt, video and four options; tap selects (${mode.name})', (
      tester,
    ) async {
      int? picked;
      await pumpExercise(
        tester,
        view(stateOn<RecogniseExercise>(), onSelect: (i) => picked = i),
        mode: mode,
      );
      expect(find.text('RECOGNISE'), findsOneWidget);
      expect(find.text('What does this sign mean?'), findsOneWidget);
      // The video must not give the answer away.
      expect(find.bySemanticsLabel('Sign video'), findsOneWidget);
      expect(find.byType(AnswerOption), findsNWidgets(4));
      await tester.tap(find.text('Hello'));
      expect(picked, 2);
    });

    testWidgets('selected option is lavender (${mode.name})', (tester) async {
      await pumpExercise(
        tester,
        view(stateOn<RecogniseExercise>(selected: 0)),
        mode: mode,
      );
      expect(stateOf(tester, 'Thank you'), AnswerState.selected);
      expect(stateOf(tester, 'Sorry'), AnswerState.idle);
    });
  }

  testWidgets('correct check (20): the answer turns success; options lock', (
    tester,
  ) async {
    var taps = 0;
    await pumpExercise(
      tester,
      view(
        stateOn<RecogniseExercise>(
          selected: 0,
          phase: LessonPhase.feedback,
          feedback: FeedbackResult.correct,
        ),
        onSelect: (_) => taps++,
      ),
    );
    expect(stateOf(tester, 'Thank you'), AnswerState.correct);
    await tester.tap(find.text('Sorry'));
    expect(taps, 0);
  });

  testWidgets('wrong check: the pick shakes in danger, the answer shows', (
    tester,
  ) async {
    await pumpExercise(
      tester,
      view(stateOn<RecogniseExercise>(selected: 1)),
      disableAnimations: false,
    );
    await pumpExercise(
      tester,
      view(
        stateOn<RecogniseExercise>(
          selected: 1,
          phase: LessonPhase.feedback,
          feedback: FeedbackResult.incorrect,
        ),
      ),
      disableAnimations: false,
    );
    expect(stateOf(tester, 'Sorry'), AnswerState.wrong);
    expect(stateOf(tester, 'Thank you'), AnswerState.correct);
    await tester.pump(IsharaMotion.shakeDuration ~/ 4);
    final shake = find.descendant(
      of: find.widgetWithText(AnswerOption, 'Sorry'),
      matching: find.byType(Transform),
    );
    final dx = tester
        .widget<Transform>(shake.first)
        .transform
        .getTranslation()
        .x;
    expect(dx, isNot(0));
    await tester.pumpAndSettle();
  });
}
