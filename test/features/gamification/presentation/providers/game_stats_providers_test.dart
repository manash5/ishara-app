import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/features/gamification/presentation/providers/progress_stats_provider.dart';
import 'package:ishara_app/features/gamification/presentation/providers/streak_provider.dart';
import 'package:ishara_app/features/profile/presentation/providers/profile_provider.dart';

import '../../test_profile.dart';

void main() {
  ProviderContainer containerWith(AsyncValue<Never>? error) {
    final container = ProviderContainer(
      overrides: [
        userProfileProvider.overrideWithValue(
          error ?? AsyncData(testProfile(streakDays: 4, hearts: 3)),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('streakSummary maps the profile', () {
    final value = containerWith(null).read(streakSummaryProvider);
    expect(value.requireValue.days, 4);
    expect(value.requireValue.longestDays, 21);
  });

  test('progressStats maps the profile', () {
    final value = containerWith(null).read(progressStatsProvider);
    expect(value.requireValue.streakDays, 4);
    expect(value.requireValue.hearts, 3);
    expect(value.requireValue.totalXp, 1240);
  });

  test('a profile error is passed on as the same Failure', () {
    const failure = NetworkFailure();
    final container = containerWith(
      const AsyncError<Never>(failure, StackTrace.empty),
    );
    expect(container.read(streakSummaryProvider).error, failure);
    expect(container.read(progressStatsProvider).error, failure);
  });

  test('loading while the profile loads', () {
    final container = containerWith(const AsyncLoading<Never>());
    expect(container.read(streakSummaryProvider).isLoading, isTrue);
    expect(container.read(progressStatsProvider).isLoading, isTrue);
  });
}
