import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/pick_sign_exercise_view.dart';

import '../../../../helpers/pump_themed.dart';
import '../lesson_test_utils.dart';

void main() {
  final e = fakeExercise<PickSignExercise>();

  List<AnswerState> states(WidgetTester tester) => tester
      .widgetList<VideoOption>(find.byType(VideoOption))
      .map((o) => o.state)
      .toList();

  for (final mode in themeModes) {
    testWidgets('a 2×2 grid of videos for the meaning (${mode.name})', (
      tester,
    ) async {
      int? picked;
      await pumpExercise(
        tester,
        PickSignExerciseView(
          exercise: e,
          state: stateOn<PickSignExercise>(),
          onSelect: (i) => picked = i,
        ),
        mode: mode,
      );
      expect(find.text('PICK THE SIGN'), findsOneWidget);
      expect(find.text('Which sign means “Sorry”?'), findsOneWidget);
      expect(find.byType(VideoOption), findsNWidgets(4));
      // Two per row.
      final first = tester.getTopLeft(find.byType(VideoOption).at(0));
      final second = tester.getTopLeft(find.byType(VideoOption).at(1));
      final third = tester.getTopLeft(find.byType(VideoOption).at(2));
      expect(second.dy, first.dy);
      expect(third.dy, greaterThan(first.dy));
      // Options never name the sign.
      expect(find.bySemanticsLabel('Option 2'), findsOneWidget);
      await tester.tap(find.byType(VideoOption).at(1));
      expect(picked, 1);
    });
  }

  testWidgets('selected, then correct after the check', (tester) async {
    await pumpExercise(
      tester,
      PickSignExerciseView(
        exercise: e,
        state: stateOn<PickSignExercise>(selected: 1),
        onSelect: (_) {},
      ),
    );
    expect(states(tester), [
      AnswerState.idle,
      AnswerState.selected,
      AnswerState.idle,
      AnswerState.idle,
    ]);
    await pumpExercise(
      tester,
      PickSignExerciseView(
        exercise: e,
        state: stateOn<PickSignExercise>(
          selected: 3,
          phase: LessonPhase.feedback,
          feedback: FeedbackResult.incorrect,
        ),
        onSelect: (_) {},
      ),
    );
    expect(states(tester), [
      AnswerState.idle,
      AnswerState.correct,
      AnswerState.idle,
      AnswerState.wrong,
    ]);
  });
}
