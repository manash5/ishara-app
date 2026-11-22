import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_dto.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_result_dto.dart';
import 'package:ishara_app/features/lesson/domain/entities/exercise.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  test('lessons/get_200 maps to one exercise of each type', () {
    final lesson = LessonDto.fromJson(fixtureData('lessons/get_200'))
        .toEntity();
    expect(lesson.id, FixtureIds.currentLesson);
    expect(lesson.summary?.title, 'Thank you');
    expect(lesson.exercises.map((e) => e.runtimeType), [
      WatchExercise,
      RecogniseExercise,
      PickSignExercise,
      MatchPairsExercise,
      SignItExercise,
      FingerspellExercise,
    ]);
    final fingerspell = lesson.exercises
        .whereType<FingerspellExercise>()
        .single;
    expect(fingerspell.fallback.signId, fingerspell.signId);
  });

  test('a lesson survives the JSON round trip used by the cache', () {
    final dto = LessonDto.fromJson(fixtureData('lessons/get_200'));
    final decoded = LessonDto.fromJson(
      jsonDecode(jsonEncode(dto.toJson())) as Map<String, dynamic>,
    );
    expect(decoded, dto);
  });

  test('a camera fallback that is not recognise is rejected', () {
    final json = fixtureData<Map<String, dynamic>>('lessons/get_200');
    final signIt = (json['exercises'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((e) => e['type'] == 'signIt');
    signIt['fallback'] = {
      'type': 'pickSign',
      'signId': signIt['signId'],
      'meaning': 'Namaste',
      'answerIndex': 0,
    };
    expect(
      () => LessonDto.fromJson(json).toEntity(),
      throwsA(isA<FormatException>()),
    );
  });

  test('lessons/complete_200 maps to a LessonResult', () {
    final result = LessonResultDto.fromJson(fixtureData('lessons/complete_200'))
        .toEntity();
    expect(result.xpEarned, 15);
    expect(result.accuracy, 0.92);
    expect(result.duration, const Duration(minutes: 4, seconds: 12));
    expect(result.streakExtended, isTrue);
    expect(result.streakDays, 12);
    expect(result.hearts, 5);
  });
}
