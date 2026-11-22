import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/app_exception.dart';
import 'package:ishara_app/core/sync/sync_event.dart';
import 'package:ishara_app/core/sync/sync_queue.dart';

import '../../helpers/test_hive.dart';

SyncEvent event(String id, {int minute = 0, int queuedMinute = 0}) => SyncEvent(
  clientEventId: id,
  type: SyncEvent.lessonComplete,
  payload: {'lessonId': 'l-1', 'mistakes': 0},
  occurredAt: DateTime.utc(2026, 11, 22, 9, minute),
  queuedAt: DateTime.utc(2026, 11, 22, 10, queuedMinute),
);

void main() {
  late SyncQueue queue;
  setUp(() => queue = SyncQueue(TestHive.instance));

  test('starts empty', () {
    expect(queue.count, 0);
    expect(queue.pending(), isEmpty);
  });

  test('pending() is oldest first, whatever the insert order', () async {
    await queue.enqueue(event('c', minute: 3));
    await queue.enqueue(event('a', minute: 1));
    await queue.enqueue(event('b', minute: 1, queuedMinute: 5));
    expect(queue.pending().map((e) => e.clientEventId), ['a', 'b', 'c']);
  });

  test('enqueue is idempotent: a retry keeps the first entry', () async {
    await queue.enqueue(event('a', minute: 1));
    await queue.enqueue(event('a', minute: 9));
    expect(queue.count, 1);
    expect(queue.pending().single.occurredAt.minute, 1);
  });

  test(
    'markFailed counts failures and keeps events; remove drops them',
    () async {
      await queue.enqueue(event('a'));
      await queue.enqueue(event('b', minute: 1));
      await queue.markFailed(queue.pending());
      await queue.markFailed(queue.pending());
      expect(queue.pending().map((e) => e.failedFlushes), [2, 2]);

      await queue.remove(['a']);
      expect(queue.pending().map((e) => e.clientEventId), ['b']);
    },
  );

  test('a stored event round-trips with its payload', () async {
    await queue.enqueue(event('a'));
    final stored = queue.pending().single;
    expect(stored.toWire(), {
      'clientEventId': 'a',
      'type': 'lessonComplete',
      'lessonId': 'l-1',
      'mistakes': 0,
    });
  });

  test('reads the earlier lesson-queue format, so nothing is lost', () async {
    await TestHive.instance.syncQueue.put('old', {
      'value': jsonEncode({
        'attempt': {
          'clientEventId': 'old',
          'lessonId': 'l-9',
          'mistakes': 1,
          'durationSeconds': 60,
          'completedAt': '2026-11-21T08:00:00.000Z',
        },
        'queuedAt': '2026-11-21T08:01:00.000Z',
        'failedFlushes': 3,
      }),
    });
    final e = queue.pending().single;
    expect(e.type, SyncEvent.lessonComplete);
    expect(e.failedFlushes, 3);
    expect(e.toWire(), {
      'clientEventId': 'old',
      'type': 'lessonComplete',
      'lessonId': 'l-9',
      'mistakes': 1,
      'durationSeconds': 60,
      'completedAt': '2026-11-21T08:00:00.000Z',
    });
  });

  test('a corrupt entry is a CacheException', () async {
    await TestHive.instance.syncQueue.put('bad', {'value': '{not json'});
    expect(() => queue.pending(), throwsA(isA<CacheException>()));
  });

  test('watchCount emits the count now and after each change', () async {
    final counts = <int>[];
    final sub = queue.watchCount().listen(counts.add);
    await Future<void>.delayed(Duration.zero);
    await queue.enqueue(event('a'));
    await Future<void>.delayed(Duration.zero);
    await queue.remove(['a']);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(counts.first, 0);
    expect(counts, containsAllInOrder([0, 1, 0]));
  });
}
