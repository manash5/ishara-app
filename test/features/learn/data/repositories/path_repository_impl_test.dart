import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/learn/data/datasources/path_remote_data_source.dart';
import 'package:ishara_app/features/learn/data/repositories/path_repository_impl.dart';
import 'package:ishara_app/features/learn/domain/entities/lesson_summary.dart';
import 'package:ishara_app/features/learn/domain/entities/path_unit.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  PathRepositoryImpl repo([MockApiSimulation? s]) => PathRepositoryImpl(
    PathRemoteDataSource(mockApiClient(simulation: s == null ? null : () => s)),
  );

  test('maps /path to units and stops', () async {
    final units = (await repo().getPath()).getOrThrow();
    expect(units.map((u) => u.tint), [
      UnitTint.teal,
      UnitTint.lavender,
      UnitTint.mint,
      UnitTint.lime,
    ]);
    final current = units.first.stops.singleWhere(
      (s) => s.state == LessonState.current,
    );
    expect(current.lesson!.id, FixtureIds.currentLesson);
    expect(current.title, 'Thank you');
    final chest = units.first.stops.firstWhere((s) => s.type == StopType.chest);
    expect(chest.lesson, isNull);
  });

  test('a 404 is a NotFoundFailure', () async {
    final result = await repo(MockApiSimulation.notFound).getPath();
    expect((result as Err).failure, isA<NotFoundFailure>());
  });
}
