import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/lesson_summary.dart';
import '../../domain/entities/path_unit.dart';

part 'path_dto.freezed.dart';
part 'path_dto.g.dart';

/// `GET /path` data: `{ units }`.
@freezed
abstract class PathDto with _$PathDto {
  const PathDto._();

  const factory PathDto({required List<PathUnitDto> units}) = _PathDto;

  factory PathDto.fromJson(Map<String, dynamic> json) =>
      _$PathDtoFromJson(json);

  List<PathUnit> toEntity() => [for (final u in units) u.toEntity()];
}

@freezed
abstract class PathUnitDto with _$PathUnitDto {
  const PathUnitDto._();

  const factory PathUnitDto({
    required String id,
    required int number,
    required String title,
    required String color,
    required int learnedCount,
    required int totalCount,
    required List<PathStopDto> stops,
  }) = _PathUnitDto;

  factory PathUnitDto.fromJson(Map<String, dynamic> json) =>
      _$PathUnitDtoFromJson(json);

  PathUnit toEntity() => PathUnit(
    id: id,
    number: number,
    title: title,
    tint: UnitTint.values.byName(color),
    learnedCount: learnedCount,
    totalCount: totalCount,
    stops: [for (final s in stops) s.toEntity()],
  );
}

@freezed
abstract class PathStopDto with _$PathStopDto {
  const PathStopDto._();

  const factory PathStopDto({
    required String id,
    required String type,
    required String state,
    required String title,
    LessonSummaryDto? lesson,
  }) = _PathStopDto;

  factory PathStopDto.fromJson(Map<String, dynamic> json) =>
      _$PathStopDtoFromJson(json);

  PathStop toEntity() => PathStop(
    id: id,
    type: StopType.values.byName(type),
    state: LessonState.values.byName(state),
    title: title,
    lesson: lesson?.toEntity(),
  );
}

/// Lesson summary JSON (docs/api-contract.md → LessonSummary).
@freezed
abstract class LessonSummaryDto with _$LessonSummaryDto {
  const LessonSummaryDto._();

  const factory LessonSummaryDto({
    required String id,
    required String unitId,
    required String title,
    required String kind,
    required String state,
    required int signCount,
    required int minutes,
  }) = _LessonSummaryDto;

  factory LessonSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$LessonSummaryDtoFromJson(json);

  LessonSummary toEntity() => LessonSummary(
    id: id,
    unitId: unitId,
    title: title,
    kind: LessonKind.values.byName(kind),
    state: LessonState.values.byName(state),
    signCount: signCount,
    minutes: minutes,
  );
}
