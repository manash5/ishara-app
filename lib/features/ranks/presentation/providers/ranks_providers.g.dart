// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The learner's weekly league (fake; a repository replaces this later).

@ProviderFor(weeklyLeaderboard)
final weeklyLeaderboardProvider = WeeklyLeaderboardProvider._();

/// The learner's weekly league (fake; a repository replaces this later).

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
  /// The learner's weekly league (fake; a repository replaces this later).
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

String _$weeklyLeaderboardHash() => r'7e764947db4337ebf5d5a72eb7056ce4e1d0d1ec';
