// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The learner's streak from their stats (`GET /me`); a day counts as
/// practised when it earned XP.

@ProviderFor(streakSummary)
final streakSummaryProvider = StreakSummaryProvider._();

/// The learner's streak from their stats (`GET /me`); a day counts as
/// practised when it earned XP.

final class StreakSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<StreakSummary>,
          AsyncValue<StreakSummary>,
          AsyncValue<StreakSummary>
        >
    with $Provider<AsyncValue<StreakSummary>> {
  /// The learner's streak from their stats (`GET /me`); a day counts as
  /// practised when it earned XP.
  StreakSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakSummaryHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<StreakSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<StreakSummary> create(Ref ref) {
    return streakSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<StreakSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<StreakSummary>>(value),
    );
  }
}

String _$streakSummaryHash() => r'c1386931113df20db27ce43af03cad512b6b0021';
