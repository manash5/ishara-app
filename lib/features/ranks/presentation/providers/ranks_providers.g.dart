// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The learner's weekly league (`GET /leaderboard/weekly`).

@ProviderFor(weeklyLeaderboard)
final weeklyLeaderboardProvider = WeeklyLeaderboardProvider._();

/// The learner's weekly league (`GET /leaderboard/weekly`).

final class WeeklyLeaderboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeeklyLeaderboard>,
          WeeklyLeaderboard,
          FutureOr<WeeklyLeaderboard>
        >
    with
        $FutureModifier<WeeklyLeaderboard>,
        $FutureProvider<WeeklyLeaderboard> {
  /// The learner's weekly league (`GET /leaderboard/weekly`).
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
  $FutureProviderElement<WeeklyLeaderboard> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WeeklyLeaderboard> create(Ref ref) {
    return weeklyLeaderboard(ref);
  }
}

String _$weeklyLeaderboardHash() => r'95d731f419548b241a389bcb623435858b2a98a3';
