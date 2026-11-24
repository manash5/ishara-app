import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/lesson/data/datasources/lesson_local_data_source.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_dto.dart';

import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

void main() {
  late LessonLocalDataSource local;
  setUp(() => local = LessonLocalDataSource(TestHive.instance));

  test('lessons round-trip under lesson.<id>', () async {
    final dto = LessonDto.fromJson(fixtureData('lessons/get_200'));
    expect(local.readLesson(FixtureIds.currentLesson), isNull);

    await local.writeLesson(FixtureIds.currentLesson, dto);

    expect(
      TestHive.instance.cache.containsKey('lesson.${FixtureIds.currentLesson}'),
      isTrue,
    );
    expect(local.readLesson(FixtureIds.currentLesson)!.value, dto);
  });

  test('no video URL is cached with a lesson', () async {
    await local.writeLesson(
      FixtureIds.currentLesson,
      LessonDto.fromJson(fixtureData('lessons/get_200')),
    );
    final raw = TestHive.instance.cache.get(
      'lesson.${FixtureIds.currentLesson}',
    )!;
    expect(raw['value'] as String, isNot(contains('videoUrl')));
    expect(raw['value'] as String, isNot(contains('http')));
  });
}
