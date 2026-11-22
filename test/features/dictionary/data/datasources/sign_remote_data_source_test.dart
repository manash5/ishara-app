import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/api_endpoints.dart';
import 'package:ishara_app/features/dictionary/data/datasources/sign_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('query parameters', () {
    late _MockApiClient api;
    late List<Map<String, dynamic>> queries;

    setUp(() {
      api = _MockApiClient();
      queries = [];
      when(
        () => api.get(
          ApiEndpoints.getSigns,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((invocation) async {
        final q =
            invocation.namedArguments[#queryParameters] as Map<String, dynamic>;
        queries.add(q);
        return Response(
          requestOptions: RequestOptions(),
          data: fixture(
            q['page'] == 2 ? 'signs/list_page2' : 'signs/list_page1',
          ),
        );
      });
    });

    test('fetchAll walks every page with the page size', () async {
      final signs = await SignRemoteDataSource(api).fetchAll();

      expect(signs, hasLength(12));
      expect(queries, [
        {'page': 1, 'limit': SignRemoteDataSource.pageSize},
        {'page': 2, 'limit': SignRemoteDataSource.pageSize},
      ]);
    });

    test('search and category are sent; blank ones are left out', () async {
      final source = SignRemoteDataSource(api);
      await source.fetchPage(search: 'thank', category: 'greetings');
      await source.fetchPage(search: '', category: '');

      expect(queries.first, {
        'page': 1,
        'limit': SignRemoteDataSource.pageSize,
        'category': 'greetings',
        'search': 'thank',
      });
      expect(queries.last, {'page': 1, 'limit': SignRemoteDataSource.pageSize});
    });

    test('fetchSign calls /signs/:id', () async {
      when(() => api.get(ApiEndpoints.getSignById(FixtureIds.namaste)))
          .thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(),
              data: fixture('signs/get_200'),
            ),
          );
      final sign = await SignRemoteDataSource(api)
          .fetchSign(FixtureIds.namaste);
      expect(sign.name, 'Namaste');
    });
  });

  group('against the mock API', () {
    final source = SignRemoteDataSource(mockApiClient());

    test('fetches both pages in curated order', () async {
      final signs = await source.fetchAll();
      expect(signs, hasLength(12));
      expect(signs.first.name, 'Namaste');
      expect(signs.last.name, 'Three');
    });

    test('search serves list_search', () async {
      final signs = await source.fetchAll(search: 'thank');
      expect(signs.single.id, FixtureIds.thankYou);
    });

    test('category serves list_category', () async {
      final signs = await source.fetchAll(category: 'greetings');
      expect(signs, isNotEmpty);
      expect(signs.every((s) => s.category == 'greetings'), isTrue);
    });

    test('an unknown sign throws NotFoundException', () {
      expect(
        source.fetchSign('00000000-0000-4000-8000-000000000000'),
        throwsA(isA<NotFoundException>()),
      );
    });
  });
}
