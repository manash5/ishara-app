import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/fingerspell_exercise_view.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/fingerspell_letter_tile.dart';
import 'package:ishara_app/features/recognition/data/recognition_providers.dart';
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
        camera: FakeCameraScenario.correct,
      );
      await tester.pump(const Duration(milliseconds: 300));
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

  testWidgets('the pipeline spells क म ल: a result per letter', (tester) async {
    final results = <CameraOutcome>[];
    await pumpExercise(
      tester,
      view(stateOn<FingerspellExercise>(), onResult: results.add),
      camera: FakeCameraScenario.correct,
    );
    await tester.pump(const Duration(seconds: 5));
    // Two letters advance the word; the last ends it (correct sheet).
    expect(results, [
      CameraOutcome.correct,
      CameraOutcome.correct,
      CameraOutcome.correct,
    ]);
  });

  testWidgets('another letter held → almost', (tester) async {
    final results = <CameraOutcome>[];
    await pumpExercise(
      tester,
      view(stateOn<FingerspellExercise>(), onResult: results.add),
      camera: FakeCameraScenario.almost,
    );
    await tester.pump(const Duration(seconds: 3));
    expect(results, [CameraOutcome.almost]);
  });

  testWidgets('no hand: a friendly chip', (tester) async {
    await pumpExercise(tester, view(stateOn<FingerspellExercise>()));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Show your hand in the frame'), findsOneWidget);
  });

  testWidgets('skip calls back', (tester) async {
    var skipped = 0;
    await pumpExercise(
      tester,
      view(stateOn<FingerspellExercise>(), onSkip: () => skipped++),
    );
    await tester.tap(find.text('Can’t use the camera now'));
    expect(skipped, 1);
  });
}
