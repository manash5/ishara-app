import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';

void main() {
  late Directory dir;
  late HiveService hive;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('ishara_hive_');
    hive = await HiveService.init(path: dir.path);
  });

  tearDown(() async {
    await hive.close();
    await dir.delete(recursive: true);
  });

  test('opens every typed box', () {
    expect(hive.cache.name, HiveBoxes.cache.boxName);
    expect(hive.syncQueue.name, HiveBoxes.syncQueue.boxName);
    expect(hive.settings.name, HiveBoxes.settings.boxName);
    expect(hive.cache.isOpen && hive.syncQueue.isOpen, isTrue);
  });

  test('stores a value with the time it was fetched', () async {
    final fetchedAt = DateTime.utc(2026, 11, 22, 9);
    await hive.putCache('profile', {
      'name': 'Asha',
      'tags': ['a', 'b'],
    }, fetchedAt: fetchedAt);

    final entry = hive.readCache(
      'profile',
      (json) => json! as Map<String, dynamic>,
    )!;
    expect(entry.value, {
      'name': 'Asha',
      'tags': ['a', 'b'],
    });
    expect(entry.fetchedAt, fetchedAt);
  });

  test('a missing key reads as null; remove deletes it', () async {
    expect(hive.readCache('nothing', (j) => j), isNull);
    await hive.putCache('k', 1);
    await hive.removeCache('k');
    expect(hive.readCache('k', (j) => j), isNull);
  });

  test('isStale compares against the max age', () {
    final entry = CacheEntry(1, DateTime.utc(2026, 11, 22, 9));
    final now = DateTime.utc(2026, 11, 22, 10);
    expect(entry.isStale(const Duration(minutes: 30), now: now), isTrue);
    expect(entry.isStale(const Duration(hours: 2), now: now), isFalse);
  });

  test('corrupt data throws CacheException', () async {
    await hive.cache.put('bad', {'value': '{not json', 'fetchedAt': 'x'});
    expect(
      () => hive.readCache('bad', (j) => j),
      throwsA(isA<CacheException>()),
    );
  });

  test('a value JSON cannot encode throws CacheException', () async {
    await expectLater(
      hive.putCache('bad', Object()),
      throwsA(isA<CacheException>()),
    );
  });
}
