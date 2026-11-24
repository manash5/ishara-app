// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streak, total XP and hearts for the StatsBar, from the learner's profile
/// (`GET /me`, cached offline). Retry with
/// `ref.invalidate(userProfileProvider)`.

@ProviderFor(progressStats)
final progressStatsProvider = ProgressStatsProvider._();

/// Streak, total XP and hearts for the StatsBar, from the learner's profile
/// (`GET /me`, cached offline). Retry with
/// `ref.invalidate(userProfileProvider)`.

final class ProgressStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProgressStats>,
          AsyncValue<ProgressStats>,
          AsyncValue<ProgressStats>
        >
    with $Provider<AsyncValue<ProgressStats>> {
  /// Streak, total XP and hearts for the StatsBar, from the learner's profile
  /// (`GET /me`, cached offline). Retry with
  /// `ref.invalidate(userProfileProvider)`.
  ProgressStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressStatsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<ProgressStats>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<ProgressStats> create(Ref ref) {
    return progressStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ProgressStats> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ProgressStats>>(value),
    );
  }
}

String _$progressStatsHash() => r'4e3be2a81856b4df115aa72de1ba67afb245894e';
