// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_form_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the password in [field] is shown as plain text (Figma
/// `trailingIcon` eye toggle). Local UI state only.

@ProviderFor(PasswordVisible)
final passwordVisibleProvider = PasswordVisibleFamily._();

/// Whether the password in [field] is shown as plain text (Figma
/// `trailingIcon` eye toggle). Local UI state only.
final class PasswordVisibleProvider
    extends $NotifierProvider<PasswordVisible, bool> {
  /// Whether the password in [field] is shown as plain text (Figma
  /// `trailingIcon` eye toggle). Local UI state only.
  PasswordVisibleProvider._({
    required PasswordVisibleFamily super.from,
    required AuthPasswordField super.argument,
  }) : super(
         retry: null,
         name: r'passwordVisibleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$passwordVisibleHash();

  @override
  String toString() {
    return r'passwordVisibleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PasswordVisible create() => PasswordVisible();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PasswordVisibleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$passwordVisibleHash() => r'c8b9db5b90b440946ce70c972cac19afd70e4fe6';

/// Whether the password in [field] is shown as plain text (Figma
/// `trailingIcon` eye toggle). Local UI state only.

final class PasswordVisibleFamily extends $Family
    with
        $ClassFamilyOverride<
          PasswordVisible,
          bool,
          bool,
          bool,
          AuthPasswordField
        > {
  PasswordVisibleFamily._()
    : super(
        retry: null,
        name: r'passwordVisibleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether the password in [field] is shown as plain text (Figma
  /// `trailingIcon` eye toggle). Local UI state only.

  PasswordVisibleProvider call(AuthPasswordField field) =>
      PasswordVisibleProvider._(argument: field, from: this);

  @override
  String toString() => r'passwordVisibleProvider';
}

/// Whether the password in [field] is shown as plain text (Figma
/// `trailingIcon` eye toggle). Local UI state only.

abstract class _$PasswordVisible extends $Notifier<bool> {
  late final _$args = ref.$arg as AuthPasswordField;
  AuthPasswordField get field => _$args;

  bool build(AuthPasswordField field);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Error under the Log in password field (Figma "04 Log in" error state).
///
/// UI-only phase: there is no real auth yet, so this is always null; the
/// data layer will surface "Incorrect password. Try again." here.

@ProviderFor(logInPasswordError)
final logInPasswordErrorProvider = LogInPasswordErrorProvider._();

/// Error under the Log in password field (Figma "04 Log in" error state).
///
/// UI-only phase: there is no real auth yet, so this is always null; the
/// data layer will surface "Incorrect password. Try again." here.

final class LogInPasswordErrorProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Error under the Log in password field (Figma "04 Log in" error state).
  ///
  /// UI-only phase: there is no real auth yet, so this is always null; the
  /// data layer will surface "Incorrect password. Try again." here.
  LogInPasswordErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logInPasswordErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logInPasswordErrorHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return logInPasswordError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$logInPasswordErrorHash() =>
    r'64c8cf3e3a0878209dfb0b037aa9e4964804cb5a';

/// Whether the reset link has been sent (Figma "05 Forgot password" shows the
/// sent state: success notice + "Resend link").

@ProviderFor(ResetLinkSent)
final resetLinkSentProvider = ResetLinkSentProvider._();

/// Whether the reset link has been sent (Figma "05 Forgot password" shows the
/// sent state: success notice + "Resend link").
final class ResetLinkSentProvider
    extends $NotifierProvider<ResetLinkSent, bool> {
  /// Whether the reset link has been sent (Figma "05 Forgot password" shows the
  /// sent state: success notice + "Resend link").
  ResetLinkSentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetLinkSentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetLinkSentHash();

  @$internal
  @override
  ResetLinkSent create() => ResetLinkSent();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$resetLinkSentHash() => r'f1af3b253d5d636007300fbe40cd4528f710c7bd';

/// Whether the reset link has been sent (Figma "05 Forgot password" shows the
/// sent state: success notice + "Resend link").

abstract class _$ResetLinkSent extends $Notifier<bool> {
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
