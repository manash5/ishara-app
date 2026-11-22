// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_choices_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The onboarding answers in progress. Defaults match the Figma frames
/// (Regular goal, right hand selected).

@ProviderFor(OnboardingChoices)
final onboardingChoicesProvider = OnboardingChoicesProvider._();

/// The onboarding answers in progress. Defaults match the Figma frames
/// (Regular goal, right hand selected).
final class OnboardingChoicesProvider
    extends $NotifierProvider<OnboardingChoices, OnboardingChoicesState> {
  /// The onboarding answers in progress. Defaults match the Figma frames
  /// (Regular goal, right hand selected).
  OnboardingChoicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingChoicesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingChoicesHash();

  @$internal
  @override
  OnboardingChoices create() => OnboardingChoices();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingChoicesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingChoicesState>(value),
    );
  }
}

String _$onboardingChoicesHash() => r'dc237ae3b2c9caf8f1132f8598515cff41f3365e';

/// The onboarding answers in progress. Defaults match the Figma frames
/// (Regular goal, right hand selected).

abstract class _$OnboardingChoices extends $Notifier<OnboardingChoicesState> {
  OnboardingChoicesState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<OnboardingChoicesState, OnboardingChoicesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingChoicesState, OnboardingChoicesState>,
              OnboardingChoicesState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
