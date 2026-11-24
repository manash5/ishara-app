import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/features/dictionary/data/datasources/sign_local_data_source.dart';
import 'package:ishara_app/features/dictionary/data/models/sign_dto.dart';

import '../../../../helpers/test_hive.dart';

const _signed = SignDto(
  id: 'id-1',
  name: 'Namaste',
  category: 'greetings',
  status: 'learned',
  videoUrl: 'https://cdn.test/namaste.mp4?sig=secret',
  etiquetteTip: 'Keep eye contact.',
);

void main() {
  final local = SignLocalDataSource(TestHive.instance);

  test('nothing cached reads null', () {
    expect(local.readSigns(), isNull);
  });

  test('round-trips the list under dictionary.signs', () async {
    await local.writeSigns([_signed]);

    expect(TestHive.instance.cache.containsKey('dictionary.signs'), isTrue);
    final entry = local.readSigns()!;
    expect(entry.value.single, _signed.copyWith(videoUrl: null));
  });

  test('never stores video URLs', () async {
    await local.writeSigns([_signed]);
    final raw = TestHive.instance.cache.get(SignLocalDataSource.cacheKey);
    expect('$raw', isNot(contains('cdn.test')));
    expect(local.readSigns()!.value.single.videoUrl, isNull);
  });

  test('a corrupt entry throws CacheException; clear removes it', () async {
    await TestHive.instance.cache.put(SignLocalDataSource.cacheKey, {
      'value': 'not json',
      'fetchedAt': 'x',
    });
    expect(local.readSigns, throwsA(isA<CacheException>()));
    await local.clear();
    expect(local.readSigns(), isNull);
  });
}
