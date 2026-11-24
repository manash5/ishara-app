import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/connectivity/health_remote_data_source.dart';

import '../../../helpers/mock_api.dart';

void main() {
  test('the health fixture parses', () {
    final dto = HealthDto.fromJson(
      fixtureData<Map<String, dynamic>>('health/get_200'),
    );
    expect(dto.status, 'ok');
  });

  test('GET /health on the mock API', () async {
    final dto = await HealthRemoteDataSource(mockApiClient()).check();
    expect(dto.status, 'ok');
  });

  test('offline throws a NetworkException', () {
    final source = HealthRemoteDataSource(
      mockApiClient(simulation: () => MockApiSimulation.offline),
    );
    expect(source.check(), throwsA(isA<NetworkException>()));
  });
}
