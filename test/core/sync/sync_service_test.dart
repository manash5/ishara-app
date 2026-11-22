import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/api/api_client.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/services/api/token_storage.dart';
import 'package:ishara_app/core/sync/sync_event.dart';
import 'package:ishara_app/core/sync/sync_queue.dart';
import 'package:ishara_app/core/sync/sync_service.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/mock_api.dart';
import '../../helpers/test_hive.dart';

SyncEvent event(String id, {int minute = 0}) => SyncEvent(
  clientEventId: id,
  type: SyncEvent.lessonComplete,
  payload: {
    'lessonId': FixtureIds.currentLesson,
    'mistakes': 0,
    'durationSeconds': 60,
    'completedAt': DateTime.utc(2026, 11, 22, 9, minute).toIso8601String(),
  },
  occurredAt: DateTime.utc(2026, 11, 22, 9, minute),
  queuedAt: DateTime.utc(2026, 11, 22, 10),
);

void main() {
  late SyncQueue queue;
  setUp(() => queue = SyncQueue(TestHive.instance));

  group('with a fake server', () {
    late FakeHttpAdapter adapter;
    late SyncService service;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      adapter = FakeHttpAdapter((_) => envelope({'results': <Object>[]}));
      service = SyncService(
        queue,
        ApiClient(
          tokenStorage: TokenStorage(),
          adapter: adapter,
          retryDelays: const [],
          enableLogging: false,
        ),
      );
    });

    Map<String, Object?> result(String id, String status) => {
      'clientEventId': id,
      'status': status,
      'message': null,
      'result': status == 'applied' ? {'lessonId': 'x'} : null,
    };

    test('an empty queue sends nothing', () async {
      final report = (await service.flush()).getOrThrow();
      expect(report.remaining, 0);
      expect(adapter.requests, isEmpty);
    });

    test('sends oldest first in the contract shape; removes applied, '
        'duplicate and rejected; keeps unknown', () async {
      for (final (id, m) in [('c', 3), ('a', 1), ('d', 4), ('b', 2)]) {
        await queue.enqueue(event(id, minute: m));
      }
      adapter.handler = (_) => envelope({
        'results': [
          result('a', 'applied'),
          result('b', 'duplicate'),
          result('c', 'rejected'),
          result('d', 'somethingNew'),
        ],
      });

      final report = (await service.flush()).getOrThrow();

      final body = adapter.requests.single.data as Map<String, dynamic>;
      final events = (body['events'] as List).cast<Map<String, dynamic>>();
      expect(events.map((e) => e['clientEventId']), ['a', 'b', 'c', 'd']);
      expect(events.first['type'], 'lessonComplete');
      expect(events.first['lessonId'], FixtureIds.currentLesson);
      expect(report.applied.single.clientEventId, 'a');
      expect(report.applied.single.result, {'lessonId': 'x'});
      expect((report.duplicates, report.rejected, report.remaining), (1, 1, 1));
      expect(queue.pending().map((e) => e.clientEventId), ['d']);
    });

    test('a failed send keeps every event and counts the failure', () async {
      await queue.enqueue(event('a'));
      adapter.handler = (_) => envelope(null, status: 503);

      final result = await service.flush();

      expect((result as Err).failure, isA<ServerFailure>());
      expect(queue.pending().single.failedFlushes, 1);
    });

    test('results for events it did not send are ignored', () async {
      await queue.enqueue(event('a'));
      adapter.handler = (_) => envelope({
        'results': [result('zzz', 'applied')],
      });
      final report = (await service.flush()).getOrThrow();
      expect(report.applied, isEmpty);
      expect(queue.count, 1);
    });

    test('concurrent flushes share one request', () async {
      await queue.enqueue(event('a'));
      adapter.handler = (_) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return envelope({
          'results': [result('a', 'applied')],
        });
      };
      final both = await Future.wait([service.flush(), service.flush()]);
      expect(adapter.requests, hasLength(1));
      expect(both[0].isOk && both[1].isOk, isTrue);
    });

    test('an unreadable queue is a CacheFailure and sends nothing', () async {
      await TestHive.instance.syncQueue.put('bad', {'value': '{'});
      final result = await service.flush();
      expect((result as Err).failure, isA<CacheFailure>());
      expect(adapter.requests, isEmpty);
    });
  });

  test('retryDelay: 30 s doubling, capped at 30 min', () {
    expect(SyncService.retryDelay(1), const Duration(seconds: 30));
    expect(SyncService.retryDelay(2), const Duration(minutes: 1));
    expect(SyncService.retryDelay(3), const Duration(minutes: 2));
    expect(SyncService.retryDelay(7), const Duration(minutes: 30));
    expect(SyncService.retryDelay(99), const Duration(minutes: 30));
  });

  test('end to end on the mock API: offline keeps it, online applies it, a '
      'replay is a duplicate', () async {
    var simulation = MockApiSimulation.offline;
    final service = SyncService(
      queue,
      mockApiClient(simulation: () => simulation),
    );
    await queue.enqueue(event('e-1'));

    expect((await service.flush()).isOk, isFalse);
    expect(queue.count, 1);

    simulation = MockApiSimulation.none;
    final report = (await service.flush()).getOrThrow();
    expect(report.applied.single.clientEventId, 'e-1');
    expect(queue.count, 0);

    await queue.enqueue(event('e-1'));
    final replay = (await service.flush()).getOrThrow();
    expect(replay.duplicates, 1);
    expect(queue.count, 0);
  });
}
