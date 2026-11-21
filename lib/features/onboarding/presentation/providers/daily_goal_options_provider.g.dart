// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_goal_options_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fake goal options (Figma 9:225) until the backend serves them.

@ProviderFor(dailyGoalOptions)
final dailyGoalOptionsProvider = DailyGoalOptionsProvider._();

/// Fake goal options (Figma 9:225) until the backend serves them.

final class DailyGoalOptionsProvider
    extends
        $FunctionalProvider<
          List<DailyGoalOption>,
          List<DailyGoalOption>,
          List<DailyGoalOption>
        >
    with $Provider<List<DailyGoalOption>> {
  /// Fake goal options (Figma 9:225) until the backend serves them.
  DailyGoalOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyGoalOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyGoalOptionsHash();

  @$internal
  @override
  $ProviderElement<List<DailyGoalOption>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DailyGoalOption> create(Ref ref) {
    return dailyGoalOptions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DailyGoalOption> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DailyGoalOption>>(value),
    );
  }
}

String _$dailyGoalOptionsHash() => r'd58d955b75736acfa3663c1cca25df8b32cce781';
