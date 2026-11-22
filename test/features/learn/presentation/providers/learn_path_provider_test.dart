import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/learn/data/repositories/path_repository_impl.dart';
import 'package:ishara_app/features/learn/domain/entities/lesson_summary.dart';
import 'package:ishara_app/features/learn/domain/entities/path_unit.dart'
    as domain;
import 'package:ishara_app/features/learn/domain/repositories/path_repository.dart';
import 'package:ishara_app/features/learn/presentation/providers/learn_path_provider.dart';
import 'package:ishara_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../../../gamification/test_profile.dart';

class MockPathRepository extends Mock implements PathRepository {}

domain.PathUnit unit(String title) => domain.PathUnit(
  id: 'u-$title',
  number: 2,
  title: title,
  tint: domain.UnitTint.lavender,
  learnedCount: 1,
  totalCount: 3,
  stops: const [],
);

void main() {
  late MockPathRepository repository;
  late StreamController<Result<List<domain.PathUnit>>> results;

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        pathRepositoryProvider.overrideWithValue(repository),
        userProfileProvider.overrideWithValue(AsyncData(testProfile())),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() {
    repository = MockPathRepository();
    results = StreamController();
    // Not awaited: close() only completes once a listener sees "done".
    addTearDown(() => unawaited(results.close()));
    when(repository.watchPath).thenAnswer((_) => results.stream);
  });

  test('emits the cached path, then the fresh one', () async {
    final c = container();
    final sub = c.listen(learnPathProvider, (_, _) {});
    addTearDown(sub.close);

    results.add(Ok([unit('Cached')]));
    await pumpEventQueue();
    expect(c.read(learnPathProvider).requireValue.single.title, 'Cached');
    expect(
      c.read(learnPathProvider).requireValue.single.color,
      UnitColor.lavender,
    );

    results.add(Ok([unit('Fresh')]));
    await pumpEventQueue();
    expect(c.read(learnPathProvider).requireValue.single.title, 'Fresh');
  });

  test('an Err becomes an AsyncError carrying the Failure', () async {
    final c = container();
    final sub = c.listen(learnPathProvider, (_, _) {});
    addTearDown(sub.close);

    results.add(const Err(NetworkFailure()));
    await pumpEventQueue();
    expect(c.read(learnPathProvider).error, isA<NetworkFailure>());
  });

  test('learnStats is the StatsBar numbers from the profile', () {
    final stats = container().read(learnStatsProvider).requireValue;
    expect((stats.streakDays, stats.totalXp, stats.hearts), (12, 1240, 5));
  });

  group('pathUnitFromDomain', () {
    domain.PathStop stop(domain.StopType type, LessonState state) =>
        domain.PathStop(
          id: '${type.name}-${state.name}',
          type: type,
          state: state,
          title: 'Stop',
          lesson: type == domain.StopType.lesson
              ? LessonSummary(
                  id: 'l1',
                  unitId: 'u1',
                  title: 'Stop',
                  kind: LessonKind.lesson,
                  state: state,
                  signCount: 4,
                  minutes: 6,
                )
              : null,
        );

    test('maps stop type and state to the node state', () {
      final view = pathUnitFromDomain(
        unit('U').copyWith(
          stops: [
            stop(domain.StopType.chest, LessonState.locked),
            stop(domain.StopType.checkpoint, LessonState.locked),
            stop(domain.StopType.lesson, LessonState.locked),
            stop(domain.StopType.review, LessonState.available),
            stop(domain.StopType.lesson, LessonState.current),
            stop(domain.StopType.lesson, LessonState.completed),
            stop(domain.StopType.lesson, LessonState.available),
          ],
        ),
      );
      expect(view.stops.map((s) => s.state), [
        PathNodeState.chest,
        PathNodeState.checkpoint,
        PathNodeState.locked,
        PathNodeState.review,
        PathNodeState.current,
        PathNodeState.completed,
        PathNodeState.current,
      ]);
      expect((view.number, view.learned, view.total), (2, 1, 3));
      final lesson = view.stops.last;
      expect((lesson.lessonId, lesson.signs, lesson.minutes), ('l1', 4, 6));
      expect(view.stops.first.lessonId, isNull);
    });
  });
}
