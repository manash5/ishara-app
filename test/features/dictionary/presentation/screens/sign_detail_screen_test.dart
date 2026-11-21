import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/dictionary/presentation/providers/dictionary_models.dart';
import 'package:ishara_app/features/dictionary/presentation/providers/dictionary_providers.dart';
import 'package:ishara_app/features/dictionary/presentation/screens/dictionary_screen.dart';
import 'package:ishara_app/features/dictionary/presentation/screens/sign_detail_screen.dart';
import 'package:ishara_app/features/dictionary/presentation/widgets/sign_detail_sections.dart';
import 'package:ishara_app/features/practice/presentation/screens/practice_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';

Future<void> _pump(
  WidgetTester tester, {
  String signId = 'namaste',
  ThemeMode mode = ThemeMode.light,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await pumpThemed(
    tester,
    ProviderScope(
      overrides: overrides,
      child: SignDetailScreen(signId: signId),
    ),
    mode: mode,
  );
  // Let chained futures (and error propagation) settle.
  await tester.pump();
  await tester.pump();
}

void main() {
  group('data', () {
    for (final mode in themeModes) {
      testWidgets('renders video, meaning, how-to, tip and CTA ($mode)', (
        tester,
      ) async {
        await _pump(tester, mode: mode);
        final c = tokensFor(mode);

        // App bar title + headline.
        expect(find.text('Namaste'), findsNWidgets(2));
        expect(find.byType(SignVideoPlayer), findsOneWidget);
        expect(find.widgetWithText(IsharaChip, 'Learned'), findsOneWidget);
        expect(find.text('How to sign'), findsOneWidget);
        expect(find.text('Etiquette'), findsOneWidget);
        expect(find.text('Practise this sign'), findsOneWidget);
        expect(find.byTooltip('Back'), findsOneWidget);

        expect(textColor(tester, 'How to sign'), c.textPrimary);
        expect(textColor(tester, 'Etiquette'), c.accentText);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('unverified text is shown as a marked placeholder', (
      tester,
    ) async {
      await _pump(tester);
      expect(find.text(signTextPendingVerification), findsOneWidget);
      expect(find.text(signStepsPendingVerification), findsOneWidget);
    });

    testWidgets('numbered steps render when provided', (tester) async {
      await _pump(
        tester,
        overrides: [
          signDetailProvider('namaste').overrideWithValue(
            const AsyncData(
              SignDetail(
                sign: DictionarySign(
                  id: 'namaste',
                  name: 'Namaste',
                  category: SignCategory.greetings,
                  status: SignStatus.newSign,
                ),
                meaning: 'Test meaning',
                steps: ['Test step one', 'Test step two'],
              ),
            ),
          ),
        ],
      );
      expect(find.text('Test meaning'), findsOneWidget);
      expect(find.text('Test step one'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text(signStepsPendingVerification), findsNothing);
      expect(find.text('Etiquette'), findsNothing);
    });

    testWidgets('mirror and slow-motion toggles update the player', (
      tester,
    ) async {
      await _pump(tester);
      await tester.tap(find.bySemanticsLabel('Mirror video'));
      await tester.tap(find.bySemanticsLabel('Slow motion'));
      await tester.pump();
      final player = tester.widget<SignVideoPlayer>(
        find.byType(SignVideoPlayer),
      );
      expect(player.mirrored, isTrue);
      expect(player.slowMotion, isTrue);
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
      final pending = Completer<List<DictionarySign>>();
      await _pump(
        tester,
        overrides: [
          dictionarySignsProvider.overrideWith((_) => pending.future),
        ],
      );
      expect(find.bySemanticsLabel('Loading sign'), findsOneWidget);
      expect(find.text('Practise this sign'), findsNothing);
    });

    testWidgets('error', (tester) async {
      await _pump(
        tester,
        overrides: [
          dictionarySignsProvider.overrideWith(
            (_) async => throw Exception('offline'),
          ),
        ],
      );
      expect(find.text('Couldn’t load this sign'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('unknown sign', (tester) async {
      await _pump(tester, signId: 'nope');
      expect(find.text('Sign not found'), findsOneWidget);
    });
  });

  group('navigation', () {
    testWidgets('back returns to the dictionary', (tester) async {
      await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const DictionaryRoute().location,
      );
      await tester.tap(find.text('Namaste'));
      await tester.pumpAndSettle();
      expect(find.byType(SignDetailScreen), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.byType(SignDetailScreen), findsNothing);
      expect(find.byType(DictionaryScreen), findsOneWidget);
    });

    testWidgets('practise opens Practice full-screen', (tester) async {
      await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: const SignDetailRoute(signId: 'namaste').location,
      );
      expect(find.byType(IsharaBottomBar), findsOneWidget);
      await tester.tap(find.text('Practise this sign'));
      await tester.pumpAndSettle();
      expect(find.byType(PracticeScreen), findsOneWidget);
    });
  });
}
