import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/game_rules.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_providers.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_player_provider.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/recognise_exercise_view.dart';
import 'package:ishara_app/features/lesson/presentation/widgets/sign_it_exercise_view.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/load_states.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  const lessonId = 'unit-1-lesson-2';
  late List<Object?> haptics;

  setUp(() {
    haptics = [];
    TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'HapticFeedback.vibrate') {
            haptics.add(call.arguments);
          }
          return null;
        });
  });

  Future<ProviderContainer> pumpPlayer(WidgetTester tester, {int? hearts}) =>
      pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const LessonRoute(lessonId: lessonId).location,
        overrides: [
          if (hearts != null) startingHeartsProvider.overrideWithValue(hearts),
        ],
      );

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  int heartsShown(WidgetTester tester) => tester
      .widget<LessonProgressHeader>(find.byType(LessonProgressHeader))
      .hearts;

  /// Moves the player straight to exercise [index] (0-based).
  Future<void> jumpTo(
    WidgetTester tester,
    ProviderContainer c,
    int index,
  ) async {
    final player = c.read(lessonPlayerProvider(lessonId).notifier);
    while (c.read(lessonPlayerProvider(lessonId)).index < index) {
      player.continueNext();
    }
    await tester.pumpAndSettle();
  }

  testWidgets('header shows full hearts and the footer Continue on 18', (
    tester,
  ) async {
    await pumpPlayer(tester);
    expect(heartsShown(tester), GameRules.maxHearts);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Check stays disabled until an answer is picked', (tester) async {
    await pumpPlayer(tester);
    await tapAndSettle(tester, find.text('Continue'));
    IsharaButton check() =>
        tester.widget<IsharaButton>(find.widgetWithText(IsharaButton, 'Check'));
    expect(check().onPressed, isNull);
    await tapAndSettle(tester, find.text('Sorry'));
    expect(check().onPressed, isNotNull);
  });

  testWidgets('wrong answer: "Not quite", one heart lost, medium haptic, '
      'the pick turns wrong', (tester) async {
    await pumpPlayer(tester);
    await tapAndSettle(tester, find.text('Continue'));
    await tapAndSettle(tester, find.text('Sorry'));
    haptics.clear();
    await tapAndSettle(tester, find.text('Check'));
    expect(find.text('Not quite'), findsOneWidget);
    expect(find.text('The answer is “Thank you”.'), findsOneWidget);
    expect(heartsShown(tester), GameRules.maxHearts - 1);
    expect(haptics, contains('HapticFeedbackType.mediumImpact'));
    final sorry = tester.widget<AnswerOption>(
      find.widgetWithText(AnswerOption, 'Sorry'),
    );
    expect(sorry.state, AnswerState.wrong);
    // "Got it" moves on.
    await tapAndSettle(tester, find.text('Got it'));
    expect(find.text('Which sign means “Sorry”?'), findsOneWidget);
  });

  testWidgets('correct answer: light haptic and the Figma 20 message', (
    tester,
  ) async {
    await pumpPlayer(tester);
    await tapAndSettle(tester, find.text('Continue'));
    await tapAndSettle(tester, find.text('Thank you'));
    haptics.clear();
    await tapAndSettle(tester, find.text('Check'));
    expect(find.text('Nicely done!'), findsOneWidget);
    expect(find.text('“Thank you” — +3 XP'), findsOneWidget);
    expect(haptics, contains('HapticFeedbackType.lightImpact'));
    expect(heartsShown(tester), GameRules.maxHearts);
  });

  testWidgets('a wrong match pair costs a heart and buzzes', (tester) async {
    final c = await pumpPlayer(tester);
    await jumpTo(tester, c, 3);
    haptics.clear();
    await tapAndSettle(tester, find.text('Hello'));
    await tapAndSettle(tester, find.byType(VideoOption).at(2));
    expect(heartsShown(tester), GameRules.maxHearts - 1);
    expect(haptics, contains('HapticFeedbackType.mediumImpact'));
  });

  group('camera exercises', () {
    testWidgets('use the dark theme', (tester) async {
      final c = await pumpPlayer(tester);
      await jumpTo(tester, c, 4);
      expect(find.byType(SignItExerciseView), findsOneWidget);
      final context = tester.element(find.byType(SignItExerciseView));
      expect(Theme.of(context).brightness, Brightness.dark);
      expect(context.colors, IsharaColors.dark);
    });

    testWidgets('almost (24) never costs a heart; Try again retries', (
      tester,
    ) async {
      final c = await pumpPlayer(tester);
      await jumpTo(tester, c, 4);
      await tapAndSettle(tester, find.text('Simulate: almost'));
      expect(find.text('Almost there'), findsOneWidget);
      expect(
        find.text('Curl your index finger toward your palm.'),
        findsOneWidget,
      );
      expect(heartsShown(tester), GameRules.maxHearts);
      // The almost sheet is dark too (it follows the camera theme).
      final sheet = tester.element(find.byType(FeedbackSheet));
      expect(sheet.colors, IsharaColors.dark);
      await tapAndSettle(tester, find.text('Try again'));
      expect(find.byType(FeedbackSheet), findsNothing);
      expect(find.byType(SignItExerciseView), findsOneWidget);
      expect(heartsShown(tester), GameRules.maxHearts);
    });

    testWidgets("Can't use the camera now swaps in a recognise exercise", (
      tester,
    ) async {
      final c = await pumpPlayer(tester);
      await jumpTo(tester, c, 4);
      await tapAndSettle(tester, find.text('Can’t use the camera now'));
      expect(find.byType(SignItExerciseView), findsNothing);
      expect(find.byType(RecogniseExerciseView), findsOneWidget);
      expect(find.text('Namaste'), findsOneWidget);
      // Back in the light theme, no penalty.
      final context = tester.element(find.byType(RecogniseExerciseView));
      expect(Theme.of(context).brightness, Brightness.light);
      expect(heartsShown(tester), GameRules.maxHearts);
      // The fingerspelling exercise after it is swapped too.
      await tapAndSettle(tester, find.text('Namaste'));
      await tapAndSettle(tester, find.text('Check'));
      await tapAndSettle(tester, find.text('Continue').last);
      expect(find.byType(RecogniseExerciseView), findsOneWidget);
      expect(find.text('कमल · lotus'), findsOneWidget);
    });

    testWidgets('skip from the almost sheet', (tester) async {
      final c = await pumpPlayer(tester);
      await jumpTo(tester, c, 4);
      await tapAndSettle(tester, find.text('Simulate: almost'));
      await tapAndSettle(
        tester,
        find.text('Skip — I can’t use the camera now'),
      );
      expect(find.byType(FeedbackSheet), findsNothing);
      expect(find.byType(RecogniseExerciseView), findsOneWidget);
    });
  });

  testWidgets('0 hearts opens the out-of-hearts sheet over the player', (
    tester,
  ) async {
    await pumpPlayer(tester, hearts: 1);
    await tapAndSettle(tester, find.text('Continue'));
    await tapAndSettle(tester, find.text('Hello'));
    await tapAndSettle(tester, find.text('Check'));
    expect(find.byType(OutOfHeartsPanel), findsOneWidget);
    expect(find.byType(FeedbackSheet), findsNothing);
    expect(heartsShown(tester), 0);
  });

  loadStateTests(
    location: const LessonRoute(lessonId: FixtureIds.currentLesson).location,
    errorTitle: 'Couldn’t load this lesson',
    loadingLabel: 'Loading the lesson',
  );
}
