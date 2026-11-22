import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/api/token_storage.dart';

part 'fake_session_provider.g.dart';

/// What the router needs to know about the user (UI-only phase).
typedef FakeSessionState = ({bool loggedIn, bool onboardingDone});

/// Stand-in for Supabase auth + `/me` onboarding state until the data layer
/// lands. Flip it from the debug `/gallery` screen to exercise the redirects.
@Riverpod(keepAlive: true)
class FakeSession extends _$FakeSession {
  @override
  FakeSessionState build() {
    // A cleared session (logout, failed token refresh) signs the user out;
    // the router redirect then sends them to /welcome.
    final sub = ref.watch(tokenStorageProvider).sessionChanges.listen((status) {
      if (status == SessionStatus.signedOut) logOut();
    });
    ref.onDispose(sub.cancel);
    return (loggedIn: false, onboardingDone: false);
  }

  /// New account: logged in, onboarding still to do.
  void signUp() => state = (loggedIn: true, onboardingDone: false);

  /// Returning user: logged in with onboarding already done.
  void logIn() => state = (loggedIn: true, onboardingDone: true);

  void logOut() => state = (loggedIn: false, onboardingDone: false);

  void completeOnboarding() =>
      state = (loggedIn: state.loggedIn, onboardingDone: true);

  void setLoggedIn(bool value) =>
      state = (loggedIn: value, onboardingDone: state.onboardingDone);

  void setOnboardingDone(bool value) =>
      state = (loggedIn: state.loggedIn, onboardingDone: value);
}
