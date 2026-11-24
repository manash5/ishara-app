import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/learn/data/datasources/path_local_data_source.dart';
import 'package:ishara_app/features/learn/data/models/path_dto.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

void main() {
  final local = PathLocalDataSource(TestHive.instance);
  final dto = PathDto.fromJson(fixtureData('path/get_200'));

  test('reads nothing before a save', () {
    expect(local.readPath(), isNull);
  });

  test('saves under learn.path and reads it back with the time', () async {
    final before = DateTime.now().toUtc();
    await local.savePath(dto);
    expect(TestHive.instance.cache.containsKey('learn.path'), isTrue);
    final entry = local.readPath()!;
    expect(entry.value, dto);
    expect(
      entry.fetchedAt.isAfter(before.subtract(const Duration(seconds: 1))),
      isTrue,
    );
  });

  test('clear removes the entry', () async {
    await local.savePath(dto);
    await local.clear();
    expect(local.readPath(), isNull);
  });
}
