import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/ranks/presentation/providers/ranks_providers.dart';
import 'package:ishara_app/features/ranks/presentation/screens/ranks_screen.dart';
import 'package:ishara_app/features/ranks/presentation/widgets/leaderboard_parts.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';

Future<void> _pump(
  WidgetTester tester, {
  ThemeMode mode = ThemeMode.light,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await pumpThemed(
    tester,
    ProviderScope(overrides: overrides, child: const RanksScreen()),
    mode: mode,
  );
  // Let chained futures (and error propagation) settle.
  await tester.pump();
  await tester.pump();
}

void main() {
  group('data', () {
    for (final mode in themeModes) {
      testWidgets('renders league header, banner and leaderboard ($mode)', (
        tester,
      ) async {
        await _pump(tester, mode: mode);
        final c = tokensFor(mode);

        expect(find.text('Bronze league'), findsOneWidget);
        expect(find.text('Week 12 · 30 learners'), findsOneWidget);
        expect(find.text('Ends in 3d 14h'), findsOneWidget);
        expect(
          find.text('Top 5 move up to Silver. You’re 60 XP away.'),
          findsOneWidget,
        );
        expect(
          find.byType(LeaderboardTile),
          findsNWidgets(fakeWeeklyLeaderboard.entries.length),
        );
        expect(find.text('PROMOTION ZONE'), findsOneWidget);
        expect(find.byType(HeroBackdrop), findsOneWidget);

        final me = tester.widget<LeaderboardTile>(
          find.widgetWithText(LeaderboardTile, 'You'),
        );
        expect(me.isMe, isTrue);
        expect(me.rank, 4);

        expect(textColor(tester, 'Bronze league'), c.staticWhite);
        expect(textColor(tester, 'You'), c.accentText);
        expect(textColor(tester, 'Sujata R.'), c.textPrimary);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('promotion line sits after the top 5', (tester) async {
      await _pump(tester);
      double y(Finder f) => tester.getTopLeft(f).dy;
      final line = find.byType(PromotionZoneDivider);
      expect(y(find.text('Prakash G.')), lessThan(y(line)));
      expect(y(line), lessThan(y(find.text('Rina M.'))));
    });

    testWidgets('fits at 1.3x text scale', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _pump(tester);
      expect(tester.takeException(), isNull);
    });
  });

  group('states', () {
    testWidgets('loading', (tester) async {
      final pending = Completer<WeeklyLeaderboard>();
      await _pump(
        tester,
        overrides: [
          weeklyLeaderboardProvider.overrideWith((_) => pending.future),
        ],
      );
      expect(find.byType(LeaderboardSkeleton), findsOneWidget);
      expect(find.text('Ranks'), findsOneWidget);
    });

    testWidgets('error', (tester) async {
      await _pump(
        tester,
        overrides: [
          weeklyLeaderboardProvider.overrideWith(
            (_) async => throw Exception('offline'),
          ),
        ],
      );
      expect(find.text('Couldn’t load the leaderboard'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(find.textContaining('offline'), findsNothing);
    });

    testWidgets('empty league', (tester) async {
      await _pump(
        tester,
        overrides: [
          weeklyLeaderboardProvider.overrideWith(
            (_) async => const WeeklyLeaderboard(
              leagueName: 'Bronze',
              nextLeagueName: 'Silver',
              weekNumber: 1,
              learnerCount: 0,
              endsIn: Duration(days: 1),
              promotionCount: 5,
              xpToPromotion: 0,
              entries: [],
            ),
          ),
        ],
      );
      expect(find.text('No one here yet'), findsOneWidget);
      expect(find.byType(LeaderboardTile), findsNothing);
    });
  });

  test('formatTimeLeft', () {
    expect(formatTimeLeft(const Duration(days: 3, hours: 14)), '3d 14h');
    expect(formatTimeLeft(const Duration(hours: 5, minutes: 20)), '5h 20m');
    expect(formatTimeLeft(const Duration(minutes: 45)), '45m');
  });

  testWidgets('is a tab root inside the shell', (tester) async {
    await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const RanksRoute().location,
    );
    expect(find.byType(RanksScreen), findsOneWidget);
    expect(find.byType(IsharaBottomBar), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });
}
