import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/connectivity/connectivity_service.dart';
import 'package:ishara_app/core/sync/sync_controller.dart';
import 'package:ishara_app/core/sync/sync_event.dart';
import 'package:ishara_app/core/sync/sync_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockService extends Mock implements SyncService {}

void main() {
  late _MockService service;
  late StreamController<bool> online;

  setUp(() {
    service = _MockService();
    online = StreamController<bool>();
  });
  tearDown(() => online.close());

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        syncServiceProvider.overrideWithValue(service),
        isOnlineProvider.overrideWith((ref) => online.stream),
      ],
    );
    addTearDown(c.dispose);
    c.listen(syncControllerProvider, (_, _) {});
    return c;
  }

  testWidgets('flushes when the app comes online', (tester) async {
    when(() => service.flush()).thenAnswer((_) async => const Ok(SyncReport()));
    container();
    online.add(false);
    await tester.pump(Duration.zero);
    verifyNever(() => service.flush());

    online.add(true);
    await tester.pump(Duration.zero);
    verify(() => service.flush()).called(1);
  });

  testWidgets('a failed flush retries after the back-off', (tester) async {
    var calls = 0;
    when(() => service.flush()).thenAnswer((_) async {
      calls++;
      return calls == 1
          ? const Err(NetworkFailure())
          : const Ok(SyncReport(duplicates: 1));
    });
    final c = container();

    expect(await c.read(syncControllerProvider.notifier).flush(), isNull);
    expect(c.read(syncControllerProvider).failures, 1);

    await tester.pump(SyncService.retryDelay(1));
    expect(calls, 2);
    final state = c.read(syncControllerProvider);
    expect(state.failures, 0);
    expect(state.lastReport?.duplicates, 1);
  });

  testWidgets('flush() (app resume) reports what was applied', (tester) async {
    when(() => service.flush()).thenAnswer(
      (_) async => const Ok(
        SyncReport(
          applied: [
            SyncApplied(clientEventId: 'e', type: SyncEvent.lessonComplete),
          ],
        ),
      ),
    );
    final c = container();
    final report = await c.read(syncControllerProvider.notifier).flush();
    expect(report?.applied.single.clientEventId, 'e');
    expect(c.read(syncControllerProvider).lastReport, same(report));
  });

  testWidgets('a second flush while one runs is skipped', (tester) async {
    final gate = Completer<Result<SyncReport>>();
    when(() => service.flush()).thenAnswer((_) => gate.future);
    final c = container();
    final notifier = c.read(syncControllerProvider.notifier);
    final first = notifier.flush();
    expect(await notifier.flush(), isNull);
    gate.complete(const Ok(SyncReport()));
    await first;
    verify(() => service.flush()).called(1);
  });
}
