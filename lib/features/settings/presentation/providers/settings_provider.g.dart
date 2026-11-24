// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Device-only preferences (theme, camera feedback, reminder), saved in the
/// Hive settings box on every change.

@ProviderFor(Preferences)
final preferencesProvider = PreferencesProvider._();

/// Device-only preferences (theme, camera feedback, reminder), saved in the
/// Hive settings box on every change.
final class PreferencesProvider
    extends $NotifierProvider<Preferences, AppPreferences> {
  /// Device-only preferences (theme, camera feedback, reminder), saved in the
  /// Hive settings box on every change.
  PreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesHash();

  @$internal
  @override
  Preferences create() => Preferences();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferences>(value),
    );
  }
}

String _$preferencesHash() => r'6915f526306ad6e092c8bd8e9aa6638e961c05c0';

/// Device-only preferences (theme, camera feedback, reminder), saved in the
/// Hive settings box on every change.

abstract class _$Preferences extends $Notifier<AppPreferences> {
  AppPreferences build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppPreferences, AppPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppPreferences, AppPreferences>,
              AppPreferences,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The app's theme mode from [Preferences] (for `MaterialApp.themeMode`).

@ProviderFor(themeMode)
final themeModeProvider = ThemeModeProvider._();

/// The app's theme mode from [Preferences] (for `MaterialApp.themeMode`).

final class ThemeModeProvider
    extends $FunctionalProvider<ThemeMode, ThemeMode, ThemeMode>
    with $Provider<ThemeMode> {
  /// The app's theme mode from [Preferences] (for `MaterialApp.themeMode`).
  ThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeHash();

  @$internal
  @override
  $ProviderElement<ThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeMode create(Ref ref) {
    return themeMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeHash() => r'ea863e7efa58eaa9e9dc566e64205f660c196013';

/// Profile values (daily goal, hand) combined with the device preferences.

@ProviderFor(settings)
final settingsProvider = SettingsProvider._();

/// Profile values (daily goal, hand) combined with the device preferences.

final class SettingsProvider
    extends $FunctionalProvider<SettingsValues, SettingsValues, SettingsValues>
    with $Provider<SettingsValues> {
  /// Profile values (daily goal, hand) combined with the device preferences.
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
  $ProviderElement<SettingsValues> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsValues create(Ref ref) {
    return settings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsValues value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsValues>(value),
    );
  }
}

String _$settingsHash() => r'b0e484b8a3c496f686c0c93aff96af8e2db9935d';
