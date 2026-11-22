import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/game_rules.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_dto.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/camera_exercise_layout.dart';
import 'package:ishara_app/features/recognition/data/recognition_providers.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/mock_api.dart';

/// The fixture lesson's exercises (one of each type, in Figma order).
List<Exercise> fakeExercises() =>
    LessonDto.fromJson(fixtureData('lessons/get_200')).toEntity().exercises;

/// The first exercise of type [T] in the fake lesson.
T fakeExercise<T extends Exercise>() => fakeExercises().whereType<T>().first;

/// A player state sitting on the exercise of type [T].
LessonPlayerState stateOn<T extends Exercise>({
  int? selected,
  LessonPhase phase = LessonPhase.answering,
  FeedbackResult? feedback,
  MatchProgress match = const MatchProgress(),
  int letterIndex = 0,
  CameraOutcome? cameraOutcome,
}) {
  final exercises = fakeExercises();
  return LessonPlayerState(
    exercises: exercises,
    index: exercises.indexWhere((e) => e is T),
    hearts: GameRules.maxHearts,
    selected: selected,
    phase: phase,
    feedback: feedback,
    match: match,
    letterIndex: letterIndex,
    cameraOutcome: cameraOutcome,
  );
}

/// A Figma-sized phone (412 × 915 dp).
void usePhoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1081.5, 2401.875);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
}

/// Pumps an exercise view full-screen in the Ishara theme ([mode]).
Future<void> pumpExercise(
  WidgetTester tester,
  Widget child, {
  ThemeMode mode = ThemeMode.light,
  bool disableAnimations = true,
  FakeCameraScenario camera = FakeCameraScenario.noHand,
}) async {
  usePhoneSize(tester);
  await tester.pumpWidget(
    // Camera exercises run the recognition pipeline on the fake camera;
    // [camera] picks what it shows (no hand by default: no results).
    ProviderScope(
      overrides: [
        ...mockApiOverrides(),
        fakeCameraSettingsProvider.overrideWithBuild((ref, _) => camera),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(disableAnimations: disableAnimations),
            child: Scaffold(body: child),
          ),
        ),
      ),
    ),
  );
  // Camera sessions read the profile: let its mock request finish (no
  // camera frames yet; those need time to pass).
  await pumpApi(tester);
}

/// The camera exercise's status chip (not the debug fps / latency chip).
IsharaChip statusChip(WidgetTester tester) => tester.widget<IsharaChip>(
  find.descendant(
    of: find.byKey(CameraExerciseLayout.statusKey),
    matching: find.byType(IsharaChip),
  ),
);
