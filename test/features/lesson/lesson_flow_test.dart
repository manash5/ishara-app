import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/gamification/presentation/screens/out_of_hearts_screen.dart';
import 'package:ishara_app/features/gamification/presentation/screens/streak_screen.dart';
import 'package:ishara_app/features/learn/presentation/screens/learn_screen.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_providers.dart';
import 'package:ishara_app/features/lesson/presentation/screens/lesson_complete_screen.dart';
import 'package:ishara_app/features/lesson/presentation/screens/lesson_player_screen.dart';
import 'package:ishara_app/features/lesson/presentation/screens/quit_lesson_dialog.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/fingerspell_exercise_view.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/match_pairs_exercise_view.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/pick_sign_exercise_view.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/recognise_exercise_view.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/sign_it_exercise_view.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/watch_exercise_view.dart';

import '../../helpers/pump_app.dart';

/// The whole lesson flow through the real app: Learn → lesson sheet →
/// player (18–25) → Lesson complete (26) → Streak (27) → Learn, plus quit
/// (29) and out of hearts (28).
void main() {
  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> openLesson(WidgetTester tester, {int? hearts}) async {
    await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const LearnRoute().location,
      overrides: [
        if (hearts != null) startingHeartsProvider.overrideWithValue(hearts),
      ],
    );
    // The trek's Start button sits above the bottom bar: tap it in place.
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start lesson'));
    await tester.pumpAndSettle();
    expect(find.byType(LessonPlayerScreen), findsOneWidget);
    expect(find.byType(WatchExerciseView), findsOneWidget);
  }

  Finder sheetButton(String label) => find.descendant(
    of: find.byType(FeedbackSheet),
    matching: find.text(label),
  );

  Future<void> checkAndContinue(WidgetTester tester) async {
    await tapAndSettle(tester, find.text('Check'));
    expect(find.text('Nicely done!'), findsOneWidget);
    await tapAndSettle(tester, sheetButton('Continue'));
  }

  testWidgets('one exercise of each type → 26 → 27 → Learn', (tester) async {
    await openLesson(tester);

    // 18 Watch & learn.
    await tapAndSettle(tester, find.text('Continue'));

    // 19/20 Recognise.
    expect(find.byType(RecogniseExerciseView), findsOneWidget);
    await tapAndSettle(tester, find.text('Thank you'));
    await checkAndContinue(tester);

    // 21 Pick the sign.
    expect(find.byType(PickSignExerciseView), findsOneWidget);
    await tapAndSettle(tester, find.byType(VideoOption).at(1));
    await checkAndContinue(tester);

    // 22 Match pairs: Check is disabled until every pair is matched.
    expect(find.byType(MatchPairsExerciseView), findsOneWidget);
    for (final (row, word) in ['Hello', 'Please', 'Sorry'].indexed) {
      await tapAndSettle(tester, find.text(word));
      await tapAndSettle(tester, find.byType(VideoOption).at(row));
    }
    await checkAndContinue(tester);

    // 23 Sign it.
    expect(find.byType(SignItExerciseView), findsOneWidget);
    await tapAndSettle(tester, find.text('Simulate: correct'));
    await tapAndSettle(tester, sheetButton('Continue'));

    // 25 Fingerspell: one result per letter.
    expect(find.byType(FingerspellExerciseView), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tapAndSettle(tester, find.text('Simulate: correct'));
    }
    await tapAndSettle(tester, sheetButton('Continue'));

    // 26 → 27 → Learn.
    expect(find.byType(LessonCompleteScreen), findsOneWidget);
    expect(find.text('+15'), findsOneWidget);
    await tapAndSettle(tester, find.text('Continue'));
    expect(find.byType(StreakScreen), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    await tapAndSettle(tester, find.text('Continue'));
    expect(find.byType(LearnScreen), findsOneWidget);
  });

  testWidgets('Android back asks to quit (29); Keep learning stays', (
    tester,
  ) async {
    await openLesson(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(QuitLessonDialog), findsOneWidget);
    expect(find.text('Quit this lesson?'), findsOneWidget);
    await tapAndSettle(tester, find.text('Keep learning'));
    expect(find.byType(QuitLessonDialog), findsNothing);
    expect(find.byType(WatchExerciseView), findsOneWidget);
  });

  testWidgets('close button → Quit returns to Learn', (tester) async {
    await openLesson(tester);
    await tapAndSettle(tester, find.byTooltip('Close lesson'));
    expect(find.byType(QuitLessonDialog), findsOneWidget);
    await tapAndSettle(tester, find.text('Quit'));
    expect(find.byType(LearnScreen), findsOneWidget);
  });

  testWidgets('a wrong answer on the last heart opens 28; End lesson → Learn', (
    tester,
  ) async {
    await openLesson(tester, hearts: 1);
    await tapAndSettle(tester, find.text('Continue'));
    await tapAndSettle(tester, find.text('Sorry'));
    await tapAndSettle(tester, find.text('Check'));
    expect(find.byType(OutOfHeartsPanel), findsOneWidget);
    expect(find.text('You’re out of hearts'), findsOneWidget);
    // The learner must choose: back doesn't close it.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(OutOfHeartsPanel), findsOneWidget);
    await tapAndSettle(tester, find.text('End lesson'));
    expect(find.byType(LearnScreen), findsOneWidget);
  });

  testWidgets('/out-of-hearts shows the same panel full-screen', (
    tester,
  ) async {
    await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const OutOfHeartsRoute().location,
    );
    expect(find.byType(OutOfHeartsScreen), findsOneWidget);
    expect(find.byType(OutOfHeartsPanel), findsOneWidget);
    await tapAndSettle(tester, find.text('End lesson'));
    expect(find.byType(LearnScreen), findsOneWidget);
  });
}
