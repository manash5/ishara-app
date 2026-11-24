import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/sync/sync_event.dart';
import 'package:ishara_app/core/sync/sync_remote_data_source.dart';
import 'package:ishara_app/core/sync/sync_result_dto.dart';

import '../../helpers/mock_api.dart';

void main() {
  test('the sync fixture parses into SyncResultDtos', () {
    final dto = SyncResponseDto.fromJson(
      fixtureData<Map<String, dynamic>>('progress/sync_200'),
    );
    expect(dto.results.map((r) => r.status), [
      'applied',
      'duplicate',
      'rejected',
    ]);
    expect(dto.results.first.result, isA<Map<String, dynamic>>());
    expect(dto.results.last.result, isNull);
    expect(dto.results.last.message, 'Lesson not found.');
  });

  group('POST /progress/sync on the mock API', () {
    SyncEvent event(String id) => SyncEvent(
      clientEventId: id,
      type: SyncEvent.lessonComplete,
      payload: const {
        'lessonId': FixtureIds.currentLesson,
        'mistakes': 0,
        'durationSeconds': 60,
        'completedAt': '2026-11-22T09:00:00.000Z',
      },
      occurredAt: DateTime.utc(2026, 11, 22),
      queuedAt: DateTime.utc(2026, 11, 22),
    );

    test('one result per event', () async {
      final source = SyncRemoteDataSource(mockApiClient());
      final results = await source.sync([event('a'), event('b')]);
      expect(results.map((r) => r.clientEventId), ['a', 'b']);
    });

    test('offline throws a NetworkException', () {
      final source = SyncRemoteDataSource(
        mockApiClient(simulation: () => MockApiSimulation.offline),
      );
      expect(source.sync([event('a')]), throwsA(isA<NetworkException>()));
    });
  });
}
