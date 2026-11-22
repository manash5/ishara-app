// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// What Figma "27 Streak" shows: the learner's profile (`GET /me`, cached
/// offline), brought up to date by the lesson just completed (its response
/// has the new streak before `/me` is refetched). Derived synchronously so an
/// error shows at once, even while Riverpod retries the profile; retry with
/// `ref.invalidate(userProfileProvider)`.

@ProviderFor(streakSummary)
final streakSummaryProvider = StreakSummaryProvider._();

/// What Figma "27 Streak" shows: the learner's profile (`GET /me`, cached
/// offline), brought up to date by the lesson just completed (its response
/// has the new streak before `/me` is refetched). Derived synchronously so an
/// error shows at once, even while Riverpod retries the profile; retry with
/// `ref.invalidate(userProfileProvider)`.

final class StreakSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<StreakStats>,
          AsyncValue<StreakStats>,
          AsyncValue<StreakStats>
        >
    with $Provider<AsyncValue<StreakStats>> {
  /// What Figma "27 Streak" shows: the learner's profile (`GET /me`, cached
  /// offline), brought up to date by the lesson just completed (its response
  /// has the new streak before `/me` is refetched). Derived synchronously so an
  /// error shows at once, even while Riverpod retries the profile; retry with
  /// `ref.invalidate(userProfileProvider)`.
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
  $ProviderElement<AsyncValue<StreakStats>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<StreakStats> create(Ref ref) {
    return streakSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<StreakStats> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<StreakStats>>(value),
    );
  }
}

String _$streakSummaryHash() => r'8c536b70755fb9885f69a16289c78c16e38ba4ed';
