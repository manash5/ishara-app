// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The learner's weekly league (`GET /leaderboard/weekly`): the cached
/// league first (so Ranks works offline), then the fresh one.

@ProviderFor(weeklyLeaderboard)
final weeklyLeaderboardProvider = WeeklyLeaderboardProvider._();

/// The learner's weekly league (`GET /leaderboard/weekly`): the cached
/// league first (so Ranks works offline), then the fresh one.

final class WeeklyLeaderboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeeklyLeaderboard>,
          WeeklyLeaderboard,
          Stream<WeeklyLeaderboard>
        >
    with
        $FutureModifier<WeeklyLeaderboard>,
        $StreamProvider<WeeklyLeaderboard> {
  /// The learner's weekly league (`GET /leaderboard/weekly`): the cached
  /// league first (so Ranks works offline), then the fresh one.
  WeeklyLeaderboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyLeaderboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyLeaderboardHash();

  @$internal
  @override
  $StreamProviderElement<WeeklyLeaderboard> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WeeklyLeaderboard> create(Ref ref) {
    return weeklyLeaderboard(ref);
  }
}

String _$weeklyLeaderboardHash() => r'9104a6326e0d2a3042fd4acbb799ddaa9bfea972';

/// When the league on screen was fetched; re-read whenever it changes.
/// Null when unknown: the "updated … ago" chip is then left out.

@ProviderFor(leaderboardLastUpdated)
final leaderboardLastUpdatedProvider = LeaderboardLastUpdatedProvider._();

/// When the league on screen was fetched; re-read whenever it changes.
/// Null when unknown: the "updated … ago" chip is then left out.

final class LeaderboardLastUpdatedProvider
    extends $FunctionalProvider<DateTime?, DateTime?, DateTime?>
    with $Provider<DateTime?> {
  /// When the league on screen was fetched; re-read whenever it changes.
  /// Null when unknown: the "updated … ago" chip is then left out.
  LeaderboardLastUpdatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardLastUpdatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardLastUpdatedHash();

  @$internal
  @override
  $ProviderElement<DateTime?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime? create(Ref ref) {
    return leaderboardLastUpdated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$leaderboardLastUpdatedHash() =>
    r'f05287a56bb134c0f8e59a374efcb26e576cbe9f';
