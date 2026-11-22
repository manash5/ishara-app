// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Hard-coded streak matching the Figma frame; the server replaces it.

@ProviderFor(streakSummary)
final streakSummaryProvider = StreakSummaryProvider._();

/// Hard-coded streak matching the Figma frame; the server replaces it.

final class StreakSummaryProvider
    extends $FunctionalProvider<StreakSummary, StreakSummary, StreakSummary>
    with $Provider<StreakSummary> {
  /// Hard-coded streak matching the Figma frame; the server replaces it.
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
  $ProviderElement<StreakSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StreakSummary create(Ref ref) {
    return streakSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreakSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreakSummary>(value),
    );
  }
}

String _$streakSummaryHash() => r'e06b5cb1a4ef509060420a4fcfdc3a015e9cdb1b';
