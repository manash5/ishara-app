import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/config/game_rules.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/gamification/presentation/screens/out_of_hearts_screen.dart';
import 'package:ishara_app/features/learn/presentation/screens/learn_screen.dart';
import 'package:ishara_app/features/practice/presentation/screens/practice_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/mock_api.dart';
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

  Future<void> pumpScreen(
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
              child: const OutOfHeartsScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pump(IsharaMotion.celebrate);
  }

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('28 as a results page: title, empty hearts, sad Danu, '
        'two actions, no confetti (${mode.name})', (tester) async {
      await pumpScreen(tester, mode: mode);
      final results = tester.widget<ResultsScaffold>(
        find.byType(ResultsScaffold),
      );
      expect(results.celebrate, isFalse);
      expect(results.backdrop, HeroBackdropLayout.results);
      expect(find.byType(ConfettiBurst), findsNothing);

      expect(find.text('You’re out of hearts'), findsOneWidget);
      expect(textColor(tester, 'You’re out of hearts'), c.staticWhite);
      expect(find.byIcon(IsharaIcons.heartCrack), findsOneWidget);
      final hearts = tester.widgetList<Icon>(find.byIcon(IsharaIcons.heart));
      expect(hearts, hasLength(GameRules.maxHearts));
      expect(hearts.every((i) => i.color == c.textTertiary), isTrue);
      expect(
        find.text(
          'Hearts refill every ${GameRules.heartRefillHours} hours — or '
          'practise a review lesson to earn one back. Camera mistakes '
          'never cost hearts.',
        ),
        findsOneWidget,
      );

      final danu = tester.widget<DanuMascot>(find.byType(DanuMascot));
      expect(danu.pose, DanuPose.sad);
      expect(danu.animated, isTrue);
      expect(
        tester.widget<ResultsDanu>(find.byType(ResultsDanu)).size,
        IsharaSizes.resultMascotLarge,
      );
      // Danu keeps sighing.
      expect(tester.hasRunningAnimations, isTrue);

      final buttons = tester
          .widgetList<IsharaButton>(find.byType(IsharaButton))
          .map((b) => (b.label, b.variant))
          .toList();
      expect(buttons, [
        ('Practise to earn a heart', IsharaButtonVariant.filled),
        ('End lesson', IsharaButtonVariant.outlined),
      ]);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('opens with the "wrong" haptic', (tester) async {
    await pumpScreen(tester, reduced: true);
    expect(haptics, contains('HapticFeedbackType.mediumImpact'));
  });

  testWidgets('reduced motion: still sad Danu, nothing loops', (tester) async {
    await pumpScreen(tester, reduced: true);
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('fits at 1.3× text scale', (tester) async {
    await pumpScreen(tester, reduced: true, textScale: 1.3);
    expect(tester.takeException(), isNull);
    expect(find.text('End lesson'), findsOneWidget);
  });

  testWidgets('is announced as a header', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpScreen(tester, reduced: true);
    expect(
      tester.getSemantics(find.text('You’re out of hearts')),
      matchesSemantics(
        label: 'You’re out of hearts',
        isHeader: true,
        isLiveRegion: true,
      ),
    );
    expect(find.bySemanticsLabel('No hearts left'), findsOneWidget);
    handle.dispose();
  });

  group('navigation', () {
    Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    Future<void> open(WidgetTester tester) => pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const OutOfHeartsRoute().location,
    );

    testWidgets('Practise → Practice', (tester) async {
      await open(tester);
      await tapAndSettle(tester, find.text('Practise to earn a heart'));
      expect(find.byType(PracticeScreen), findsOneWidget);
    });

    testWidgets('End lesson → Learn', (tester) async {
      await open(tester);
      await tapAndSettle(tester, find.text('End lesson'));
      expect(find.byType(LearnScreen), findsOneWidget);
    });
  });
}
