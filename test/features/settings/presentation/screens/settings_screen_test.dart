import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/features/auth/presentation/providers/session_provider.dart';
import 'package:ishara_app/features/profile/domain/entities/user_profile.dart';
import 'package:ishara_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:ishara_app/features/settings/presentation/providers/settings_provider.dart';
import 'package:ishara_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import '../../../auth/auth_test_utils.dart';

void main() {
  late ProviderContainer container;
  late AuthTestEnv env;

  Future<void> pumpSettings(
    WidgetTester tester, {
    ThemeMode mode = ThemeMode.light,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    env = AuthTestEnv(
      session: const SessionState(
        ready: true,
        loggedIn: true,
        onboardingDone: true,
      ),
    );
    await env.storeTokens();
    container = env.container();
    await pumpThemed(
      tester,
      MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: UncontrolledProviderScope(
          container: container,
          child: const SettingsScreen(),
        ),
      ),
      mode: mode,
    );
    await settleFlow(tester);
  }

  Finder tile(String label) =>
      find.widgetWithText(SettingsTile, label, skipOffstage: false);

  Future<void> tapTile(WidgetTester tester, String label) async {
    await tester.ensureVisible(tile(label));
    await tester.tap(tile(label));
    await settleFlow(tester);
  }

  for (final mode in themeModes) {
    testWidgets('shows the Figma groups and values in ${mode.name} mode', (
      tester,
    ) async {
      await pumpSettings(tester, mode: mode);
      final c = tokensFor(mode);

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byTooltip('Back'), findsOneWidget);
      for (final title in ['LEARNING', 'APP', 'ACCOUNT']) {
        expect(find.text(title), findsOneWidget, reason: title);
      }
      for (final text in [
        'Daily goal',
        '10 min',
        'Dominant hand',
        'Right',
        'Camera feedback',
        'Theme',
        'System',
        'Daily reminder',
        '7:00 PM',
        'Language',
        'English',
        'Privacy & data',
        'Log out',
      ]) {
        expect(
          find.text(text, skipOffstage: false),
          findsOneWidget,
          reason: text,
        );
      }
      expect(textColor(tester, 'Daily goal'), c.textPrimary);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('debug section sits last, below the version line', (
    tester,
  ) async {
    await pumpSettings(tester);
    final groups = tester
        .widgetList<SettingsGroup>(
          find.byType(SettingsGroup, skipOffstage: false),
        )
        .map((g) => g.title)
        .toList();
    expect(groups, ['Learning', 'App', 'Account', 'Debug']);
    expect(
      find.text('Ishara v1.0 · Thesis prototype', skipOffstage: false),
      findsOneWidget,
    );
    expect(tile('Widget gallery'), findsOneWidget);
    expect(tile('Redo onboarding'), findsOneWidget);
  });

  testWidgets('camera feedback toggle is saved on the device', (tester) async {
    await pumpSettings(tester);
    expect(container.read(settingsProvider).cameraFeedback, isTrue);

    await tapTile(tester, 'Camera feedback');
    expect(container.read(settingsProvider).cameraFeedback, isFalse);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    expect(env.hive.settings.get('settings.cameraFeedback'), isFalse);

    await tester.tap(find.byType(Switch));
    await settleFlow(tester);
    expect(container.read(settingsProvider).cameraFeedback, isTrue);
  });

  testWidgets('theme cycles and is saved on the device', (tester) async {
    await pumpSettings(tester);
    await tapTile(tester, 'Theme');
    expect(container.read(settingsProvider).theme, ThemePreference.light);
    expect(container.read(themeModeProvider), ThemeMode.light);
    expect(env.hive.settings.get('settings.theme'), 'light');
    await tapTile(tester, 'Theme');
    expect(container.read(settingsProvider).theme, ThemePreference.dark);
    await tapTile(tester, 'Theme');
    expect(container.read(settingsProvider).theme, ThemePreference.system);
  });

  testWidgets('dominant hand is saved to the profile (PUT /me)', (
    tester,
  ) async {
    await pumpSettings(tester);
    await tapTile(tester, 'Dominant hand');
    expect(container.read(settingsProvider).dominantHand, Hand.left);
    expect(find.text('Left', skipOffstage: false), findsOneWidget);
  });

  testWidgets('daily goal cycles 10 → 15 min via PUT /me', (tester) async {
    await pumpSettings(tester);
    await tapTile(tester, 'Daily goal');
    expect(container.read(settingsProvider).dailyGoalMinutes, 15);
    expect(find.text('15 min', skipOffstage: false), findsOneWidget);
  });

  testWidgets('a failed profile save shows a snackbar', (tester) async {
    await pumpSettings(tester);
    env.simulation = MockApiSimulation.serverError;
    await tapTile(tester, 'Daily goal');
    expect(
      find.text('Something went wrong on our side. Try again soon.'),
      findsOne,
    );
    expect(container.read(settingsProvider).dailyGoalMinutes, 10);
  });

  testWidgets('log out ends the session and clears the device', (tester) async {
    await pumpSettings(tester);
    await tapTile(tester, 'Log out');
    expect(container.read(sessionProvider), SessionState.signedOut);
    expect(await env.tokens.read(), isNull);
    expect(env.hive.cache.isEmpty, isTrue);
  });

  group('delete account', () {
    Finder dialogButton(String label) => find.descendant(
      of: find.byType(ConfirmDialog),
      matching: find.widgetWithText(IsharaButton, label),
    );

    testWidgets('sits in Account, in danger, below Log out', (tester) async {
      await pumpSettings(tester);
      final delete = tester.widget<SettingsTile>(tile('Delete account'));
      expect(delete.destructive, isTrue);
      expect(
        tester.getTopLeft(tile('Delete account')).dy,
        greaterThan(tester.getTopLeft(tile('Log out')).dy),
      );
    });

    testWidgets('asks first; Cancel keeps the account', (tester) async {
      await pumpSettings(tester);
      await tapTile(tester, 'Delete account');
      expect(find.text('Delete your account?'), findsOneWidget);
      final confirm = tester.widget<IsharaButton>(
        dialogButton('Delete account'),
      );
      expect(confirm.tone, IsharaButtonTone.danger);

      await tester.tap(dialogButton('Cancel'));
      await settleFlow(tester);
      expect(find.byType(ConfirmDialog), findsNothing);
      expect(container.read(sessionProvider).loggedIn, isTrue);
      expect(await env.tokens.read(), isNotNull);
    });

    testWidgets('confirm: DELETE /me, then the session ends and the device '
        'is cleared', (tester) async {
      await pumpSettings(tester);
      await tapTile(tester, 'Delete account');
      await tester.tap(dialogButton('Delete account'));
      await settleFlow(tester);
      expect(container.read(sessionProvider).loggedIn, isFalse);
      expect(await env.tokens.read(), isNull);
      expect(env.hive.cache.isEmpty, isTrue);
    });

    testWidgets('a failed delete keeps the learner signed in and says why', (
      tester,
    ) async {
      await pumpSettings(tester);
      env.simulation = MockApiSimulation.serverError;
      await tapTile(tester, 'Delete account');
      await tester.tap(dialogButton('Delete account'));
      await settleFlow(tester);
      expect(
        find.text('Something went wrong on our side. Try again soon.'),
        findsOneWidget,
      );
      expect(container.read(sessionProvider).loggedIn, isTrue);
      expect(await env.tokens.read(), isNotNull);
    });
  });

  testWidgets('redo onboarding clears onboardingDone', (tester) async {
    await pumpSettings(tester);
    await tapTile(tester, 'Redo onboarding');
    final session = container.read(sessionProvider);
    expect(session.loggedIn, isTrue);
    expect(session.onboardingDone, isFalse);
  });

  testWidgets('lays out at 1.3x text scale in dark mode', (tester) async {
    await pumpSettings(tester, mode: ThemeMode.dark, textScale: 1.3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('back returns to Profile', (tester) async {
    await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const ProfileRoute().location,
    );
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  // Regression: on a phone (status bar on top) the header was squeezed: the
  // title was cut off and there was no back button to tap.
  testWidgets('under a status bar: full title and a working back button', (
    tester,
  ) async {
    await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const ProfileRoute().location,
    );
    tester.view.padding = const FakeViewPadding(top: 63); // 24dp
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    // The full 64dp toolbar sits below the 24dp status bar.
    final bar = tester.getRect(find.byType(IsharaTopAppBar));
    expect(bar.height, 24 + IsharaSizes.appBarHeight);
    final toolbarMiddle = 24 + IsharaSizes.appBarHeight / 2;
    expect(
      tester.getRect(find.text('Settings')).center.dy,
      closeTo(toolbarMiddle, 1),
    );
    expect(
      tester.getRect(find.byTooltip('Back')).center.dy,
      closeTo(toolbarMiddle, 1),
    );
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
