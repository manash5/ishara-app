import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../dev/gallery/widgets_gallery_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/log_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/dictionary/presentation/screens/dictionary_screen.dart';
import '../../features/dictionary/presentation/screens/sign_detail_screen.dart';
import '../../features/gamification/presentation/screens/out_of_hearts_screen.dart';
import '../../features/gamification/presentation/screens/streak_screen.dart';
import '../../features/learn/presentation/screens/learn_screen.dart';
import '../../features/lesson/presentation/screens/lesson_complete_screen.dart';
import '../../features/lesson/presentation/screens/lesson_player_screen.dart';
import '../../features/onboarding/presentation/screens/camera_permission_screen.dart';
import '../../features/onboarding/presentation/screens/camera_setup_check_screen.dart';
import '../../features/onboarding/presentation/screens/daily_goal_screen.dart';
import '../../features/onboarding/presentation/screens/dominant_hand_screen.dart';
import '../../features/practice/presentation/screens/practice_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/ranks/presentation/screens/ranks_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'app_shell.dart';

part 'app_routes.g.dart';

/// Root navigator: full-screen routes (settings, practice, lesson…) cover the
/// bottom bar.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

// ── Auth (01–05) ──────────────────────────────────────────────────────────

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SplashScreen();
}

@TypedGoRoute<WelcomeRoute>(path: '/welcome')
class WelcomeRoute extends GoRouteData with $WelcomeRoute {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WelcomeScreen();
}

@TypedGoRoute<SignUpRoute>(path: '/sign-up')
class SignUpRoute extends GoRouteData with $SignUpRoute {
  const SignUpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SignUpScreen();
}

@TypedGoRoute<LogInRoute>(path: '/log-in')
class LogInRoute extends GoRouteData with $LogInRoute {
  const LogInRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LogInScreen();
}

@TypedGoRoute<ForgotPasswordRoute>(path: '/forgot-password')
class ForgotPasswordRoute extends GoRouteData with $ForgotPasswordRoute {
  const ForgotPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgotPasswordScreen();
}

// ── Onboarding (06–09) ────────────────────────────────────────────────────

@TypedGoRoute<DailyGoalRoute>(path: '/onboarding/daily-goal')
class DailyGoalRoute extends GoRouteData with $DailyGoalRoute {
  const DailyGoalRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DailyGoalScreen();
}

@TypedGoRoute<DominantHandRoute>(path: '/onboarding/hand')
class DominantHandRoute extends GoRouteData with $DominantHandRoute {
  const DominantHandRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DominantHandScreen();
}

@TypedGoRoute<CameraPermissionRoute>(path: '/onboarding/camera-permission')
class CameraPermissionRoute extends GoRouteData with $CameraPermissionRoute {
  const CameraPermissionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CameraPermissionScreen();
}

@TypedGoRoute<CameraCheckRoute>(path: '/onboarding/camera-check')
class CameraCheckRoute extends GoRouteData with $CameraCheckRoute {
  const CameraCheckRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CameraSetupCheckScreen();
}

// ── Shell: Learn · Dictionary · Ranks · Profile (10–16) ───────────────────

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<LearnBranch>(
      routes: [TypedGoRoute<LearnRoute>(path: '/learn')],
    ),
    TypedStatefulShellBranch<DictionaryBranch>(
      routes: [
        TypedGoRoute<DictionaryRoute>(
          path: '/dictionary',
          routes: [TypedGoRoute<SignDetailRoute>(path: ':signId')],
        ),
      ],
    ),
    TypedStatefulShellBranch<RanksBranch>(
      routes: [TypedGoRoute<RanksRoute>(path: '/ranks')],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [TypedGoRoute<ProfileRoute>(path: '/profile')],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AppShell(navigationShell: navigationShell);
}

class LearnBranch extends StatefulShellBranchData {
  const LearnBranch();
}

class DictionaryBranch extends StatefulShellBranchData {
  const DictionaryBranch();
}

class RanksBranch extends StatefulShellBranchData {
  const RanksBranch();
}

class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();
}

class LearnRoute extends GoRouteData with $LearnRoute {
  const LearnRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LearnScreen();
}

class DictionaryRoute extends GoRouteData with $DictionaryRoute {
  const DictionaryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DictionaryScreen();
}

class SignDetailRoute extends GoRouteData with $SignDetailRoute {
  const SignDetailRoute({required this.signId});

  final String signId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SignDetailScreen(signId: signId);
}

class RanksRoute extends GoRouteData with $RanksRoute {
  const RanksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RanksScreen();
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

// ── Full-screen (17, practice, 18–28) ─────────────────────────────────────

@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

/// Centre bottom-bar action — not a tab.
@TypedGoRoute<PracticeRoute>(path: '/practice')
class PracticeRoute extends GoRouteData with $PracticeRoute {
  const PracticeRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PracticeScreen();
}

/// Frames 18–25: one player, exercises are states, not routes.
@TypedGoRoute<LessonRoute>(path: '/lesson/:lessonId')
class LessonRoute extends GoRouteData with $LessonRoute {
  const LessonRoute({required this.lessonId});

  final String lessonId;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      LessonPlayerScreen(lessonId: lessonId);
}

@TypedGoRoute<LessonCompleteRoute>(path: '/lesson/:lessonId/complete')
class LessonCompleteRoute extends GoRouteData with $LessonCompleteRoute {
  const LessonCompleteRoute({required this.lessonId});

  final String lessonId;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      LessonCompleteScreen(lessonId: lessonId);
}

@TypedGoRoute<StreakRoute>(path: '/streak')
class StreakRoute extends GoRouteData with $StreakRoute {
  const StreakRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StreakScreen();
}

@TypedGoRoute<OutOfHeartsRoute>(path: '/out-of-hearts')
class OutOfHeartsRoute extends GoRouteData with $OutOfHeartsRoute {
  const OutOfHeartsRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OutOfHeartsScreen();
}

// ── Debug ─────────────────────────────────────────────────────────────────

/// Widget gallery + fake-session switches. Only registered in debug builds
/// (see `appRoutes` in app_router.dart).
@TypedGoRoute<GalleryRoute>(path: '/gallery')
class GalleryRoute extends GoRouteData with $GalleryRoute {
  const GalleryRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WidgetsGalleryScreen();
}
