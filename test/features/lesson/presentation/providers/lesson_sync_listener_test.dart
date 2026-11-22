import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/core/services/connectivity/connectivity_service.dart';
import 'package:ishara_app/core/sync/sync_controller.dart';
import 'package:ishara_app/core/sync/sync_event.dart';
import 'package:ishara_app/core/sync/sync_service.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_providers.dart';
import 'package:ishara_app/features/lesson/presentation/providers/lesson_sync_listener.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';
import 'package:ishara_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_api.dart';

class _MockService extends Mock implements SyncService {}

void main() {
  late _MockService service;
  late int profileBuilds;

  ProviderContainer container() {
    service = _MockService();
    profileBuilds = 0;
    final c = ProviderContainer(
      overrides: [
        syncServiceProvider.overrideWithValue(service),
        isOnlineProvider.overrideWith((ref) => Stream.value(false)),
        userProfileProvider.overrideWith((ref) {
          profileBuilds++;
          return const Stream<UserProfile>.empty();
        }),
      ],
    );
    addTearDown(c.dispose);
    c
      ..listen(lessonSyncListenerProvider, (_, _) {})
      ..listen(userProfileProvider, (_, _) {});
    return c;
  }

  test('a synced lesson becomes the latest result and refreshes the '
      'profile', () async {
    final c = container();
    final result = fixtureData<Map<String, dynamic>>('lessons/complete_200');
    when(() => service.flush()).thenAnswer(
      (_) async => Ok(
        SyncReport(
          applied: [
            SyncApplied(
              clientEventId: result['clientEventId'] as String,
              type: SyncEvent.lessonComplete,
              result: result,
            ),
          ],
        ),
      ),
    );
    final before = profileBuilds;

    await c.read(syncControllerProvider.notifier).flush();
    await Future<void>.delayed(Duration.zero);

    expect(c.read(latestLessonResultProvider)?.xpEarned, 15);
    expect(profileBuilds, greaterThan(before));
  });

  test('a flush with no lessons applied changes nothing', () async {
    final c = container();
    when(() => service.flush())
        .thenAnswer((_) async => const Ok(SyncReport(duplicates: 1)));
    final before = profileBuilds;

    await c.read(syncControllerProvider.notifier).flush();
    await Future<void>.delayed(Duration.zero);

    expect(c.read(latestLessonResultProvider), isNull);
    expect(profileBuilds, before);
  });
}
