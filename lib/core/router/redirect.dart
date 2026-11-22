import '../../features/auth/presentation/providers/session_provider.dart';

/// Route paths the redirect needs (router.md). Widgets navigate with the typed
/// routes in `app_routes.dart`, never with these strings.
abstract final class RedirectPaths {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const learn = '/learn';
  static const onboardingStart = '/onboarding/daily-goal';
  static const onboardingPrefix = '/onboarding/';
  static const gallery = '/gallery';

  /// Reachable without a session.
  static const auth = {welcome, '/sign-up', '/log-in', '/forgot-password'};
}

/// router.md redirect order: no session → /welcome; onboarding incomplete →
/// onboarding; else allow. Returns the path to go to, or null to stay.
String? sessionRedirect(SessionFlags session, String location) {
  // Splash decides where to go itself; the gallery is a debug tool.
  if (location == RedirectPaths.splash || location == RedirectPaths.gallery) {
    return null;
  }
  final isAuth = RedirectPaths.auth.contains(location);
  final isOnboarding = location.startsWith(RedirectPaths.onboardingPrefix);

  if (!session.loggedIn) return isAuth ? null : RedirectPaths.welcome;
  if (!session.onboardingDone) {
    return isOnboarding ? null : RedirectPaths.onboardingStart;
  }
  return isAuth || isOnboarding ? RedirectPaths.learn : null;
}
