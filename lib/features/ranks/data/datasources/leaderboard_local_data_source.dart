import '../../../../core/services/storage/hive_service.dart';
import '../models/weekly_leaderboard_dto.dart';

/// This week's league, cached so Ranks works offline. Throws
/// `CacheException`.
class LeaderboardLocalDataSource {
  const LeaderboardLocalDataSource(this._hive);

  static const cacheKey = 'ranks.weekly';

  final HiveService _hive;

  /// The cached league, or null if there is none.
  CacheEntry<WeeklyLeaderboardDto>? readWeekly() => _hive.readCache(
    cacheKey,
    (json) =>
        WeeklyLeaderboardDto.fromJson((json! as Map).cast<String, dynamic>()),
  );

  Future<void> writeWeekly(WeeklyLeaderboardDto board) =>
      _hive.putCache(cacheKey, board.toJson());

  Future<void> clear() => _hive.removeCache(cacheKey);
}
