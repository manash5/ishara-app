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

/// Figma "04 Log in": email + password or Google.

@ProviderFor(LogInForm)
final logInFormProvider = LogInFormProvider._();

/// Figma "04 Log in": email + password or Google.
final class LogInFormProvider
    extends $NotifierProvider<LogInForm, AuthFormState> {
  /// Figma "04 Log in": email + password or Google.
  LogInFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logInFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logInFormHash();

  @$internal
  @override
  LogInForm create() => LogInForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthFormState>(value),
    );
  }
}

String _$logInFormHash() => r'56bf0a8476b3ad5d9ffbf8a148ce505b6a83a7df';

/// Figma "04 Log in": email + password or Google.

abstract class _$LogInForm extends $Notifier<AuthFormState> {
  AuthFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthFormState, AuthFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthFormState, AuthFormState>,
              AuthFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Figma "03 Sign up": name, email, password or Google.

@ProviderFor(SignUpForm)
final signUpFormProvider = SignUpFormProvider._();

/// Figma "03 Sign up": name, email, password or Google.
final class SignUpFormProvider
    extends $NotifierProvider<SignUpForm, AuthFormState> {
  /// Figma "03 Sign up": name, email, password or Google.
  SignUpFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signUpFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signUpFormHash();

  @$internal
  @override
  SignUpForm create() => SignUpForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthFormState>(value),
    );
  }
}

String _$signUpFormHash() => r'1f27daaf0d7462933aa7bb0948f4c22c38a0bef8';

/// Figma "03 Sign up": name, email, password or Google.

abstract class _$SignUpForm extends $Notifier<AuthFormState> {
  AuthFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthFormState, AuthFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthFormState, AuthFormState>,
              AuthFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PasswordResetForm)
final passwordResetFormProvider = PasswordResetFormProvider._();

final class PasswordResetFormProvider
    extends $NotifierProvider<PasswordResetForm, PasswordResetState> {
  PasswordResetFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordResetFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordResetFormHash();

  @$internal
  @override
  PasswordResetForm create() => PasswordResetForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PasswordResetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PasswordResetState>(value),
    );
  }
}

String _$passwordResetFormHash() => r'ddbf1334983184edcc46da16523a5fc5ee917d69';

abstract class _$PasswordResetForm extends $Notifier<PasswordResetState> {
  PasswordResetState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PasswordResetState, PasswordResetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PasswordResetState, PasswordResetState>,
              PasswordResetState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
