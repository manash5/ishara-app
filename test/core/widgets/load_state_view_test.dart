import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/failure.dart';
import 'package:ishara_app/core/widgets/widgets.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('loading shows a labelled skeleton (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        LoadStateView(
          error: null,
          errorTitle: 'Couldn’t load your path',
          onRetry: () {},
          loadingLabel: 'Loading your path',
        ),
        mode: mode,
      );
      expect(find.byType(ListSkeleton), findsOneWidget);
      expect(find.bySemanticsLabel('Loading your path'), findsOneWidget);
      expect(find.byType(StateMessage), findsNothing);
    });

    testWidgets('error shows the failure message and Try again '
        '(${mode.name})', (tester) async {
      var retries = 0;
      await pumpThemed(
        tester,
        LoadStateView(
          error: const NetworkFailure(),
          errorTitle: 'Couldn’t load your path',
          onRetry: () => retries++,
          loadingLabel: 'Loading your path',
        ),
        mode: mode,
      );
      expect(textColor(tester, 'Couldn’t load your path'), c.textPrimary);
      expect(find.text(const NetworkFailure().message), findsOneWidget);
      await tester.tap(find.text('Try again'));
      expect(retries, 1);
    });
  }

  testWidgets('a raw exception never reaches the user', (tester) async {
    await pumpThemed(
      tester,
      LoadStateView(
        error: Exception('SocketException: secret host'),
        errorTitle: 'Couldn’t load',
        onRetry: () {},
        loadingLabel: 'Loading',
      ),
    );
    expect(find.textContaining('secret'), findsNothing);
    expect(find.text(const UnknownFailure().message), findsOneWidget);
  });
}
