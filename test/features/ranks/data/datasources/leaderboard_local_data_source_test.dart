import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/ranks/data/datasources/leaderboard_local_data_source.dart';
import 'package:ishara_app/features/ranks/data/models/weekly_leaderboard_dto.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

void main() {
  final local = LeaderboardLocalDataSource(TestHive.instance);

  test('nothing cached reads null', () {
    expect(local.readWeekly(), isNull);
  });

  test('round-trips the league under ranks.weekly', () async {
    final dto = WeeklyLeaderboardDto.fromJson(
      fixtureData<Map<String, dynamic>>('leaderboard/weekly_200'),
    );
    await local.writeWeekly(dto);

    expect(TestHive.instance.cache.containsKey('ranks.weekly'), isTrue);
    expect(local.readWeekly()!.value, dto);

    await local.clear();
    expect(local.readWeekly(), isNull);
  });
}
