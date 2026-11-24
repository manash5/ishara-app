// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The real session: restored from the stored tokens and the cached (or
/// fetched) profile at start-up, signed in by the auth forms, and signed
/// out whenever the tokens are cleared (logout, failed token refresh,
/// deleted account). The router redirect reads [SessionState.flags].
///
/// Tests seed it with `sessionProvider.overrideWith(() =>
/// Session(initial: …))`, which skips the restore but still signs out when
/// the tokens are cleared.

@ProviderFor(Session)
final sessionProvider = SessionProvider._();

/// The real session: restored from the stored tokens and the cached (or
/// fetched) profile at start-up, signed in by the auth forms, and signed
/// out whenever the tokens are cleared (logout, failed token refresh,
/// deleted account). The router redirect reads [SessionState.flags].
///
/// Tests seed it with `sessionProvider.overrideWith(() =>
/// Session(initial: …))`, which skips the restore but still signs out when
/// the tokens are cleared.
final class SessionProvider extends $NotifierProvider<Session, SessionState> {
  /// The real session: restored from the stored tokens and the cached (or
  /// fetched) profile at start-up, signed in by the auth forms, and signed
  /// out whenever the tokens are cleared (logout, failed token refresh,
  /// deleted account). The router redirect reads [SessionState.flags].
  ///
  /// Tests seed it with `sessionProvider.overrideWith(() =>
  /// Session(initial: …))`, which skips the restore but still signs out when
  /// the tokens are cleared.
  SessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  Session create() => Session();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionState>(value),
    );
  }
}

String _$sessionHash() => r'9eda0ddd4164369b4b8cf1b4c937e67c194a0353';

/// The real session: restored from the stored tokens and the cached (or
/// fetched) profile at start-up, signed in by the auth forms, and signed
/// out whenever the tokens are cleared (logout, failed token refresh,
/// deleted account). The router redirect reads [SessionState.flags].
///
/// Tests seed it with `sessionProvider.overrideWith(() =>
/// Session(initial: …))`, which skips the restore but still signs out when
/// the tokens are cleared.

abstract class _$Session extends $Notifier<SessionState> {
  SessionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SessionState, SessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionState, SessionState>,
              SessionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
