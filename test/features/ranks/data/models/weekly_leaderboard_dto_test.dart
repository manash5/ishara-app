import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/ranks/data/models/weekly_leaderboard_dto.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  test('parses the weekly fixture into the entity', () {
    final board = WeeklyLeaderboardDto.fromJson(
      fixtureData<Map<String, dynamic>>('leaderboard/weekly_200'),
    ).toEntity();

    expect(board.leagueName, 'Bronze');
    expect(board.nextLeagueName, 'Silver');
    expect(board.promotionCount, 5);
    expect(board.entries.map((e) => e.rank), List.generate(10, (i) => i + 1));
    final me = board.entries.singleWhere((e) => e.isMe);
    expect((me.userId, me.xp), (FixtureIds.user, 480));
  });

  test('round-trips through JSON (as the cache stores it)', () {
    final dto = WeeklyLeaderboardDto.fromJson(
      fixtureData<Map<String, dynamic>>('leaderboard/weekly_200'),
    );
    final json = jsonDecode(jsonEncode(dto.toJson())) as Map<String, dynamic>;
    expect(WeeklyLeaderboardDto.fromJson(json), dto);
  });
}
