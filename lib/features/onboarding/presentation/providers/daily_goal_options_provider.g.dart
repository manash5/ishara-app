// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_goal_options_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The daily-goal choices on "06 Daily goal" (Figma 9:225): one per goal
/// the API accepts ([GameRules.dailyGoalMinutes]), named and drawn as in
/// Figma.

@ProviderFor(dailyGoalOptions)
final dailyGoalOptionsProvider = DailyGoalOptionsProvider._();

/// The daily-goal choices on "06 Daily goal" (Figma 9:225): one per goal
/// the API accepts ([GameRules.dailyGoalMinutes]), named and drawn as in
/// Figma.

final class DailyGoalOptionsProvider
    extends
        $FunctionalProvider<
          List<DailyGoalOption>,
          List<DailyGoalOption>,
          List<DailyGoalOption>
        >
    with $Provider<List<DailyGoalOption>> {
  /// The daily-goal choices on "06 Daily goal" (Figma 9:225): one per goal
  /// the API accepts ([GameRules.dailyGoalMinutes]), named and drawn as in
  /// Figma.
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

String _$dailyGoalOptionsHash() => r'8ef17934b7cf8c4de31daabfae4b8c156469f77d';
