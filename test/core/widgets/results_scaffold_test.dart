import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  Future<void> pumpResults(
    WidgetTester tester, {
    ThemeMode mode = ThemeMode.light,
    bool reduced = true,
    Widget? danu,
    VoidCallback? onContinue,
    bool celebrate = true,
    String? secondaryLabel,
    VoidCallback? onSecondary,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
            child: ResultsScaffold(
              heroPadding: const EdgeInsets.all(IsharaSpacing.s6),
              backdrop: HeroBackdropLayout.results,
              danu: danu,
              hero: const Text('Hero'),
              onContinue: onContinue ?? () {},
              celebrate: celebrate,
              continueLabel: secondaryLabel == null ? 'Continue' : 'Go',
              secondaryLabel: secondaryLabel,
              onSecondary: onSecondary,
              children: const [Text('Panel')],
            ),
          ),
        ),
      ),
    );
  }

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets(
      'hero over a panel with Continue at the bottom (${mode.name})',
      (tester) async {
        var taps = 0;
        await pumpResults(tester, mode: mode, onContinue: () => taps++);
        expect(
          tester.widget<HeroBackdrop>(find.byType(HeroBackdrop)).layout,
          HeroBackdropLayout.results,
        );
        expect(find.text('Hero'), findsOneWidget);
        expect(find.text('Panel'), findsOneWidget);
        // The panel's rounded corners show teal behind them.
        final behind = tester.widget<ColoredBox>(
          find
              .ancestor(
                of: find.byType(ContentPanel),
                matching: find.byType(ColoredBox),
              )
              .first,
        );
        expect(behind.color, c.funTealHero);
        // Continue sits at the bottom of the screen.
        final button = tester.getRect(find.byType(IsharaButton));
        final screen = tester.getRect(find.byType(ResultsScaffold));
        expect(screen.bottom - button.bottom, lessThan(IsharaSpacing.s12));
        await tester.tap(find.text('Continue'));
        expect(taps, 1);
      },
    );
  }

  testWidgets('danu straddles the hero and the panel, on the right', (
    tester,
  ) async {
    await pumpResults(tester, danu: const ResultsDanu());
    final danu = tester.getRect(find.byType(DanuMascot));
    final panelTop = tester.getRect(find.byType(ContentPanel)).top;
    final width = tester.getSize(find.byType(ResultsScaffold)).width;
    expect(danu.top, panelTop - IsharaSizes.resultMascotOverlap);
    expect(danu.bottom, greaterThan(panelTop));
    expect(danu.right, width - IsharaSpacing.screenMargin);
  });

  Finder confetti() => find.descendant(
    of: find.byType(ConfettiBurst),
    matching: find.byType(CustomPaint),
  );

  testWidgets('confetti plays once with motion on', (tester) async {
    await pumpResults(tester, reduced: false);
    expect(confetti(), findsOneWidget);
    // The ticker starts on the first frame, so advance in two steps.
    await tester.pump(IsharaMotion.confetti ~/ 2);
    expect(confetti(), findsOneWidget);
    await tester.pump(IsharaMotion.confetti);
    await tester.pump();
    expect(confetti(), findsNothing);
  });

  testWidgets('celebrate: false never plays confetti', (tester) async {
    await pumpResults(tester, reduced: false, celebrate: false);
    expect(find.byType(ConfettiBurst), findsNothing);
  });

  testWidgets('custom label and an outlined secondary action', (tester) async {
    var (go, other) = (0, 0);
    await pumpResults(
      tester,
      onContinue: () => go++,
      secondaryLabel: 'Other',
      onSecondary: () => other++,
    );
    final buttons = tester
        .widgetList<IsharaButton>(find.byType(IsharaButton))
        .toList();
    expect(buttons.map((b) => (b.label, b.variant)), [
      ('Go', IsharaButtonVariant.filled),
      ('Other', IsharaButtonVariant.outlined),
    ]);
    await tester.tap(find.text('Go'));
    await tester.tap(find.text('Other'));
    expect((go, other), (1, 1));
  });

  testWidgets('no confetti with reduced motion', (tester) async {
    await pumpResults(tester);
    expect(confetti(), findsNothing);
  });

  group('ResultsDanu', () {
    for (final mode in themeModes) {
      testWidgets('waves with the roadmap animation after popping in '
          '(${mode.name})', (tester) async {
        await pumpThemed(tester, const ResultsDanu(), mode: mode);
        final danu = tester.widget<DanuMascot>(find.byType(DanuMascot));
        expect(danu.pose, DanuPose.wave);
        expect(danu.animated, isTrue);
        expect(danu.size, IsharaSizes.resultMascot);
        expect(find.byType(PopIn), findsOneWidget);
        await tester.pump(IsharaMotion.celebrate * 2);
        // The wave keeps looping.
        expect(tester.hasRunningAnimations, isTrue);
      });
    }

    testWidgets('reduced motion: still pose, no loop', (tester) async {
      await pumpThemed(tester, const ResultsDanu(), disableAnimations: true);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
