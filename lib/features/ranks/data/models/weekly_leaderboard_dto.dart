import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/weekly_leaderboard.dart';

part 'weekly_leaderboard_dto.freezed.dart';
part 'weekly_leaderboard_dto.g.dart';

/// `GET /leaderboard/weekly` data (docs/api-contract.md → Leaderboard).
@freezed
abstract class WeeklyLeaderboardDto with _$WeeklyLeaderboardDto {
  const WeeklyLeaderboardDto._();

  const factory WeeklyLeaderboardDto({
    required String leagueName,
    required String nextLeagueName,
    required int weekNumber,
    required int learnerCount,
    required DateTime endsAt,
    required int promotionCount,
    required int xpToPromotion,
    required List<LeaderboardEntryDto> entries,
  }) = _WeeklyLeaderboardDto;

  factory WeeklyLeaderboardDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklyLeaderboardDtoFromJson(json);

  WeeklyLeaderboard toEntity() => WeeklyLeaderboard(
    leagueName: leagueName,
    nextLeagueName: nextLeagueName,
    weekNumber: weekNumber,
    learnerCount: learnerCount,
    endsAt: endsAt,
    promotionCount: promotionCount,
    xpToPromotion: xpToPromotion,
    entries: [for (final e in entries) e.toEntity()],
  );
}

@freezed
abstract class LeaderboardEntryDto with _$LeaderboardEntryDto {
  const LeaderboardEntryDto._();

  const factory LeaderboardEntryDto({
    required int rank,
    required String userId,
    required String displayName,
    String? avatarUrl,
    required int xp,
    @Default(false) bool isMe,
  }) = _LeaderboardEntryDto;

  factory LeaderboardEntryDto.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryDtoFromJson(json);

  LeaderboardEntry toEntity() => LeaderboardEntry(
    rank: rank,
    userId: userId,
    displayName: displayName,
    avatarUrl: avatarUrl,
    xp: xp,
    isMe: isMe,
  );
}
