import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../learn/data/models/path_dto.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/lesson.dart';

part 'lesson_dto.freezed.dart';
part 'lesson_dto.g.dart';

/// `GET /lessons/:id` data: `{ lesson, exercises }`.
@freezed
abstract class LessonDto with _$LessonDto {
  const LessonDto._();

  const factory LessonDto({
    required LessonSummaryDto lesson,
    required List<ExerciseDto> exercises,
  }) = _LessonDto;

  factory LessonDto.fromJson(Map<String, dynamic> json) =>
      _$LessonDtoFromJson(json);

  Lesson toEntity() => Lesson(
    id: lesson.id,
    summary: lesson.toEntity(),
    exercises: [for (final e in exercises) e.toEntity()],
  );
}

/// One exercise, discriminated by `type` (docs/api-contract.md → Exercise).
/// Descriptions and hints carry `verified: false` until checked against the
/// NDFN NSL dictionary.
@Freezed(unionKey: 'type')
sealed class ExerciseDto with _$ExerciseDto {
  const ExerciseDto._();

  @FreezedUnionValue('watch')
  const factory ExerciseDto.watch({
    required String signId,
    required String title,
    required String description,
    required String tip,
    @Default(false) bool verified,
  }) = WatchExerciseDto;

  @FreezedUnionValue('recognise')
  const factory ExerciseDto.recognise({
    required String signId,
    required List<String> options,
    required int answerIndex,
  }) = RecogniseExerciseDto;

  @FreezedUnionValue('pickSign')
  const factory ExerciseDto.pickSign({
    required String signId,
    required String meaning,
    required int answerIndex,
    @Default(4) int optionCount,
  }) = PickSignExerciseDto;

  @FreezedUnionValue('matchPairs')
  const factory ExerciseDto.matchPairs({
    required String signId,
    required List<String> words,
    required List<int> videoOrder,
  }) = MatchPairsExerciseDto;

  @FreezedUnionValue('signIt')
  const factory ExerciseDto.signIt({
    required String signId,
    required String title,
    required String almostChip,
    required String almostHint,
    required ExerciseDto fallback,
    @Default(false) bool verified,
  }) = SignItExerciseDto;

  @FreezedUnionValue('fingerspell')
  const factory ExerciseDto.fingerspell({
    required String signId,
    required List<String> letters,
    required String meaning,
    required ExerciseDto fallback,
  }) = FingerspellExerciseDto;

  factory ExerciseDto.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDtoFromJson(json);

  Exercise toEntity() => switch (this) {
    WatchExerciseDto(
      :final signId,
      :final title,
      :final description,
      :final tip,
    ) =>
      WatchExercise(
        signId: signId,
        title: title,
        description: description,
        tip: tip,
      ),
    RecogniseExerciseDto(:final signId, :final options, :final answerIndex) =>
      RecogniseExercise(
        signId: signId,
        options: options,
        answerIndex: answerIndex,
      ),
    PickSignExerciseDto(
      :final signId,
      :final meaning,
      :final answerIndex,
      :final optionCount,
    ) =>
      PickSignExercise(
        signId: signId,
        meaning: meaning,
        answerIndex: answerIndex,
        optionCount: optionCount,
      ),
    MatchPairsExerciseDto(:final signId, :final words, :final videoOrder) =>
      MatchPairsExercise(signId: signId, words: words, videoOrder: videoOrder),
    SignItExerciseDto(
      :final signId,
      :final title,
      :final almostChip,
      :final almostHint,
      :final fallback,
    ) =>
      SignItExercise(
        signId: signId,
        title: title,
        almostChip: almostChip,
        almostHint: almostHint,
        fallback: _recognise(fallback),
      ),
    FingerspellExerciseDto(
      :final signId,
      :final letters,
      :final meaning,
      :final fallback,
    ) =>
      FingerspellExercise(
        signId: signId,
        letters: letters,
        meaning: meaning,
        fallback: _recognise(fallback),
      ),
  };

  /// Camera fallbacks must be recognise exercises (lessons-gamification.md).
  static RecogniseExercise _recognise(ExerciseDto dto) => switch (dto
      .toEntity()) {
    final RecogniseExercise e => e,
    _ => throw const FormatException('A camera fallback must be recognise.'),
  };
}
