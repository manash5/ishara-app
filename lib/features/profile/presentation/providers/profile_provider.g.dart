// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in learner (`GET /me`). Learn, lesson and gamification read
/// their stats from here; invalidate it to refetch.

@ProviderFor(userProfile)
final userProfileProvider = UserProfileProvider._();

/// The signed-in learner (`GET /me`). Learn, lesson and gamification read
/// their stats from here; invalidate it to refetch.

final class UserProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfile>,
          UserProfile,
          FutureOr<UserProfile>
        >
    with $FutureModifier<UserProfile>, $FutureProvider<UserProfile> {
  /// The signed-in learner (`GET /me`). Learn, lesson and gamification read
  /// their stats from here; invalidate it to refetch.
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
  $FutureProviderElement<UserProfile> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserProfile> create(Ref ref) {
    return userProfile(ref);
  }
}

String _$userProfileHash() => r'4d93bb643ee26d71247e557b06d9ada4c20b3b3c';

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

String _$profileSummaryHash() => r'9665bbe1c64510a236cfadcd1b257f4a55056933';
