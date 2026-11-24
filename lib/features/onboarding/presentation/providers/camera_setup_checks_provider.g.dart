// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_setup_checks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The setup checklist, updated from the hand landmark detector on every
/// frame (recognition.md). Frames and landmarks stay in memory only.

@ProviderFor(CameraSetupChecks)
final cameraSetupChecksProvider = CameraSetupChecksProvider._();

/// The setup checklist, updated from the hand landmark detector on every
/// frame (recognition.md). Frames and landmarks stay in memory only.
final class CameraSetupChecksProvider
    extends $NotifierProvider<CameraSetupChecks, CameraSetupState> {
  /// The setup checklist, updated from the hand landmark detector on every
  /// frame (recognition.md). Frames and landmarks stay in memory only.
  CameraSetupChecksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cameraSetupChecksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cameraSetupChecksHash();

  @$internal
  @override
  CameraSetupChecks create() => CameraSetupChecks();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CameraSetupState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CameraSetupState>(value),
    );
  }
}

String _$cameraSetupChecksHash() => r'd58b17dbe3ef31a563450b2024231a721b7e1c78';

/// The setup checklist, updated from the hand landmark detector on every
/// frame (recognition.md). Frames and landmarks stay in memory only.

abstract class _$CameraSetupChecks extends $Notifier<CameraSetupState> {
  CameraSetupState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CameraSetupState, CameraSetupState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CameraSetupState, CameraSetupState>,
              CameraSetupState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
