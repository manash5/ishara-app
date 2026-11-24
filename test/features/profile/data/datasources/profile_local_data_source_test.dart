import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

void main() {
  final profile = UserProfileDto.fromJson(
    fixtureData<Map<String, dynamic>>('me/get_200'),
  );
  late ProfileLocalDataSource local;
  setUp(() => local = ProfileLocalDataSource(TestHive.instance));

  test('round-trips the profile under profile.me', () async {
    expect(local.read(), isNull);
    await local.write(profile);
    expect(TestHive.instance.cache.containsKey('profile.me'), isTrue);
    expect(local.read()?.value, profile);
  });

  test('clear removes it', () async {
    await local.write(profile);
    await local.clear();
    expect(local.read(), isNull);
  });

  test('changes yields each write, skips deletions', () async {
    final seen = <String>[];
    final sub = local.changes().listen((p) => seen.add(p.displayName));
    addTearDown(sub.cancel);
    await local.write(profile.copyWith(displayName: 'A'));
    await local.clear();
    await local.write(profile.copyWith(displayName: 'B'));
    await Future<void>.delayed(Duration.zero);
    expect(seen, ['A', 'B']);
  });

  test('a corrupt entry throws CacheException', () async {
    await TestHive.instance.cache.put('profile.me', {'value': '{'});
    expect(local.read, throwsA(isA<CacheException>()));
  });
}
