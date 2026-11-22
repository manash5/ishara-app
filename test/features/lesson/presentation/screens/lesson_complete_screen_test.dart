import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/dictionary/presentation/screens/sign_detail_screen.dart';
import 'package:ishara_app/features/gamification/presentation/screens/streak_screen.dart';
import 'package:ishara_app/features/lesson/presentation/screens/lesson_complete_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';

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

  Future<void> pumpComplete(
    WidgetTester tester, {
    ThemeMode mode = ThemeMode.light,
    bool reduced = false,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
              child: const LessonCompleteScreen(lessonId: 'l1'),
            ),
          ),
        ),
      ),
    );
  }

  DanuMascot danu(WidgetTester tester) =>
      tester.widget<DanuMascot>(find.byType(DanuMascot));

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('Figma 26 content (${mode.name})', (tester) async {
      await pumpComplete(tester, mode: mode, reduced: true);
      expect(find.byType(HeroBackdrop), findsOneWidget);
      expect(find.text('Lesson complete!'), findsOneWidget);
      expect(textColor(tester, 'Lesson complete!'), c.staticWhite);
      expect(find.text('You learned 5 new greetings.'), findsOneWidget);
      expect(find.text('Your results'), findsOneWidget);
      expect(find.text('+15'), findsOneWidget);
      expect(find.text('92%'), findsOneWidget);
      expect(find.text('4:12'), findsOneWidget);
      expect(find.text('Signs you learned'), findsOneWidget);
      expect(find.widgetWithText(SignListTile, 'Namaste'), findsOneWidget);
      expect(find.widgetWithText(SignListTile, 'Thank you'), findsOneWidget);
      expect(find.text('Learned'), findsNWidgets(2));
      expect(find.text('Continue'), findsOneWidget);
      // Badge to the left of the title, not above it.
      final badge = tester.getRect(find.byIcon(IsharaIcons.check));
      final title = tester.getRect(find.text('Lesson complete!'));
      expect(badge.right, lessThan(title.left));
      expect(badge.center.dy, closeTo(title.bottom, IsharaSizes.resultBadge));
      // No lime circle on the right of the title.
      final backdrop = tester.widget<HeroBackdrop>(find.byType(HeroBackdrop));
      expect(backdrop.layout, HeroBackdropLayout.results);
      // Danu waves (roadmap animation) on the right, straddling the hero
      // and the white results panel.
      expect(danu(tester).pose, DanuPose.wave);
      expect(danu(tester).animated, isTrue);
      final danuRect = tester.getRect(find.byType(DanuMascot));
      final heroRect = tester.getRect(find.byType(HeroBackdrop));
      final panelTop = tester.getRect(find.byType(ContentPanel)).top;
      expect(danuRect.left, greaterThan(heroRect.width / 2));
      expect(danuRect.top, lessThan(panelTop));
      expect(danuRect.bottom, greaterThan(panelTop));
      expect(danuRect.top, greaterThanOrEqualTo(title.bottom));
      // Stat icons (Figma Light + Dark): XP text/primary, others accent.
      final cards = tester.widgetList<StatCard>(find.byType(StatCard)).toList();
      expect(cards.map((s) => s.iconColor), [
        c.textPrimary,
        c.accentText,
        c.accentText,
      ]);
    });
  }

  testWidgets('celebrates: XP counts up, Danu pops in then keeps waving, '
      'confetti ends within 1.5 s, light haptic', (tester) async {
    await pumpComplete(tester);
    expect(haptics, contains('HapticFeedbackType.lightImpact'));
    expect(find.text('+15'), findsNothing);
    double danuScale() => tester
        .widget<ScaleTransition>(
          find.ancestor(
            of: find.byType(DanuMascot),
            matching: find.byType(ScaleTransition),
          ),
        )
        .scale
        .value;
    // Danu pops in just after the badge.
    expect(danuScale(), 0);

    await tester.pump(IsharaMotion.celebrate ~/ 2);
    expect(find.text('+15'), findsNothing);
    expect(danuScale(), greaterThan(0));

    await tester.pump(IsharaMotion.celebrate);
    expect(find.text('+15'), findsOneWidget);
    expect(danuScale(), 1);

    // The wave loops forever, so pump fixed time instead of settling.
    await tester.pump(IsharaMotion.confetti);
    final confetti = find.descendant(
      of: find.byType(ConfettiBurst),
      matching: find.byType(CustomPaint),
    );
    expect(confetti, findsNothing);
    expect(tester.hasRunningAnimations, isTrue); // Danu still waving
  });

  testWidgets('reduced motion: final values at once, no confetti', (
    tester,
  ) async {
    await pumpComplete(tester, reduced: true);
    expect(find.text('+15'), findsOneWidget);
    // Still wave pose, but no loop.
    expect(danu(tester).pose, DanuPose.wave);
    expect(tester.hasRunningAnimations, isFalse);
    expect(
      find.descendant(
        of: find.byType(ConfettiBurst),
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );
  });

  testWidgets('Continue → Streak (27); a sign opens its detail', (
    tester,
  ) async {
    await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const LessonCompleteRoute(lessonId: 'l1').location,
    );
    await tester.tap(find.widgetWithText(SignListTile, 'Namaste'));
    await tester.pumpAndSettle();
    expect(find.byType(SignDetailScreen), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(StreakScreen), findsOneWidget);
  });

  test('formatLessonTime pads seconds', () {
    expect(formatLessonTime(const Duration(minutes: 4, seconds: 12)), '4:12');
    expect(formatLessonTime(const Duration(minutes: 1, seconds: 5)), '1:05');
  });
}
