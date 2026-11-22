// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in learner (`GET /me`), cache-first: the cached profile at
/// once, then the fresh one, then every change (settings, onboarding).
/// Learn, lesson and gamification read their stats from here; invalidate it
/// to refetch. A fetch failure without a cached profile is an `AsyncError`
/// carrying a `Failure`.

@ProviderFor(userProfile)
final userProfileProvider = UserProfileProvider._();

/// The signed-in learner (`GET /me`), cache-first: the cached profile at
/// once, then the fresh one, then every change (settings, onboarding).
/// Learn, lesson and gamification read their stats from here; invalidate it
/// to refetch. A fetch failure without a cached profile is an `AsyncError`
/// carrying a `Failure`.

final class UserProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfile>,
          UserProfile,
          Stream<UserProfile>
        >
    with $FutureModifier<UserProfile>, $StreamProvider<UserProfile> {
  /// The signed-in learner (`GET /me`), cache-first: the cached profile at
  /// once, then the fresh one, then every change (settings, onboarding).
  /// Learn, lesson and gamification read their stats from here; invalidate it
  /// to refetch. A fetch failure without a cached profile is an `AsyncError`
  /// carrying a `Failure`.
  UserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @$internal
  @override
  $StreamProviderElement<UserProfile> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UserProfile> create(Ref ref) {
    return userProfile(ref);
  }
}

String _$userProfileHash() => r'1d0e8e62e2fcb771db576af2d41aff2de9918eb6';

/// Derived synchronously so an error shows at once, even while Riverpod
/// retries [userProfile].

@ProviderFor(profileSummary)
final profileSummaryProvider = ProfileSummaryProvider._();

/// Derived synchronously so an error shows at once, even while Riverpod
/// retries [userProfile].

final class ProfileSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileSummary>,
          AsyncValue<ProfileSummary>,
          AsyncValue<ProfileSummary>
        >
    with $Provider<AsyncValue<ProfileSummary>> {
  /// Derived synchronously so an error shows at once, even while Riverpod
  /// retries [userProfile].
  ProfileSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSummaryHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<ProfileSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<ProfileSummary> create(Ref ref) {
    return profileSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ProfileSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ProfileSummary>>(value),
    );
  }
}

String _$profileSummaryHash() => r'2ae84380a544dc7b76662eb2e206b74582ca5e50';

/// When the profile on screen was fetched; re-read whenever it changes.

@ProviderFor(profileLastUpdated)
final profileLastUpdatedProvider = ProfileLastUpdatedProvider._();

/// When the profile on screen was fetched; re-read whenever it changes.

final class ProfileLastUpdatedProvider
    extends $FunctionalProvider<DateTime?, DateTime?, DateTime?>
    with $Provider<DateTime?> {
  /// When the profile on screen was fetched; re-read whenever it changes.
  ProfileLastUpdatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileLastUpdatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileLastUpdatedHash();

  @$internal
  @override
  $ProviderElement<DateTime?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime? create(Ref ref) {
    return profileLastUpdated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$profileLastUpdatedHash() =>
    r'04d2940da731f2f582383b460d3f37aea49ff3c8';
