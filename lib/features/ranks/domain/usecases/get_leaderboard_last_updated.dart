import '../../../../core/error/result.dart';
import '../repositories/leaderboard_repository.dart';

/// When the cached league was fetched ("Offline · updated 3 h ago").
class GetLeaderboardLastUpdated {
  const GetLeaderboardLastUpdated(this._repository);

  final LeaderboardRepository _repository;

  Result<DateTime?> call() => _repository.lastUpdated();
}
