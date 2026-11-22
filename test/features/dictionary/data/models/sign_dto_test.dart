import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/dictionary/data/models/sign_dto.dart';
import 'package:ishara_app/features/dictionary/domain/entities/sign.dart';

import '../../../../helpers/mock_api.dart';

List<SignDto> _list(String name) => [
  for (final s in fixtureData<List<dynamic>>(name))
    SignDto.fromJson(s as Map<String, dynamic>),
];

void main() {
  test('parses both list pages into entities', () {
    final signs = [
      ..._list('signs/list_page1'),
      ..._list('signs/list_page2'),
    ].map((s) => s.toEntity()).toList();

    expect(signs, hasLength(12));
    expect(signs.first.id, FixtureIds.namaste);
    expect(signs.first.status, SignStatus.learned);
    expect(signs[2].status, SignStatus.practising);
    expect(signs.last.category, SignCategory.numbers);
    expect(signs.last.status, SignStatus.newSign);
  });

  test('parses the search and category fixtures', () {
    expect(_list('signs/list_search').single.id, FixtureIds.thankYou);
    expect(
      _list('signs/list_category').map((s) => s.toEntity().category).toSet(),
      {SignCategory.greetings},
    );
  });

  test('parses a detail; unverified text stays empty', () {
    final namaste = SignDto.fromJson(
      fixtureData<Map<String, dynamic>>('signs/get_200'),
    ).toEntity();
    expect(namaste.name, 'Namaste');
    expect(namaste.etiquetteTip, isNotNull);
    expect(namaste.meaning, isNull);
    expect(namaste.steps, isEmpty);
  });

  test('round-trips through JSON', () {
    const dto = SignDto(
      id: 'id',
      name: 'Hello',
      category: 'greetings',
      status: 'new',
      videoUrl: 'https://cdn.test/v.mp4?sig=x',
      steps: ['a'],
    );
    expect(SignDto.fromJson(dto.toJson()), dto);
  });
}
