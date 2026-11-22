import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/learn/presentation/providers/learn_path_provider.dart';
import 'package:ishara_app/features/learn/presentation/screens/learn_offline_view.dart';
import 'package:ishara_app/features/learn/presentation/screens/learn_screen.dart';
import 'package:ishara_app/features/learn/presentation/widgets/learn_path_view.dart';
import 'package:ishara_app/features/learn/presentation/widgets/trek_painters.dart';
import 'package:ishara_app/features/learn/presentation/widgets/trek_widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/load_states.dart';
import '../../../../helpers/mock_api.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';

Finder markerIn(PathNodeState state) =>
    find.byWidgetPredicate((w) => w is WaypointMarker && w.state == state);

void main() {
  Future<ProviderContainer> pumpLearn(
    WidgetTester tester, {
    ThemeMode mode = ThemeMode.light,
  }) async {
    if (mode == ThemeMode.dark) {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    }
    return pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const LearnRoute().location,
    );
  }

  for (final mode in themeModes) {
    testWidgets('trek roadmap shows Unit 1 from base camp up (${mode.name})', (
      tester,
    ) async {
      await pumpLearn(tester, mode: mode);
      final c = tokensFor(mode);

      final stats = tester.widget<StatsBar>(find.byType(StatsBar));
      // Total XP from /me (1240), not this week's.
      expect((stats.streak, stats.xp, stats.hearts), (12, 1240, 5));

      // Base camp banner for Unit 1 with its progress.
      expect(find.text('Greetings & etiquette'), findsOneWidget);
      expect(find.text('4/12'), findsOneWidget);

      // Waypoints: two learned, a review, prayer flags, the current card.
      expect(markerIn(PathNodeState.completed), findsNWidgets(2));
      expect(markerIn(PathNodeState.review), findsOneWidget);
      expect(find.byType(PrayerFlags), findsWidgets);
      expect(find.byType(CurrentLessonCard), findsOneWidget);
      expect(find.text('Thank you'), findsOneWidget);
      expect(find.text('3 signs · 5 min'), findsOneWidget);

      // Danu guides from beside the current card.
      expect(
        tester.widget<DanuMascot>(find.byType(DanuMascot)).pose,
        DanuPose.wave,
      );
      expect(
        tester
            .widget<Scaffold>(
              find.descendant(
                of: find.byType(LearnScreen),
                matching: find.byType(Scaffold),
              ),
            )
            .backgroundColor,
        c.bgCanvas,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the trail climbs: base camp, then Hello, then the current', (
    tester,
  ) async {
    await pumpLearn(tester);
    final hello = tester.getCenter(find.text('Hello'));
    final current = tester.getCenter(find.byType(CurrentLessonCard));
    final banner = tester.getCenter(find.text('Greetings & etiquette'));
    expect(hello.dy, greaterThan(current.dy));
    expect(banner.dy, greaterThan(hello.dy));
  });

  testWidgets('scrolling up reaches the summit and the next stage', (
    tester,
  ) async {
    await pumpLearn(tester);
    final path = find.byKey(const Key('learn-path'));
    await tester.scrollUntilVisible(
      find.text('Fingerspelling vowels'),
      300,
      scrollable: find.descendant(of: path, matching: find.byType(Scrollable)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Fingerspelling vowels'), findsOneWidget);
    expect(find.text('Summit'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  test('waypoints sway either side of the centre line', () {
    final xs = [for (var i = 0; i < 8; i++) PathLayout.xOf(i)];
    expect(xs.any((x) => x < 0.5), isTrue);
    expect(xs.any((x) => x > 0.5), isTrue);
    for (final x in xs) {
      expect(x, inInclusiveRange(0.5 - PathLayout.sway, 0.5 + PathLayout.sway));
    }
  });

  test('trail curve passes through every waypoint', () {
    const pts = [Offset(0, 100), Offset(50, 50), Offset(0, 0)];
    final path = TrailPainter.curveThrough(pts);
    for (final p in pts) {
      expect(path.getBounds().inflate(1).contains(p), isTrue);
    }
  });

  testWidgets('Start on the current card opens the lesson sheet (11)', (
    tester,
  ) async {
    await pumpLearn(tester);
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    expect(find.textContaining('lesson sheet · Thank you'), findsOneWidget);
  });

  testWidgets('learned waypoints reopen their lesson', (tester) async {
    await pumpLearn(tester);
    await tester.tap(find.text('Namaste'));
    await tester.pumpAndSettle();
    expect(find.textContaining('lesson sheet · Namaste'), findsOneWidget);
  });

  testWidgets('locked waypoints explain themselves visually', (tester) async {
    await pumpLearn(tester);
    // Bring "Sorry" (just above the current card) to mid-screen.
    final dy = 450 - tester.getCenter(find.text('Sorry')).dy;
    await tester.drag(find.byKey(const Key('learn-path')), Offset(0, dy));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sorry'));
    await tester.pump();
    expect(
      find.text('Finish the lessons above to unlock this one.'),
      findsOneWidget,
    );
  });

  testWidgets('waypoints are buttons named by lesson and status', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpLearn(tester);
    expect(find.bySemanticsLabel('Namaste, Learned'), findsOneWidget);
    expect(find.bySemanticsLabel('Sorry, Locked'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('offline (12) replaces the roadmap and can retry', (
    tester,
  ) async {
    final container = await pumpLearn(tester);
    container.read(learnOfflineProvider.notifier).set(true);
    await tester.pumpAndSettle();
    expect(find.byType(LearnOfflineView), findsOneWidget);
    expect(find.byType(LearnPathView), findsNothing);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.byType(LearnPathView), findsOneWidget);
  });

  testWidgets('first load: rows fade in and the trail draws itself', (
    tester,
  ) async {
    await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const LearnRoute().location,
      settle: false,
      animate: true,
    );
    await tester.pump();
    await pumpApi(tester);
    double helloOpacity() => tester
        .widget<Opacity>(
          find
              .ancestor(of: find.text('Hello'), matching: find.byType(Opacity))
              .first,
        )
        .opacity;
    expect(helloOpacity(), lessThan(1));
    await tester.pump(IsharaMotion.celebrate * 2);
    expect(helloOpacity(), 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders without errors at 1.3× text', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpLearn(tester);
    expect(find.byType(LearnScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('header band starts at the top, behind the status bar', (
    tester,
  ) async {
    tester.view.padding = const FakeViewPadding(top: 24 * 2.625);
    addTearDown(tester.view.resetPadding);
    await pumpLearn(tester);
    expect(tester.getRect(find.byKey(const Key('learn-header'))).top, 0);
    expect(tester.getRect(find.byType(StatsBar)).top, 24);
  });

  testWidgets('Danu on the trek is the animated, waving Danu', (tester) async {
    await pumpLearn(tester);
    final danu = tester.widget<DanuMascot>(find.byType(DanuMascot));
    expect(danu.pose, DanuPose.wave);
    expect(danu.animated, isTrue);
  });

  loadStateTests(
    location: const LearnRoute().location,
    errorTitle: 'Couldn’t load your path',
    loadingLabel: 'Loading your path',
  );
}
