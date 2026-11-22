import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  SignVideoPlayer player(WidgetTester tester) =>
      tester.widget<SignVideoPlayer>(find.byType(SignVideoPlayer));

  for (final mode in themeModes) {
    testWidgets('a large player that toggles its own state (${mode.name})', (
      tester,
    ) async {
      await pumpThemed(
        tester,
        const SizedBox(
          width: 364,
          child: SignVideo(semanticLabel: 'Sign video: Namaste'),
        ),
        mode: mode,
      );
      expect(player(tester).size, SignVideoSize.large);
      expect(player(tester).semanticLabel, 'Sign video: Namaste');
      expect(
        (player(tester).slowMotion, player(tester).mirrored),
        (false, false),
      );

      await tester.tap(find.bySemanticsLabel('Slow motion'));
      await tester.pump();
      expect(player(tester).slowMotion, isTrue);

      await tester.tap(find.bySemanticsLabel('Mirror video'));
      await tester.pump();
      expect(player(tester).mirrored, isTrue);

      await tester.tap(find.bySemanticsLabel('Normal speed'));
      await tester.pump();
      expect(player(tester).slowMotion, isFalse);
    });
  }

  testWidgets('passes an injected video through', (tester) async {
    const video = ColoredBox(key: Key('video'), color: Color(0x00000000));
    await pumpThemed(
      tester,
      const SizedBox(
        width: 364,
        child: SignVideo(semanticLabel: 'Sign video', video: video),
      ),
    );
    expect(find.byKey(const Key('video')), findsOneWidget);
  });
}
