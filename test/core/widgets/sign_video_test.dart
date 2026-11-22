import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
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

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('offline: "connect to watch", no controls (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpThemed(
        tester,
        const SizedBox(
          width: 364,
          child: SignVideo(semanticLabel: 'Sign video: Namaste', offline: true),
        ),
        mode: mode,
      );
      expect(find.text(SignVideo.offlineMessage), findsOneWidget);
      expect(textColor(tester, SignVideo.offlineMessage), c.textSecondary);
      expect(find.byIcon(IsharaIcons.wifiOff), findsOneWidget);
      expect(find.bySemanticsLabel('Slow motion'), findsNothing);
      expect(find.bySemanticsLabel('Mirror video'), findsNothing);
      expect(
        find.bySemanticsLabel(
          'Sign video: Namaste. ${SignVideo.offlineMessage}',
        ),
        findsOneWidget,
      );
      handle.dispose();
    });
  }

  testWidgets('a tile offline shows only the icon', (tester) async {
    await pumpThemed(
      tester,
      const SizedBox(
        width: 170,
        child: SignVideoPlayer(
          semanticLabel: 'Sign video',
          size: SignVideoSize.tile,
          unavailableMessage: SignVideo.offlineMessage,
        ),
      ),
    );
    expect(find.byIcon(IsharaIcons.wifiOff), findsOneWidget);
    expect(find.text(SignVideo.offlineMessage), findsNothing);
    expect(find.byKey(const ValueKey('video-tile-play')), findsNothing);
  });
}
