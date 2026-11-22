import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/game_rules.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/fake_lesson_provider.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:material_ui/material_ui.dart';

/// The fake lesson's exercises (one of each type, in Figma order).
List<Exercise> fakeExercises() {
  final c = ProviderContainer();
  try {
    return c.read(fakeLessonProvider('test')).exercises;
  } finally {
    c.dispose();
  }
}

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
}) async {
  usePhoneSize(tester);
  await tester.pumpWidget(
    MaterialApp(
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
  );
}
