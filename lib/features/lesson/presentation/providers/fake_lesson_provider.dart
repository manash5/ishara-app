import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/game_rules.dart';
import 'lesson_models.dart';

part 'fake_lesson_provider.g.dart';

const _greetings = ['Thank you', 'Sorry', 'Hello', 'Please'];

/// Hard-coded lesson with one exercise of each type, using the Figma copy
/// (frames 18–25). A repository-backed provider replaces it later.
///
/// Sign descriptions and hints are Figma placeholders and are NOT verified
/// NSL — the "Thank you" description is the ASL sign (CLAUDE.md).
@riverpod
Lesson fakeLesson(Ref ref, String lessonId) => Lesson(
  id: lessonId,
  exercises: const [
    WatchExercise(
      signId: 'thank-you',
      title: 'Thank you',
      description:
          'Touch your chin with a flat hand, then move it forward and down '
          '— like blowing a gentle kiss.',
      tip: 'Tip: play at 0.5× to see the handshape clearly.',
    ),
    RecogniseExercise(signId: 'thank-you', options: _greetings, answerIndex: 0),
    PickSignExercise(signId: 'sorry', meaning: 'Sorry', answerIndex: 1),
    MatchPairsExercise(
      signId: 'hello',
      words: ['Hello', 'Please', 'Sorry'],
      videoOrder: [0, 1, 2],
    ),
    SignItExercise(
      signId: 'namaste',
      title: 'Namaste',
      almostChip: 'Index finger',
      almostHint: 'Curl your index finger toward your palm.',
      fallback: RecogniseExercise(
        signId: 'namaste',
        options: ['Namaste', 'Sorry', 'Hello', 'Please'],
        answerIndex: 0,
      ),
    ),
    FingerspellExercise(
      signId: 'kamal',
      letters: ['क', 'म', 'ल'],
      meaning: 'lotus',
      fallback: RecogniseExercise(
        signId: 'kamal',
        options: ['कमल · lotus', 'Namaste', 'Thank you', 'Sorry'],
        answerIndex: 0,
      ),
    ),
  ],
);

/// The learner's hearts when a lesson starts (fake until `/me` lands).
@riverpod
int startingHearts(Ref ref) => GameRules.maxHearts;
