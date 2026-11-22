import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/fingerspell_exercise_view.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/fingerspell_letter_tile.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';
import '../lesson_test_utils.dart';

void main() {
  final e = fakeExercise<FingerspellExercise>();

  Widget view(
    LessonPlayerState s, {
    VoidCallback? onSkip,
    ValueChanged<CameraOutcome>? onResult,
  }) => FingerspellExerciseView(
    exercise: e,
    state: s,
    onSkip: onSkip ?? () {},
    onResult: onResult ?? (_) {},
  );

  List<LetterTileState> tiles(WidgetTester tester) => tester
      .widgetList<FingerspellLetterTile>(find.byType(FingerspellLetterTile))
      .map((t) => t.state)
      .toList();

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('25: word, letters done/current/todo, chips (${mode.name})', (
      tester,
    ) async {
      await pumpExercise(
        tester,
        view(stateOn<FingerspellExercise>(letterIndex: 1)),
        mode: mode,
      );
      expect(find.text('FINGERSPELL'), findsOneWidget);
      expect(find.text('कमल  ·  lotus'), findsOneWidget);
      expect(tiles(tester), [
        LetterTileState.done,
        LetterTileState.current,
        LetterTileState.todo,
      ]);
      expect(textColor(tester, 'क'), c.successDefault);
      expect(textColor(tester, 'म'), c.textOnAccent);
      expect(textColor(tester, 'ल'), c.textTertiary);
      expect(find.text('Works offline'), findsOneWidget);
      expect(find.text('Letter म — hold still'), findsOneWidget);
      expect(find.text('Can’t use the camera now'), findsOneWidget);
      // No hint line on 25.
      expect(find.text('Hold the sign for 1 second'), findsNothing);
    });
  }

  testWidgets('every letter is done once the word is correct', (tester) async {
    await pumpExercise(
      tester,
      view(
        stateOn<FingerspellExercise>(
          letterIndex: 2,
          phase: LessonPhase.feedback,
          feedback: FeedbackResult.correct,
        ),
      ),
    );
    expect(tiles(tester), everyElement(LetterTileState.done));
  });

  testWidgets('skip and fake results call back', (tester) async {
    var skipped = 0;
    final results = <CameraOutcome>[];
    await pumpExercise(
      tester,
      view(
        stateOn<FingerspellExercise>(),
        onSkip: () => skipped++,
        onResult: results.add,
      ),
    );
    await tester.tap(find.text('Can’t use the camera now'));
    await tester.tap(find.text('Simulate: correct'));
    expect(skipped, 1);
    expect(results, [CameraOutcome.correct]);
  });
}
