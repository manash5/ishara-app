import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';

import '../../helpers/pump_themed.dart';

void main() {
  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('title, body and action in tokens (${mode.name})', (
      tester,
    ) async {
      var taps = 0;
      await pumpThemed(
        tester,
        StateMessage(
          title: 'Couldn’t load signs',
          body: 'Check your connection and try again.',
          actionLabel: 'Try again',
          onAction: () => taps++,
        ),
        mode: mode,
      );
      expect(textColor(tester, 'Couldn’t load signs'), c.textPrimary);
      expect(
        textColor(tester, 'Check your connection and try again.'),
        c.textSecondary,
      );
      final button = tester.widget<IsharaButton>(find.byType(IsharaButton));
      expect(button.variant, IsharaButtonVariant.outlined);
      await tester.tap(find.text('Try again'));
      expect(taps, 1);
    });
  }

  testWidgets('no button without both a label and a callback', (tester) async {
    await pumpThemed(
      tester,
      const StateMessage(
        title: 'No signs yet',
        body: 'Signs you can learn will appear here.',
        actionLabel: 'Try again',
      ),
    );
    expect(find.byType(IsharaButton), findsNothing);
  });

  testWidgets('is a live region so screen readers announce it', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpThemed(
      tester,
      const StateMessage(title: 'No signs found', body: 'Try another word.'),
    );
    expect(
      tester.getSemantics(find.text('No signs found')),
      isSemantics(isLiveRegion: true),
    );
    handle.dispose();
  });
}
