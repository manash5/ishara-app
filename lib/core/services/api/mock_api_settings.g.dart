// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_api_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The mock API's current simulation (debug only; ignored by a real server).

@ProviderFor(MockApiSettings)
final mockApiSettingsProvider = MockApiSettingsProvider._();

/// The mock API's current simulation (debug only; ignored by a real server).
final class MockApiSettingsProvider
    extends $NotifierProvider<MockApiSettings, MockApiSimulation> {
  /// The mock API's current simulation (debug only; ignored by a real server).
  MockApiSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockApiSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockApiSettingsHash();

  @$internal
  @override
  MockApiSettings create() => MockApiSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MockApiSimulation value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MockApiSimulation>(value),
    );
  }
}

String _$mockApiSettingsHash() => r'1bab6b9363e99015f564e6ed654e69c152611f1f';

/// The mock API's current simulation (debug only; ignored by a real server).

abstract class _$MockApiSettings extends $Notifier<MockApiSimulation> {
  MockApiSimulation build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MockApiSimulation, MockApiSimulation>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MockApiSimulation, MockApiSimulation>,
              MockApiSimulation,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
