import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/gamification/presentation/screens/streak_screen.dart';
import 'package:ishara_app/features/gamification/presentation/widgets/week_streak_row.dart';
import 'package:ishara_app/features/learn/presentation/screens/learn_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/load_states.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import '../../../../helpers/mock_api.dart';

void main() {
  late List<Object?> haptics;

  setUp(() {
    haptics = [];
    TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'HapticFeedback.vibrate') {
            haptics.add(call.arguments);
          }
          return null;
        });
  });

  Future<void> pumpStreak(
    WidgetTester tester, {
    ThemeMode mode = ThemeMode.light,
    bool reduced = false,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: mockApiOverrides(),
        child: MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                disableAnimations: reduced,
                textScaler: TextScaler.linear(textScale),
              ),
              child: const StreakScreen(),
            ),
          ),
        ),
      ),
    );
    await pumpApi(tester);
  }

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('Figma 27 content (${mode.name})', (tester) async {
      await pumpStreak(tester, mode: mode, reduced: true);
      expect(find.text('12'), findsOneWidget);
      expect(textColor(tester, '12'), c.staticWhite);
      expect(find.text('day streak'), findsOneWidget);
      expect(find.text('This week'), findsOneWidget);
      expect(find.byType(WeekStreakRow), findsOneWidget);
      // Every day this week earned XP (/me stats), today is Sunday.
      expect(find.byIcon(IsharaIcons.check), findsNWidgets(7));
      expect(find.text('21'), findsOneWidget);
      expect(find.text('Longest streak'), findsOneWidget);
      expect(find.text('Streak freeze ready'), findsOneWidget);
      expect(
        find.text(
          'Practise tomorrow to keep it going. A streak freeze is ready if '
          'you miss a day.',
        ),
        findsOneWidget,
      );
      // Flame + the count over "day streak", centred left of Danu; Danu
      // (bigger than on 26) at the right edge, feet on the white panel.
      final flame = tester.getRect(
        find.byWidgetPredicate(
          (w) => w is IsharaFilledIcon && w.kind == IsharaFilledIconKind.flame,
        ),
      );
      final count = tester.getRect(find.text('12'));
      final caption = tester.getRect(find.text('day streak'));
      final danuRect = tester.getRect(find.byType(DanuMascot));
      final heroWidth = tester.getSize(find.byType(HeroBackdrop)).width;
      final panelTop = tester.getRect(find.byType(ContentPanel)).top;
      expect(flame.right, lessThan(count.left));
      expect(caption.left, count.left);
      expect(caption.top, greaterThanOrEqualTo(count.bottom));
      expect(danuRect.size, const Size.square(IsharaSizes.streakMascot));
      expect(danuRect.right, heroWidth - IsharaSpacing.screenMargin);
      expect(
        math.max(count.right, caption.right),
        lessThanOrEqualTo(danuRect.left),
      );
      // Centred in the space left of Danu: the hero row spans exactly that
      // space and centres its content.
      final heroRow = find
          .ancestor(
            of: find.text('day streak'),
            matching: find.byWidgetPredicate(
              (w) =>
                  w is Row && w.mainAxisAlignment == MainAxisAlignment.center,
            ),
          )
          .first;
      final rowRect = tester.getRect(heroRow);
      expect(rowRect.left, IsharaSpacing.screenMargin);
      expect(rowRect.right, closeTo(danuRect.left, 0.01));
      // Beside the text, not below it.
      expect(danuRect.top, lessThanOrEqualTo(caption.top));
      expect(danuRect.bottom, greaterThan(caption.bottom));
      // Just touching the white.
      expect(danuRect.bottom - panelTop, IsharaSizes.streakMascotDip);
      // Today (Sunday, the last "S") is labelled in text/primary, other
      // days tertiary.
      expect(renderedStyle(tester, find.text('S').last)?.color, c.textPrimary);
      expect(
        renderedStyle(tester, find.text('S').first)?.color,
        c.textTertiary,
      );
      expect(textColor(tester, 'F'), c.textTertiary);
    });
  }

  testWidgets('celebrates: count-up, Danu cheering, confetti, medium haptic', (
    tester,
  ) async {
    await pumpStreak(tester);
    expect(haptics, contains('HapticFeedbackType.mediumImpact'));
    final danu = tester.widget<DanuMascot>(find.byType(DanuMascot));
    expect(danu.pose, DanuPose.celebrate);
    expect(danu.animated, isTrue);
    expect(find.text('12'), findsNothing);
    await tester.pump(IsharaMotion.celebrate);
    await tester.pump(IsharaMotion.fast);
    expect(find.text('12'), findsOneWidget);
    // The cheer loops forever, so pump fixed time instead of settling.
    await tester.pump(IsharaMotion.confetti);
    expect(
      find.descendant(
        of: find.byType(ConfettiBurst),
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );
  });

  testWidgets('the one-line hero fits at 1.3x text scale', (tester) async {
    await pumpStreak(tester, reduced: true, textScale: 1.3);
    expect(tester.takeException(), isNull);
    expect(find.text('day streak'), findsOneWidget);
    final hero = tester.getRect(find.byType(HeroBackdrop));
    expect(
      tester.getRect(find.byType(DanuMascot)).right,
      lessThanOrEqualTo(hero.right),
    );
  });

  testWidgets('Continue → Learn', (tester) async {
    await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const StreakRoute().location,
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(LearnScreen), findsOneWidget);
  });

  loadStateTests(
    location: const StreakRoute().location,
    errorTitle: 'Couldn’t load your streak',
    loadingLabel: 'Loading your streak',
  );
}
