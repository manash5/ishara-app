import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/connectivity/connectivity_service.dart';
import 'package:ishara_app/features/lesson/data/repositories/lesson_repository_impl.dart';
import 'package:ishara_app/features/lesson/domain/entities/lesson_result.dart';
import 'package:ishara_app/features/lesson/domain/entities/progress_sync_report.dart';
import 'package:ishara_app/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:ishara_app/features/lesson/domain/usecases/flush_progress_queue.dart';
import 'package:ishara_app/features/lesson/presentation/providers/progress_sync_provider.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';
import 'package:ishara_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements LessonRepository {}

final _applied = LessonResult(
  lessonId: 'l-1',
  clientEventId: 'e-1',
  xpEarned: 15,
  accuracy: 1,
  duration: Duration.zero,
  newSignCount: 0,
  signs: const [],
  streakExtended: true,
  streakDays: 3,
  hearts: 5,
  completedAt: DateTime.utc(2026),
);

void main() {
  late _MockRepo repo;
  late StreamController<bool> online;
  late int profileBuilds;

  ProviderContainer makeContainer() {
    final c = ProviderContainer(
      overrides: [
        lessonRepositoryProvider.overrideWithValue(repo),
        isOnlineProvider.overrideWith((ref) => online.stream),
        userProfileProvider.overrideWith((ref) {
          profileBuilds++;
          return const Stream<UserProfile>.empty();
        }),
      ],
      retry: (_, _) => null,
    );
    addTearDown(c.dispose);
    c.listen(progressSyncProvider, (_, _) {});
    c.listen(userProfileProvider, (_, _) {});
    return c;
  }

  setUp(() {
    repo = _MockRepo();
    online = StreamController<bool>();
    profileBuilds = 0;
    when(() => repo.flushQueue())
        .thenAnswer((_) async => const Ok(ProgressSyncReport()));
  });
  tearDown(() => online.close());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('flushes when the app comes online, not while offline', () async {
    makeContainer();
    online.add(false);
    await settle();
    verifyNever(() => repo.flushQueue());

    online.add(true);
    await settle();
    await settle();
    verify(() => repo.flushQueue()).called(1);

    // Offline → online again flushes again.
    online
      ..add(false)
      ..add(true);
    await settle();
    await settle();
    verify(() => repo.flushQueue()).called(1);
  });

  test('flushes at once when already online at start', () async {
    online.add(true);
    makeContainer();
    await settle();
    await settle();
    verify(() => repo.flushQueue()).called(1);
  });

  test('applied events refresh the profile; an empty flush does not', () async {
    final c = makeContainer();
    await settle();
    expect(profileBuilds, 1);

    await c.read(progressSyncProvider.notifier).flush();
    await settle();
    expect(profileBuilds, 1);

    when(() => repo.flushQueue())
        .thenAnswer((_) async => Ok(ProgressSyncReport(applied: [_applied])));
    final report = await c.read(progressSyncProvider.notifier).flush();
    await settle();
    expect(report!.applied.single.clientEventId, 'e-1');
    expect(c.read(progressSyncProvider).lastReport, report);
    expect(profileBuilds, 2);
  });

  test('a concurrent flush is skipped', () async {
    final gate = Completer<Result<ProgressSyncReport>>();
    when(() => repo.flushQueue()).thenAnswer((_) => gate.future);
    final c = makeContainer();
    final notifier = c.read(progressSyncProvider.notifier);

    final first = notifier.flush();
    expect(c.read(progressSyncProvider).flushing, isTrue);
    expect(await notifier.flush(), isNull);
    gate.complete(const Ok(ProgressSyncReport()));
    await first;
    expect(c.read(progressSyncProvider).flushing, isFalse);
    verify(() => repo.flushQueue()).called(1);
  });

  testWidgets('a failed flush retries with back-off until it succeeds', (
    tester,
  ) async {
    when(() => repo.flushQueue())
        .thenAnswer((_) async => const Err(NetworkFailure()));
    final c = makeContainer();
    final notifier = c.read(progressSyncProvider.notifier);

    expect(await notifier.flush(), isNull);
    expect(c.read(progressSyncProvider).failures, 1);
    verify(() => repo.flushQueue()).called(1);

    // Not before the first delay…
    await tester.pump(
      FlushProgressQueue.retryDelay(1) - const Duration(seconds: 1),
    );
    verifyNever(() => repo.flushQueue());
    // …then retried; the second failure waits twice as long.
    await tester.pump(const Duration(seconds: 1));
    verify(() => repo.flushQueue()).called(1);
    expect(c.read(progressSyncProvider).failures, 2);

    when(() => repo.flushQueue())
        .thenAnswer((_) async => const Ok(ProgressSyncReport()));
    await tester.pump(FlushProgressQueue.retryDelay(1));
    verifyNever(() => repo.flushQueue());
    await tester.pump(FlushProgressQueue.retryDelay(1));
    verify(() => repo.flushQueue()).called(1);
    expect(c.read(progressSyncProvider).failures, 0);

    // Success: no more retries.
    await tester.pump(FlushProgressQueue.maxRetryDelay);
    verifyNever(() => repo.flushQueue());
  });
}
