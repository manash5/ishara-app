// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognition_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// What the fake camera plays (debug `/gallery` → Fake camera). Ignored once
/// the real camera lands.

@ProviderFor(FakeCameraSettings)
final fakeCameraSettingsProvider = FakeCameraSettingsProvider._();

/// What the fake camera plays (debug `/gallery` → Fake camera). Ignored once
/// the real camera lands.
final class FakeCameraSettingsProvider
    extends $NotifierProvider<FakeCameraSettings, FakeCameraScenario> {
  /// What the fake camera plays (debug `/gallery` → Fake camera). Ignored once
  /// the real camera lands.
  FakeCameraSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fakeCameraSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fakeCameraSettingsHash();

  @$internal
  @override
  FakeCameraSettings create() => FakeCameraSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FakeCameraScenario value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FakeCameraScenario>(value),
    );
  }
}

String _$fakeCameraSettingsHash() =>
    r'5c01609b8058350ae2dcafe5226b12b02fb4ec2a';

/// What the fake camera plays (debug `/gallery` → Fake camera). Ignored once
/// the real camera lands.

abstract class _$FakeCameraSettings extends $Notifier<FakeCameraScenario> {
  FakeCameraScenario build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FakeCameraScenario, FakeCameraScenario>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FakeCameraScenario, FakeCameraScenario>,
              FakeCameraScenario,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The hand landmark detector for a camera exercise. For now a scripted fake
/// replaying the synthetic scenario chosen in `/gallery`; the MediaPipe
/// wrapper over `CameraFrameSource` replaces it here.

@ProviderFor(handLandmarkDetector)
final handLandmarkDetectorProvider = HandLandmarkDetectorFamily._();

/// The hand landmark detector for a camera exercise. For now a scripted fake
/// replaying the synthetic scenario chosen in `/gallery`; the MediaPipe
/// wrapper over `CameraFrameSource` replaces it here.

final class HandLandmarkDetectorProvider
    extends
        $FunctionalProvider<
          HandLandmarkDetector,
          HandLandmarkDetector,
          HandLandmarkDetector
        >
    with $Provider<HandLandmarkDetector> {
  /// The hand landmark detector for a camera exercise. For now a scripted fake
  /// replaying the synthetic scenario chosen in `/gallery`; the MediaPipe
  /// wrapper over `CameraFrameSource` replaces it here.
  HandLandmarkDetectorProvider._({
    required HandLandmarkDetectorFamily super.from,
    required CameraTarget super.argument,
  }) : super(
         retry: null,
         name: r'handLandmarkDetectorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$handLandmarkDetectorHash();

  @override
  String toString() {
    return r'handLandmarkDetectorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<HandLandmarkDetector> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HandLandmarkDetector create(Ref ref) {
    final argument = this.argument as CameraTarget;
    return handLandmarkDetector(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HandLandmarkDetector value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HandLandmarkDetector>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HandLandmarkDetectorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$handLandmarkDetectorHash() =>
    r'940eb665c8a897c8d49e3ee48f8dba98d45251ee';

/// The hand landmark detector for a camera exercise. For now a scripted fake
/// replaying the synthetic scenario chosen in `/gallery`; the MediaPipe
/// wrapper over `CameraFrameSource` replaces it here.

final class HandLandmarkDetectorFamily extends $Family
    with $FunctionalFamilyOverride<HandLandmarkDetector, CameraTarget> {
  HandLandmarkDetectorFamily._()
    : super(
        retry: null,
        name: r'handLandmarkDetectorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The hand landmark detector for a camera exercise. For now a scripted fake
  /// replaying the synthetic scenario chosen in `/gallery`; the MediaPipe
  /// wrapper over `CameraFrameSource` replaces it here.

  HandLandmarkDetectorProvider call(CameraTarget target) =>
      HandLandmarkDetectorProvider._(argument: target, from: this);

  @override
  String toString() => r'handLandmarkDetectorProvider';
}

/// The fingerspelling classifier, loaded once (recognition.md). A fake
/// nearest-prototype classifier until the TFLite model lands.

@ProviderFor(fingerspellingClassifier)
final fingerspellingClassifierProvider = FingerspellingClassifierProvider._();

/// The fingerspelling classifier, loaded once (recognition.md). A fake
/// nearest-prototype classifier until the TFLite model lands.

final class FingerspellingClassifierProvider
    extends
        $FunctionalProvider<
          FingerspellingClassifier,
          FingerspellingClassifier,
          FingerspellingClassifier
        >
    with $Provider<FingerspellingClassifier> {
  /// The fingerspelling classifier, loaded once (recognition.md). A fake
  /// nearest-prototype classifier until the TFLite model lands.
  FingerspellingClassifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fingerspellingClassifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fingerspellingClassifierHash();

  @$internal
  @override
  $ProviderElement<FingerspellingClassifier> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FingerspellingClassifier create(Ref ref) {
    return fingerspellingClassifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FingerspellingClassifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FingerspellingClassifier>(value),
    );
  }
}

String _$fingerspellingClassifierHash() =>
    r'5b1a09e5f89b4eae66a60e5b2f6229c23f60c7a0';

@ProviderFor(signTemplateSource)
final signTemplateSourceProvider = SignTemplateSourceProvider._();

final class SignTemplateSourceProvider
    extends
        $FunctionalProvider<
          SignTemplateSource,
          SignTemplateSource,
          SignTemplateSource
        >
    with $Provider<SignTemplateSource> {
  SignTemplateSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signTemplateSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signTemplateSourceHash();

  @$internal
  @override
  $ProviderElement<SignTemplateSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignTemplateSource create(Ref ref) {
    return signTemplateSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignTemplateSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignTemplateSource>(value),
    );
  }
}

String _$signTemplateSourceHash() =>
    r'e6501e5143c0a4b1f31603b29a14e9aa3ab012ac';

/// A greeting's reference templates (null when the sign has none yet).

@ProviderFor(signTemplate)
final signTemplateProvider = SignTemplateFamily._();

/// A greeting's reference templates (null when the sign has none yet).

final class SignTemplateProvider
    extends
        $FunctionalProvider<
          AsyncValue<SignTemplate?>,
          SignTemplate?,
          FutureOr<SignTemplate?>
        >
    with $FutureModifier<SignTemplate?>, $FutureProvider<SignTemplate?> {
  /// A greeting's reference templates (null when the sign has none yet).
  SignTemplateProvider._({
    required SignTemplateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'signTemplateProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$signTemplateHash();

  @override
  String toString() {
    return r'signTemplateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SignTemplate?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SignTemplate?> create(Ref ref) {
    final argument = this.argument as String;
    return signTemplate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SignTemplateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$signTemplateHash() => r'9f577acd2edc14ae132857b550e12882612b7132';

/// A greeting's reference templates (null when the sign has none yet).

final class SignTemplateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SignTemplate?>, String> {
  SignTemplateFamily._()
    : super(
        retry: null,
        name: r'signTemplateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// A greeting's reference templates (null when the sign has none yet).

  SignTemplateProvider call(String signId) =>
      SignTemplateProvider._(argument: signId, from: this);

  @override
  String toString() => r'signTemplateProvider';
}
