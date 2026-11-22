import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:ishara_app/features/profile/presentation/widgets/profile_hero.dart';
import 'package:ishara_app/features/profile/presentation/widgets/weekly_xp_chart.dart';
import 'package:ishara_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/load_states.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

void main() {
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
  }

  Future<void> pumpProfile(
    WidgetTester tester, {
    ThemeMode mode = ThemeMode.light,
  }) async {
    phone(tester);
    await pumpThemed(
      tester,
      ProviderScope(
        overrides: mockApiOverrides(),
        child: const ProfileScreen(),
      ),
      mode: mode,
    );
    await tester.pumpAndSettle();
  }

  for (final mode in themeModes) {
    testWidgets('shows the fake profile in ${mode.name} mode', (tester) async {
      await pumpProfile(tester, mode: mode);
      final c = tokensFor(mode);

      expect(find.text('Manash Lamichhane'), findsOneWidget);
      expect(find.text('Learning NSL since Nov 2026'), findsOneWidget);
      expect(find.byType(HeroBackdrop), findsOneWidget);
      expect(find.text('Your stats'), findsOneWidget);
      expect(find.byType(StatCard), findsNWidgets(4));
      for (final text in [
        '12',
        'Day streak',
        '1,240',
        'Total XP',
        '18',
        'Signs learned',
        '87%',
        'Camera accuracy',
        'This week',
        'Details',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(find.byType(WeeklyXpChart), findsOneWidget);
      expect(textColor(tester, 'Manash Lamichhane'), c.staticWhite);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('has no back button and pads for the bottom bar', (tester) async {
    await pumpProfile(tester);
    expect(find.byTooltip('Back'), findsNothing);
    expect(find.byTooltip('Settings'), findsOneWidget);
  });

  testWidgets('lays out at 1.3x text scale', (tester) async {
    phone(tester);
    await pumpThemed(
      tester,
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: ProviderScope(
          overrides: mockApiOverrides(),
          child: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  test('formatting helpers', () {
    expect(groupThousands(1240), '1,240');
    expect(groupThousands(999), '999');
    expect(groupThousands(1234567), '1,234,567');
    expect(monthYear(DateTime(2026, 11)), 'Nov 2026');
  });

  testWidgets('settings button opens Settings over the bottom bar', (
    tester,
  ) async {
    await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const ProfileRoute().location,
    );
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.byType(IsharaBottomBar), findsOneWidget);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byType(IsharaBottomBar), findsNothing);
  });

  loadStateTests(
    location: const ProfileRoute().location,
    errorTitle: 'Couldn’t load your profile',
    loadingLabel: 'Loading your profile',
  );

  group('offline', () {
    Future<void> pumpOffline(
      WidgetTester tester, {
      required bool cached,
    }) async {
      phone(tester);
      if (cached) {
        await TestHive.instance.putCache(
          ProfileLocalDataSource.cacheKey,
          fixtureData<Map<String, dynamic>>('me/get_200'),
          fetchedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        );
      }
      await pumpThemed(
        tester,
        ProviderScope(
          overrides: mockApiOverrides(simulation: MockApiSimulation.offline),
          child: const ProfileScreen(),
        ),
      );
      await pumpApi(tester);
      await tester.pumpAndSettle();
    }

    testWidgets('shows the cached stats and when they were updated', (
      tester,
    ) async {
      await pumpOffline(tester, cached: true);
      expect(find.text('1,240'), findsOneWidget);
      expect(find.text('Couldn’t load your profile'), findsNothing);
      final chip = tester.widget<IsharaChip>(
        find.byKey(const Key('profile-offline-chip')),
      );
      expect(chip.label, 'Offline · updated 5 min ago');
    });

    testWidgets('with nothing cached: the error state', (tester) async {
      await pumpOffline(tester, cached: false);
      expect(find.text('Couldn’t load your profile'), findsOneWidget);
    });

    testWidgets('online: no offline chip', (tester) async {
      await pumpProfile(tester);
      expect(find.byKey(const Key('profile-offline-chip')), findsNothing);
    });
  });
}
