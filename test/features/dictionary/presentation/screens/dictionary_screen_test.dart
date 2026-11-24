import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/dictionary/data/datasources/sign_local_data_source.dart';
import 'package:ishara_app/features/dictionary/data/models/sign_dto.dart';
import 'package:ishara_app/features/dictionary/presentation/providers/dictionary_models.dart';
import 'package:ishara_app/features/dictionary/presentation/providers/dictionary_providers.dart';
import 'package:ishara_app/features/dictionary/presentation/screens/dictionary_screen.dart';
import 'package:ishara_app/features/dictionary/presentation/screens/sign_detail_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import '../../../../helpers/mock_api.dart';
import '../../../../helpers/test_hive.dart';

Future<void> _pump(
  WidgetTester tester, {
  ThemeMode mode = ThemeMode.light,
  List<Override> overrides = const [],
  MockApiSimulation? simulation,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await pumpThemed(
    tester,
    ProviderScope(
      overrides: [
        ...mockApiOverrides(simulation: simulation),
        ...overrides,
      ],
      child: const DictionaryScreen(),
    ),
    mode: mode,
  );
  // Let the mock API answer and errors propagate.
  await pumpApi(tester);
  await tester.pump();
}

void main() {
  group('data', () {
    for (final mode in themeModes) {
      testWidgets('renders the header, filters and sign list ($mode)', (
        tester,
      ) async {
        await _pump(tester, mode: mode);
        final c = tokensFor(mode);

        expect(find.text('Dictionary'), findsOneWidget);
        expect(find.text('12 signs · Nepali Sign Language'), findsOneWidget);
        expect(find.text('Search signs'), findsOneWidget);
        expect(find.text('All signs'), findsOneWidget);
        expect(find.text('A–Z'), findsOneWidget);
        for (final chip in ['All', 'Greetings', 'Alphabet', 'Numbers']) {
          expect(find.widgetWithText(IsharaChip, chip), findsOneWidget);
        }
        expect(find.byType(SignListTile), findsNWidgets(12));
        expect(find.byType(HeroBackdrop), findsOneWidget);
        expect(find.byType(ContentPanel), findsOneWidget);

        expect(textColor(tester, 'Dictionary'), c.staticWhite);
        expect(textColor(tester, 'Namaste'), c.textPrimary);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('fits at 1.3x text scale', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _pump(tester);
      expect(find.text('Namaste'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('search and filters', () {
    testWidgets('search narrows the list', (tester) async {
      await _pump(tester);
      await tester.enterText(find.byType(TextField), 'thank');
      await tester.pump();

      expect(find.text('Thank you'), findsOneWidget);
      expect(find.text('Namaste'), findsNothing);
      expect(find.byType(SignListTile), findsOneWidget);
    });

    testWidgets('no results offers to clear the search', (tester) async {
      await _pump(tester);
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();

      expect(find.text('No signs found'), findsOneWidget);
      expect(find.text('No signs match “zzz”.'), findsOneWidget);
      expect(find.byType(SignListTile), findsNothing);

      await tester.tap(find.text('Clear search'));
      await tester.pump();
      expect(find.text('Namaste'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    });

    testWidgets('category chip filters and is marked selected', (tester) async {
      await _pump(tester);
      await tester.tap(find.widgetWithText(IsharaChip, 'Alphabet'));
      await tester.pump();

      expect(find.text('Ka'), findsOneWidget);
      expect(find.text('Namaste'), findsNothing);
      final chip = tester.widget<IsharaChip>(
        find.widgetWithText(IsharaChip, 'Alphabet'),
      );
      expect(chip.selected, isTrue);

      await tester.tap(find.widgetWithText(IsharaChip, 'All'));
      await tester.pump();
      expect(find.text('Namaste'), findsOneWidget);
    });

    testWidgets('A–Z sorts alphabetically', (tester) async {
      await _pump(tester);
      double y(String t) => tester.getTopLeft(find.text(t)).dy;
      expect(y('Namaste'), lessThan(y('Good morning')));

      await tester.tap(find.text('A–Z'));
      await tester.pump();
      expect(y('Good morning'), lessThan(y('Namaste')));
    });
  });

  group('states', () {
    testWidgets('loading shows the skeleton', (tester) async {
      final pending = Completer<List<DictionarySign>>();
      await _pump(
        tester,
        overrides: [
          dictionarySignsProvider.overrideWith(
            (_) => Stream.fromFuture(pending.future),
          ),
        ],
      );
      expect(find.byType(ListSkeleton), findsOneWidget);
      expect(find.text('Nepali Sign Language'), findsOneWidget);
    });

    testWidgets('error shows a retry message', (tester) async {
      await _pump(
        tester,
        overrides: [
          dictionarySignsProvider.overrideWith(
            (_) => Stream.error(Exception('offline')),
          ),
        ],
      );
      expect(find.text('Couldn’t load signs'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(find.textContaining('offline'), findsNothing);
    });

    testWidgets('offline with nothing cached shows the error', (tester) async {
      await _pump(tester, simulation: MockApiSimulation.offline);
      expect(find.text('Couldn’t load signs'), findsOneWidget);
    });

    testWidgets('empty dictionary', (tester) async {
      await _pump(
        tester,
        overrides: [
          dictionarySignsProvider.overrideWith((_) => Stream.value([])),
        ],
      );
      expect(find.text('No signs yet'), findsOneWidget);
    });
  });

  group('offline', () {
    testWidgets('shows the cached list and searches it locally', (
      tester,
    ) async {
      await SignLocalDataSource(TestHive.instance).writeSigns([
        for (final s in fixtureData<List<dynamic>>('signs/list_page1'))
          SignDto.fromJson(s as Map<String, dynamic>),
      ]);
      await _pump(tester, simulation: MockApiSimulation.offline);

      expect(find.text('8 signs · Nepali Sign Language'), findsOneWidget);
      expect(find.byType(SignListTile), findsNWidgets(8));
      expect(find.text('Couldn’t load signs'), findsNothing);

      await tester.enterText(find.byType(TextField), 'thank');
      await tester.pump();
      expect(find.byType(SignListTile), findsOneWidget);
      expect(find.text('Thank you'), findsOneWidget);
    });
  });

  testWidgets('tapping a sign opens its detail inside the shell', (
    tester,
  ) async {
    final container = await pumpApp(
      tester,
      loggedIn: true,
      onboardingDone: true,
      location: const DictionaryRoute().location,
    );
    await tester.tap(find.text('Namaste'));
    await tester.pumpAndSettle();

    expect(
      currentLocation(container),
      const SignDetailRoute(signId: FixtureIds.namaste).location,
    );
    expect(find.byType(SignDetailScreen), findsOneWidget);
    expect(find.byType(IsharaBottomBar), findsOneWidget);
  });
}
