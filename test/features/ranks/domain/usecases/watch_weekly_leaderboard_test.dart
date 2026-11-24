import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/ranks/domain/entities/weekly_leaderboard.dart';
import 'package:ishara_app/features/ranks/domain/repositories/leaderboard_repository.dart';
import 'package:ishara_app/features/ranks/domain/usecases/watch_weekly_leaderboard.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

void main() {
  test('streams the repository league, failures included', () async {
    final board = WeeklyLeaderboard(
      leagueName: 'Bronze',
      nextLeagueName: 'Silver',
      weekNumber: 1,
      learnerCount: 0,
      endsAt: DateTime.utc(2026),
      promotionCount: 5,
      xpToPromotion: 0,
      entries: const [],
    );
    final repository = _MockLeaderboardRepository();
    when(() => repository.watchWeekly()).thenAnswer(
      (_) => Stream.fromIterable([Ok(board), const Err(ServerFailure())]),
    );

    final results = await WatchWeeklyLeaderboard(repository)().toList();

    expect(results.first.valueOrNull, board);
    expect((results.last as Err).failure, isA<ServerFailure>());
    verify(() => repository.watchWeekly()).called(1);
  });
}
