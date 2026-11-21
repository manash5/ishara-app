import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/presentation/providers/fake_session_provider.dart';
import 'package:ishara_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:ishara_app/features/settings/presentation/providers/settings_provider.dart';
import 'package:ishara_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';

void main() {
  late ProviderContainer container;

  Future<void> pumpSettings(
    WidgetTester tester, {
    ThemeMode mode = ThemeMode.light,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(fakeSessionProvider.notifier).logIn();
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
    await tester.pumpAndSettle();
  }

  Finder tile(String label) =>
      find.widgetWithText(SettingsTile, label, skipOffstage: false);

  Future<void> tapTile(WidgetTester tester, String label) async {
    await tester.ensureVisible(tile(label));
    await tester.tap(tile(label));
    await tester.pumpAndSettle();
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

  testWidgets('camera feedback toggle updates provider state', (tester) async {
    await pumpSettings(tester);
    expect(container.read(settingsProvider).cameraFeedback, isTrue);

    await tapTile(tester, 'Camera feedback');
    expect(container.read(settingsProvider).cameraFeedback, isFalse);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(container.read(settingsProvider).cameraFeedback, isTrue);
  });

  testWidgets('dominant hand and theme rows update provider state', (
    tester,
  ) async {
    await pumpSettings(tester);

    await tapTile(tester, 'Dominant hand');
    expect(container.read(settingsProvider).dominantHand, DominantHand.left);
    expect(find.text('Left'), findsOneWidget);

    await tapTile(tester, 'Theme');
    expect(container.read(settingsProvider).theme, ThemePreference.light);
    await tapTile(tester, 'Theme');
    expect(container.read(settingsProvider).theme, ThemePreference.dark);
    await tapTile(tester, 'Theme');
    expect(container.read(settingsProvider).theme, ThemePreference.system);
  });

  testWidgets('log out flips the fake session', (tester) async {
    await pumpSettings(tester);
    await tapTile(tester, 'Log out');
    expect(container.read(fakeSessionProvider).loggedIn, isFalse);
  });

  testWidgets('redo onboarding clears onboardingDone', (tester) async {
    await pumpSettings(tester);
    await tapTile(tester, 'Redo onboarding');
    final session = container.read(fakeSessionProvider);
    expect(session.loggedIn, isTrue);
    expect(session.onboardingDone, isFalse);
  });

  testWidgets('lays out at 1.3x text scale in dark mode', (tester) async {
    await pumpSettings(tester, mode: ThemeMode.dark, textScale: 1.3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('back returns to Profile; log out goes to welcome', (
    tester,
  ) async {
    final app = await pumpApp(
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

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(tile('Log out'));
    await tester.tap(tile('Log out'));
    await tester.pumpAndSettle();
    expect(app.read(fakeSessionProvider).loggedIn, isFalse);
    expect(currentLocation(app), const WelcomeRoute().location);
  });
}
