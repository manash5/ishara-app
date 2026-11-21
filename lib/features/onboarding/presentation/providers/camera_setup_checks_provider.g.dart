// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_setup_checks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fake checklist (Figma 9:530) until the live camera + landmarker feed it.

@ProviderFor(cameraSetupChecks)
final cameraSetupChecksProvider = CameraSetupChecksProvider._();

/// Fake checklist (Figma 9:530) until the live camera + landmarker feed it.

final class CameraSetupChecksProvider
    extends
        $FunctionalProvider<
          List<CameraSetupCheck>,
          List<CameraSetupCheck>,
          List<CameraSetupCheck>
        >
    with $Provider<List<CameraSetupCheck>> {
  /// Fake checklist (Figma 9:530) until the live camera + landmarker feed it.
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
  $ProviderElement<List<CameraSetupCheck>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<CameraSetupCheck> create(Ref ref) {
    return cameraSetupChecks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CameraSetupCheck> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CameraSetupCheck>>(value),
    );
  }
}

String _$cameraSetupChecksHash() => r'2fc80f5387e46b2186249ee3b73265282857845e';
