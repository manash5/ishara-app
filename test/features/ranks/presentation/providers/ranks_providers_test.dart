import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/ranks/data/repositories/leaderboard_repository_impl.dart';
import 'package:ishara_app/features/ranks/domain/repositories/leaderboard_repository.dart';
import 'package:ishara_app/features/ranks/presentation/providers/ranks_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

WeeklyLeaderboard _board(int week) => WeeklyLeaderboard(
  leagueName: 'Bronze',
  nextLeagueName: 'Silver',
  weekNumber: week,
  learnerCount: 0,
  endsAt: DateTime.utc(2026),
  promotionCount: 5,
  xpToPromotion: 0,
  entries: const [],
);

void main() {
  late _MockLeaderboardRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockLeaderboardRepository();
    container = ProviderContainer(
      overrides: [leaderboardRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  test('ends on the freshest league', () async {
    when(
      () => repository.watchWeekly(),
    ).thenAnswer((_) => Stream.fromIterable([Ok(_board(11)), Ok(_board(12))]));
    container.listen(weeklyLeaderboardProvider, (_, _) {});
    await pumpEventQueue();

    expect(container.read(weeklyLeaderboardProvider).value!.weekNumber, 12);
  });

  test('a failure becomes an AsyncError carrying the Failure', () async {
    when(() => repository.watchWeekly())
        .thenAnswer((_) => Stream.value(const Err(NetworkFailure())));
    container.listen(weeklyLeaderboardProvider, (_, _) {});
    await pumpEventQueue();

    expect(
      container.read(weeklyLeaderboardProvider).error,
      isA<NetworkFailure>(),
    );
  });
}
