import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/sign_it_exercise_view.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_themed.dart';
import '../lesson_test_utils.dart';

void main() {
  final e = fakeExercise<SignItExercise>();

  Widget view(
    LessonPlayerState s, {
    VoidCallback? onSkip,
    ValueChanged<CameraOutcome>? onResult,
  }) => SignItExerciseView(
    exercise: e,
    state: s,
    onSkip: onSkip ?? () {},
    onResult: onResult ?? (_) {},
  );

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets(
      '23: prompt, reference video, camera and footer (${mode.name})',
      (tester) async {
        await pumpExercise(tester, view(stateOn<SignItExercise>()), mode: mode);
        expect(find.text('SIGN IT'), findsOneWidget);
        expect(find.text('Namaste'), findsOneWidget);
        expect(
          find.bySemanticsLabel('Reference video: Namaste'),
          findsOneWidget,
        );
        expect(find.byType(CameraFeed), findsOneWidget);
        final chip = tester.widget<IsharaChip>(find.byType(IsharaChip));
        expect(chip.label, 'Hand detected');
        expect(chip.tone, IsharaChipTone.success);
        expect(find.text('Hold the sign for 1 second'), findsOneWidget);
        expect(textColor(tester, 'Can’t use the camera now'), c.accentText);
        final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
        expect(feed.overlay, HandOverlayStyle.live);
      },
    );

    testWidgets('24 almost: hint overlay and the finger chip (${mode.name})', (
      tester,
    ) async {
      await pumpExercise(
        tester,
        view(
          stateOn<SignItExercise>(
            phase: LessonPhase.feedback,
            feedback: FeedbackResult.almost,
            cameraOutcome: CameraOutcome.almost,
          ),
        ),
        mode: mode,
      );
      final chip = tester.widget<IsharaChip>(find.byType(IsharaChip));
      expect(chip.label, 'Index finger');
      expect(chip.tone, IsharaChipTone.accent);
      final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
      expect(feed.overlay, HandOverlayStyle.hint);
    });
  }

  testWidgets('skip and the fake results call back', (tester) async {
    var skipped = 0;
    final results = <CameraOutcome>[];
    await pumpExercise(
      tester,
      view(
        stateOn<SignItExercise>(),
        onSkip: () => skipped++,
        onResult: results.add,
      ),
    );
    await tester.tap(find.text('Can’t use the camera now'));
    await tester.tap(find.text('Simulate: correct'));
    await tester.tap(find.text('Simulate: almost'));
    expect(skipped, 1);
    expect(results, [CameraOutcome.correct, CameraOutcome.almost]);
  });

  testWidgets('fake results are disabled while a sheet shows', (tester) async {
    final results = <CameraOutcome>[];
    await pumpExercise(
      tester,
      view(
        stateOn<SignItExercise>(
          phase: LessonPhase.feedback,
          feedback: FeedbackResult.correct,
        ),
        onResult: results.add,
      ),
    );
    await tester.tap(find.text('Simulate: correct'), warnIfMissed: false);
    expect(results, isEmpty);
  });
}
