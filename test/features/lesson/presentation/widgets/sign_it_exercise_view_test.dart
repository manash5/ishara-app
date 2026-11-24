import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/sign_it_exercise_view.dart';
import 'package:ishara_app/features/recognition/data/recognition_providers.dart';
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
        await pumpExercise(
          tester,
          view(stateOn<SignItExercise>()),
          mode: mode,
          camera: FakeCameraScenario.correct,
        );
        // The hand appears after a moment.
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('SIGN IT'), findsOneWidget);
        expect(find.text('Namaste'), findsOneWidget);
        expect(
          find.bySemanticsLabel('Reference video: Namaste'),
          findsOneWidget,
        );
        expect(find.byType(CameraFeed), findsOneWidget);
        final chip = statusChip(tester);
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
      final chip = statusChip(tester);
      expect(chip.label, 'Index finger');
      expect(chip.tone, IsharaChipTone.accent);
      final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
      expect(feed.overlay, HandOverlayStyle.hint);
    });
  }

  testWidgets('no hand: the ghost target pose and a friendly chip', (
    tester,
  ) async {
    await pumpExercise(tester, view(stateOn<SignItExercise>()));
    await tester.pump(const Duration(milliseconds: 400));
    final chip = statusChip(tester);
    expect(chip.label, 'Show your hand in the frame');
    final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
    expect(feed.landmarks, isNull);
    expect(feed.overlay, HandOverlayStyle.ghost);
  });

  testWidgets('the live hand is drawn over the feed', (tester) async {
    await pumpExercise(
      tester,
      view(stateOn<SignItExercise>()),
      camera: FakeCameraScenario.correct,
    );
    await tester.pump(const Duration(milliseconds: 400));
    final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
    expect(feed.landmarks, hasLength(21));
    expect(find.byKey(const Key('recognition-debug-stats')), findsOneWidget);
  });

  for (final (scenario, outcome) in const [
    (FakeCameraScenario.correct, CameraOutcome.correct),
    (FakeCameraScenario.almost, CameraOutcome.almost),
    (FakeCameraScenario.wrong, CameraOutcome.wrong),
  ]) {
    testWidgets('the pipeline scores ${scenario.name} → $outcome', (
      tester,
    ) async {
      final results = <CameraOutcome>[];
      await pumpExercise(
        tester,
        view(stateOn<SignItExercise>(), onResult: results.add),
        camera: scenario,
      );
      await tester.pump(const Duration(seconds: 4));
      expect(results, [outcome]);
    });
  }

  testWidgets('almost from the pipeline highlights the weakest finger', (
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
      camera: FakeCameraScenario.almost,
    );
    // Feedback phase: the session still scores, the view shows the finger.
    await tester.pump(const Duration(seconds: 4));
    final feed = tester.widget<CameraFeed>(find.byType(CameraFeed));
    expect(feed.overlay, HandOverlayStyle.hint);
    expect(feed.highlighted, HandFinger.indexFinger.landmarks);
  });

  testWidgets('skip calls back; no result while a sheet shows', (tester) async {
    var skipped = 0;
    final results = <CameraOutcome>[];
    await pumpExercise(
      tester,
      view(
        stateOn<SignItExercise>(
          phase: LessonPhase.feedback,
          feedback: FeedbackResult.correct,
        ),
        onSkip: () => skipped++,
        onResult: results.add,
      ),
      camera: FakeCameraScenario.correct,
    );
    await tester.tap(find.text('Can’t use the camera now'));
    await tester.pump(const Duration(seconds: 4));
    expect(skipped, 1);
    expect(results, isEmpty);
  });
}
