// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_completion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sends the onboarding answers (`POST /me/onboarding`). `state` is true
/// while the request runs. On success the session's onboarding is done, so
/// the router redirect moves on to Learn.

@ProviderFor(OnboardingCompletion)
final onboardingCompletionProvider = OnboardingCompletionProvider._();

/// Sends the onboarding answers (`POST /me/onboarding`). `state` is true
/// while the request runs. On success the session's onboarding is done, so
/// the router redirect moves on to Learn.
final class OnboardingCompletionProvider
    extends $NotifierProvider<OnboardingCompletion, bool> {
  /// Sends the onboarding answers (`POST /me/onboarding`). `state` is true
  /// while the request runs. On success the session's onboarding is done, so
  /// the router redirect moves on to Learn.
  OnboardingCompletionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingCompletionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingCompletionHash();

  @$internal
  @override
  OnboardingCompletion create() => OnboardingCompletion();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$onboardingCompletionHash() =>
    r'7edd8ee555a438cb4fb1a269f9b0b4873d747320';

/// Sends the onboarding answers (`POST /me/onboarding`). `state` is true
/// while the request runs. On success the session's onboarding is done, so
/// the router redirect moves on to Learn.

abstract class _$OnboardingCompletion extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
