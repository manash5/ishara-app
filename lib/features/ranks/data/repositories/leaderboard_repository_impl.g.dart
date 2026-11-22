// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(leaderboardRepository)
final leaderboardRepositoryProvider = LeaderboardRepositoryProvider._();

final class LeaderboardRepositoryProvider
    extends
        $FunctionalProvider<
          LeaderboardRepository,
          LeaderboardRepository,
          LeaderboardRepository
        >
    with $Provider<LeaderboardRepository> {
  LeaderboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<LeaderboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LeaderboardRepository create(Ref ref) {
    return leaderboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaderboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaderboardRepository>(value),
    );
  }
}

String _$leaderboardRepositoryHash() =>
    r'31474b9c0229cbda7998c372421072f877b845af';
