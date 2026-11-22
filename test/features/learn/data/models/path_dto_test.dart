import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/learn/data/models/path_dto.dart';
import 'package:ishara_app/features/learn/domain/entities/lesson_summary.dart';
import 'package:ishara_app/features/learn/domain/entities/path_unit.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  final json = fixtureData<Map<String, dynamic>>('path/get_200');

  test('parses GET /path and maps it to the domain', () {
    final units = PathDto.fromJson(json).toEntity();
    expect(units, hasLength(4));
    final first = units.first;
    expect(first.number, 1);
    expect(first.title, 'Greetings & etiquette');
    expect(first.tint, UnitTint.teal);
    expect((first.learnedCount, first.totalCount), (4, 12));
    final current = first.stops.singleWhere(
      (s) => s.state == LessonState.current,
    );
    expect(current.type, StopType.lesson);
    expect(current.lesson!.id, FixtureIds.currentLesson);
    expect(current.lesson!.kind, LessonKind.lesson);
    expect((current.lesson!.signCount, current.lesson!.minutes), (3, 5));
    expect(
      first.stops.firstWhere((s) => s.type == StopType.chest).lesson,
      isNull,
    );
  });

  test('toJson round-trips to plain JSON (what the cache stores)', () {
    final dto = PathDto.fromJson(json);
    final encoded = dto.toJson();
    expect(encoded['units'], isA<List<Map<String, dynamic>>>());
    expect(PathDto.fromJson(encoded), dto);
  });

  test('an unknown enum value fails to map', () {
    final bad = {
      'units': [
        {
          ...(json['units'] as List).first as Map<String, dynamic>,
          'color': 'pink',
        },
      ],
    };
    expect(() => PathDto.fromJson(bad).toEntity(), throwsArgumentError);
  });
}
