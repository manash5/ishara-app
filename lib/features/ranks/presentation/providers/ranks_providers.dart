import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/leaderboard_repository_impl.dart';
import '../../domain/entities/weekly_leaderboard.dart';
import '../../domain/usecases/get_leaderboard_last_updated.dart';
import '../../domain/usecases/watch_weekly_leaderboard.dart';

export '../../domain/entities/weekly_leaderboard.dart';

part 'ranks_providers.g.dart';

/// The learner's weekly league (`GET /leaderboard/weekly`): the cached
/// league first (so Ranks works offline), then the fresh one.
@riverpod
Stream<WeeklyLeaderboard> weeklyLeaderboard(Ref ref) => WatchWeeklyLeaderboard(
  ref.watch(leaderboardRepositoryProvider),
)().map((result) => result.getOrThrow());

/// When the league on screen was fetched; re-read whenever it changes.
@riverpod
DateTime? leaderboardLastUpdated(Ref ref) {
  ref.watch(weeklyLeaderboardProvider);
  return GetLeaderboardLastUpdated(ref.watch(leaderboardRepositoryProvider))();
}

/// "3d 14h", "5h 20m", "45m" — the countdown chip text. Rounds up to the
/// minute, so a league ending in 3d 13h 59m 59s still reads "3d 14h".
String formatTimeLeft(Duration d) {
  final total = (d.inSeconds / Duration.secondsPerMinute).ceil();
  final rounded = Duration(minutes: total < 0 ? 0 : total);
  final days = rounded.inDays;
  final hours = rounded.inHours % 24;
  final minutes = rounded.inMinutes % 60;
  if (days > 0) return '${days}d ${hours}h';
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m';
}
