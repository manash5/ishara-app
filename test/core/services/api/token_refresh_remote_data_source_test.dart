import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/api_config.dart';
import 'package:ishara_app/core/services/api/mock_api_adapter.dart';
import 'package:ishara_app/core/services/api/token_refresh_remote_data_source.dart';

import '../../../helpers/mock_api.dart';

void main() {
  late TokenRefreshRemoteDataSource source;

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl))
      ..httpClientAdapter = MockApiAdapter(
        bundle: FixtureBundle(),
        latency: Duration.zero,
      );
    source = TokenRefreshRemoteDataSource(dio);
  });

  test('POST /auth/refresh returns fresh tokens', () async {
    final tokens = await source.refresh('mock-refresh-1');
    expect(tokens.accessToken, isNotEmpty);
    expect(tokens.refreshToken, isNotEmpty);
    expect(tokens.expiresAt.isUtc, isTrue);
  });

  test('an expired refresh token is a 401', () {
    expect(
      source.refresh(MockApiAdapter.expiredRefreshToken),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );
  });
}
