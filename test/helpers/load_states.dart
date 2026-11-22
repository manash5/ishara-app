import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/services/api/mock_api_settings.dart';
import 'package:ishara_app/core/widgets/widgets.dart';

import 'pump_app.dart';

/// Loading and error tests for a screen at [location] that loads through the
/// mock API and shows a [LoadStateView] until its data arrives.
void loadStateTests({
  required String location,
  required String errorTitle,
  required String loadingLabel,
}) {
  group('load states', () {
    testWidgets('loading shows a labelled skeleton', (tester) async {
      const latency = Duration(seconds: 5);
      await pumpApp(
        tester,
        loggedIn: true,
        onboardingDone: true,
        location: location,
        apiLatency: latency,
      );
      expect(find.byType(LoadStateView), findsOneWidget);
      expect(find.bySemanticsLabel(loadingLabel), findsOneWidget);
      // Let the slow requests finish before the test ends.
      for (var i = 0; i < 4; i++) {
        await tester.pump(latency);
      }
      expect(find.byType(LoadStateView), findsNothing);
    });

    for (final (simulation, failure) in const [
      (MockApiSimulation.serverError, ServerFailure()),
      (MockApiSimulation.offline, NetworkFailure()),
    ]) {
      testWidgets('${simulation.name}: a user-safe error with Try again', (
        tester,
      ) async {
        await pumpApp(
          tester,
          loggedIn: true,
          onboardingDone: true,
          location: location,
          simulation: simulation,
        );
        expect(find.text(errorTitle), findsOneWidget);
        expect(find.text(failure.message), findsOneWidget);
        expect(find.text('Try again'), findsOneWidget);
        expect(find.textContaining('Exception'), findsNothing);
      });
    }
  });
}
