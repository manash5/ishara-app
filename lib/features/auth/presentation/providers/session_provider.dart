import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_status.dart';
import '../../domain/usecases/clear_session.dart';
import '../../domain/usecases/log_out.dart';
import '../../domain/usecases/restore_session.dart';
import '../../domain/usecases/watch_auth_status.dart';

part 'session_provider.g.dart';

/// What the router redirect needs.
typedef SessionFlags = ({bool loggedIn, bool onboardingDone});

/// The learner's session as the app sees it. [ready] is false while the
/// stored session is being restored at start-up; Splash waits for it.
@immutable
class SessionState {
  const SessionState({
    required this.ready,
    required this.loggedIn,
    required this.onboardingDone,
  });

  /// Start-up: tokens and profile not read yet.
  static const restoring = SessionState(
    ready: false,
    loggedIn: false,
    onboardingDone: false,
  );

  static const signedOut = SessionState(
    ready: true,
    loggedIn: false,
    onboardingDone: false,
  );

  /// Signed in as [user].
  factory SessionState.of(UserProfile user) => SessionState(
    ready: true,
    loggedIn: true,
    onboardingDone: user.onboardingDone,
  );

  final bool ready;
  final bool loggedIn;
  final bool onboardingDone;

  SessionFlags get flags =>
      (loggedIn: loggedIn, onboardingDone: onboardingDone);

  @override
  bool operator ==(Object other) =>
      other is SessionState &&
      other.ready == ready &&
      other.loggedIn == loggedIn &&
      other.onboardingDone == onboardingDone;

  @override
  int get hashCode => Object.hash(ready, loggedIn, onboardingDone);

  @override
  String toString() =>
      'SessionState(ready: $ready, loggedIn: $loggedIn, '
      'onboardingDone: $onboardingDone)';
}

/// The real session: restored from the stored tokens and the cached (or
/// fetched) profile at start-up, signed in by the auth forms, and signed
/// out whenever the tokens are cleared (logout, failed token refresh,
/// deleted account). The router redirect reads [SessionState.flags].
///
/// Tests seed it with `sessionProvider.overrideWith(() =>
/// Session(initial: …))`, which skips the restore but still signs out when
/// the tokens are cleared.
@Riverpod(keepAlive: true)
class Session extends _$Session {
  Session({this.initial});

  /// Skips the start-up restore (tests, previews).
  final SessionState? initial;

  @override
  SessionState build() {
    final repository = ref.watch(authRepositoryProvider);
    final sub = WatchAuthStatus(repository)().listen((status) {
      switch (status) {
        case AuthStatus.signedOut:
          _set(SessionState.signedOut);
        // Tokens saved while signed out (a sign-in whose form was closed
        // before it finished): pick the learner up from the cache.
        case AuthStatus.signedIn when !state.loggedIn && state.ready:
          unawaited(_restore(always: true));
        case AuthStatus.signedIn:
          break;
      }
    });
    ref.onDispose(sub.cancel);
    if (initial case final seeded?) return seeded;
    unawaited(_restore());
    return SessionState.restoring;
  }

  /// Reads the stored session. At start-up ([always] false) it gives way to
  /// anything that set the state meanwhile (e.g. a sign-in).
  Future<void> _restore({bool always = false}) async {
    final result = await RestoreSession(ref.read(authRepositoryProvider))();
    if (!ref.mounted || (!always && state.ready)) return;
    if (always && state.loggedIn) return;
    _set(switch (result) {
      Ok(value: final user?) => SessionState.of(user),
      Ok() => SessionState.signedOut,
      // Tokens are stored but the profile can't be fetched (offline, server
      // down) and isn't cached: stay signed in. Onboarding is assumed done,
      // since the profile is cached from sign-in until logout.
      Err(failure: NetworkFailure() || ServerFailure()) => const SessionState(
        ready: true,
        loggedIn: true,
        onboardingDone: true,
      ),
      // A failed refresh (or unreadable tokens) means no usable session.
      Err() => SessionState.signedOut,
    });
  }

  /// After register, log in, Google or a password reset.
  void signedIn(UserProfile user) => _set(SessionState.of(user));

  /// After `POST /me/onboarding`.
  void onboardingCompleted() => _set(
    SessionState(ready: true, loggedIn: state.loggedIn, onboardingDone: true),
  );

  /// Logs out (Settings). The session ends even if the API can't be reached.
  Future<void> logOut() async {
    await LogOut(ref.read(authRepositoryProvider))();
    if (ref.mounted) _set(SessionState.signedOut);
  }

  /// Forgets the session on this device only (after deleting the account).
  Future<void> endSession() async {
    await ClearSession(ref.read(authRepositoryProvider))();
    if (ref.mounted) _set(SessionState.signedOut);
  }

  /// Debug tools (Settings "Redo onboarding", the widget gallery).
  void debugOverride({bool? loggedIn, bool? onboardingDone}) => _set(
    SessionState(
      ready: true,
      loggedIn: loggedIn ?? state.loggedIn,
      onboardingDone: onboardingDone ?? state.onboardingDone,
    ),
  );

  void _set(SessionState next) {
    final signingIn = next.loggedIn && !state.loggedIn;
    state = next;
    // A (possibly different) learner signed in: reload their profile. On
    // sign-out nothing is refetched; the cache is already cleared and the
    // next sign-in reloads it.
    if (signingIn) ref.invalidate(userProfileProvider);
  }
}
