// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// In-memory settings with the Figma defaults; a repository-backed notifier
/// (Hive + `/me`) replaces it when the data layer lands.

@ProviderFor(Settings)
final settingsProvider = SettingsProvider._();

/// In-memory settings with the Figma defaults; a repository-backed notifier
/// (Hive + `/me`) replaces it when the data layer lands.
final class SettingsProvider
    extends $NotifierProvider<Settings, SettingsValues> {
  /// In-memory settings with the Figma defaults; a repository-backed notifier
  /// (Hive + `/me`) replaces it when the data layer lands.
  SettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsHash();

  @$internal
  @override
  Settings create() => Settings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsValues value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsValues>(value),
    );
  }
}

String _$settingsHash() => r'ae0f9d3340583d53aec6cf3e1d409c5fec9463bb';

/// In-memory settings with the Figma defaults; a repository-backed notifier
/// (Hive + `/me`) replaces it when the data layer lands.

abstract class _$Settings extends $Notifier<SettingsValues> {
  SettingsValues build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SettingsValues, SettingsValues>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsValues, SettingsValues>,
              SettingsValues,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
