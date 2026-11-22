import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/game_rules.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_providers.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_models.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_player_provider.dart';

import '../lesson_test_utils.dart';

void main() {
  const id = 'lesson-1';
  late ProviderContainer container;
  final provider = lessonPlayerProvider(id);

  ProviderContainer makeContainer({int? hearts}) {
    final c = ProviderContainer(
      overrides: [
        if (hearts != null) startingHeartsProvider.overrideWithValue(hearts),
        lessonProvider(id).overrideWithValue(
          AsyncData(Lesson(id: id, exercises: fakeExercises())),
        ),
      ],
    );
    addTearDown(c.dispose);
    // Keep the auto-dispose provider alive for the whole test.
    c.listen(provider, (_, _) {});
    return c;
  }

  LessonPlayerState state() => container.read(provider);
  LessonPlayer player() => container.read(provider.notifier);

  /// Advance past the watch exercise to the recognise one (index 1).
  void toRecognise() => player().check();

  void toIndex(int index) {
    while (state().index < index) {
      player().continueNext();
    }
  }

  setUp(() => container = makeContainer());

  test('starts on the watch exercise with full hearts and no progress', () {
    expect(state().exercise, isA<WatchExercise>());
    expect(state().hearts, GameRules.maxHearts);
    expect(state().progress, 0);
    expect(state().exercises.map((e) => e.runtimeType), [
      WatchExercise,
      RecogniseExercise,
      PickSignExercise,
      MatchPairsExercise,
      SignItExercise,
      FingerspellExercise,
    ]);
  });

  test('watch: Continue moves straight on without a sheet', () {
    expect(player().check(), isNull);
    expect(state().exercise, isA<RecogniseExercise>());
  });

  group('recognise', () {
    test('Check needs a selection', () {
      toRecognise();
      expect(state().canCheck, isFalse);
      expect(player().check(), isNull);
      player().select(0);
      expect(state().canCheck, isTrue);
    });

    test('correct answer: correct sheet, no heart lost, progress counts', () {
      toRecognise();
      player().select(0);
      expect(player().check(), FeedbackResult.correct);
      expect(state().phase, LessonPhase.feedback);
      expect(state().hearts, GameRules.maxHearts);
      expect(state().progress, 2 / 6);
    });

    test('wrong answer costs one heart and counts a mistake', () {
      toRecognise();
      player().select(2);
      expect(player().check(), FeedbackResult.incorrect);
      expect(state().hearts, GameRules.maxHearts - 1);
      expect(state().mistakes, 1);
    });

    test('selection is locked while the sheet shows', () {
      toRecognise();
      player()
        ..select(0)
        ..check()
        ..select(3);
      expect(state().selected, 0);
    });
  });

  group('pick the sign', () {
    setUp(() => toIndex(2));

    test('wrong costs a heart', () {
      player().select(0);
      expect(player().check(), FeedbackResult.incorrect);
      expect(state().hearts, GameRules.maxHearts - 1);
    });

    test('right does not', () {
      player().select(1);
      expect(player().check(), FeedbackResult.correct);
      expect(state().hearts, GameRules.maxHearts);
    });
  });

  group('match pairs', () {
    setUp(() => toIndex(3));

    test('a right pair is matched; Check enables once all match', () {
      expect(player().tapMatch(word: 0), MatchTap.selected);
      expect(player().tapMatch(video: 0), MatchTap.matched);
      expect(state().match.matched, {0});
      expect(state().canCheck, isFalse);
      player()
        ..tapMatch(video: 1)
        ..tapMatch(word: 1)
        ..tapMatch(word: 2)
        ..tapMatch(video: 2);
      expect(state().canCheck, isTrue);
      expect(player().check(), FeedbackResult.correct);
    });

    test('a wrong pair shows wrong, costs a heart and clears the picks', () {
      player().tapMatch(word: 0);
      expect(player().tapMatch(video: 1), MatchTap.wrong);
      expect(state().match.wrongWord, 0);
      expect(state().match.wrongVideo, 1);
      expect(state().match.word, isNull);
      expect(state().hearts, GameRules.maxHearts - 1);
      // The next tap clears the wrong state.
      player().tapMatch(word: 2);
      expect(state().match.wrongWord, isNull);
      expect(state().match.word, 2);
    });
  });

  group('camera exercises never cost hearts', () {
    test('sign it: almost shows the hint, retry returns to answering', () {
      toIndex(4);
      expect(
        player().cameraResult(CameraOutcome.almost),
        FeedbackResult.almost,
      );
      expect(state().cameraOutcome, CameraOutcome.almost);
      expect(state().hearts, GameRules.maxHearts);
      expect(state().mistakes, 0);
      player().retry();
      expect(state().phase, LessonPhase.answering);
      expect(state().cameraOutcome, isNull);
      expect(
        player().cameraResult(CameraOutcome.correct),
        FeedbackResult.correct,
      );
    });

    test('fingerspell: one result per letter, then the correct sheet', () {
      toIndex(5);
      expect(player().cameraResult(CameraOutcome.correct), isNull);
      expect(state().letterIndex, 1);
      expect(
        player().cameraResult(CameraOutcome.almost),
        FeedbackResult.almost,
      );
      expect(state().hearts, GameRules.maxHearts);
      player().retry();
      expect(player().cameraResult(CameraOutcome.correct), isNull);
      expect(
        player().cameraResult(CameraOutcome.correct),
        FeedbackResult.correct,
      );
    });
  });

  group("Can't use the camera now", () {
    test('swaps this and every later camera exercise for recognise', () {
      toIndex(4);
      final before = state().exercises;
      player().skipCamera();
      final after = state().exercises;
      expect(state().cameraSkipped, isTrue);
      expect(after.take(4), before.take(4));
      expect(after.skip(4), everyElement(isA<RecogniseExercise>()));
      expect(after.map((e) => e.signId), before.map((e) => e.signId));
      expect(state().index, 4);
      expect(state().hearts, GameRules.maxHearts);
    });

    test('from the almost sheet it also resets the feedback', () {
      toIndex(4);
      player()
        ..cameraResult(CameraOutcome.almost)
        ..skipCamera();
      expect(state().phase, LessonPhase.answering);
      expect(state().feedback, isNull);
      expect(state().exercise, isA<RecogniseExercise>());
    });

    test('does nothing on a non-camera exercise', () {
      toRecognise();
      player().skipCamera();
      expect(state().cameraSkipped, isFalse);
    });
  });

  test('0 hearts → outOfHearts, with no feedback sheet', () {
    container = makeContainer(hearts: 1);
    toRecognise();
    player().select(1);
    expect(player().check(), isNull);
    expect(state().hearts, 0);
    expect(state().phase, LessonPhase.outOfHearts);
    // Nothing moves on once hearts are gone.
    player().continueNext();
    expect(state().index, 1);
  });

  test('a wrong match on the last heart also stops the lesson', () {
    container = makeContainer(hearts: 1);
    toIndex(3);
    player()
      ..tapMatch(word: 0)
      ..tapMatch(video: 2);
    expect(state().phase, LessonPhase.outOfHearts);
  });

  test('continuing past the last exercise finishes the lesson', () {
    toIndex(5);
    player().continueNext();
    expect(state().phase, LessonPhase.finished);
    expect(state().progress, 1);
  });

  test('finishing records the attempt for Lesson complete', () {
    container = makeContainer();
    toRecognise();
    player()
      ..select(1)
      ..check()
      ..continueNext();
    toIndex(5);
    player().continueNext();

    final attempt = container.read(lessonAttemptsProvider)[id]!;
    expect(attempt.lessonId, id);
    expect(attempt.mistakes, 1);
    expect(
      attempt.clientEventId,
      matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-')),
    );
    expect(attempt.completedAt.isUtc, isTrue);
  });
}
