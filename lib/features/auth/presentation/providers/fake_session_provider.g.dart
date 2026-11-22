// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stand-in for Supabase auth + `/me` onboarding state until the data layer
/// lands. Flip it from the debug `/gallery` screen to exercise the redirects.

@ProviderFor(FakeSession)
final fakeSessionProvider = FakeSessionProvider._();

/// Stand-in for Supabase auth + `/me` onboarding state until the data layer
/// lands. Flip it from the debug `/gallery` screen to exercise the redirects.
final class FakeSessionProvider
    extends $NotifierProvider<FakeSession, FakeSessionState> {
  /// Stand-in for Supabase auth + `/me` onboarding state until the data layer
  /// lands. Flip it from the debug `/gallery` screen to exercise the redirects.
  FakeSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fakeSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fakeSessionHash();

  @$internal
  @override
  FakeSession create() => FakeSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FakeSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FakeSessionState>(value),
    );
  }
}

String _$fakeSessionHash() => r'dc037c60f23e29a4b05bda10fa5644f82f56fc20';

/// Stand-in for Supabase auth + `/me` onboarding state until the data layer
/// lands. Flip it from the debug `/gallery` screen to exercise the redirects.

abstract class _$FakeSession extends $Notifier<FakeSessionState> {
  FakeSessionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FakeSessionState, FakeSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FakeSessionState, FakeSessionState>,
              FakeSessionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
