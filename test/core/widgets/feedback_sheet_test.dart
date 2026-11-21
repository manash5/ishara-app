import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

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

  for (final mode in themeModes) {
    final c = tokensFor(mode);
    final expected = {
      FeedbackResult.correct: (
        c.successSubtle,
        c.successDefault,
        c.successText,
        IsharaIcons.check,
        IsharaButtonTone.success,
        'Nicely done!',
        'Continue',
      ),
      FeedbackResult.incorrect: (
        c.dangerSubtle,
        c.dangerDefault,
        c.dangerText,
        IsharaIcons.close,
        IsharaButtonTone.danger,
        'Not quite',
        'Got it',
      ),
      FeedbackResult.almost: (
        c.accentSubtle,
        c.accentDefault,
        c.accentText,
        IsharaIcons.lightbulb,
        IsharaButtonTone.accent,
        'Almost there',
        'Try again',
      ),
    };

    for (final MapEntry(
          key: result,
          value: (panel, badge, fg, icon, tone, title, action),
        )
        in expected.entries) {
      testWidgets('${result.name} (${mode.name})', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpThemed(
          tester,
          FeedbackSheet(
            result: result,
            message: 'Placeholder message',
            onContinue: () {},
          ),
          mode: mode,
        );
        final p =
            tester
                    .widget<Container>(
                      find.byKey(const ValueKey('feedback-sheet-panel')),
                    )
                    .decoration!
                as BoxDecoration;
        expect(p.color, panel);
        expect(p.borderRadius, IsharaRadius.sheetTop);
        final b =
            tester
                    .widget<Container>(
                      find
                          .ancestor(
                            of: find.byIcon(icon),
                            matching: find.byType(Container),
                          )
                          .first,
                    )
                    .decoration!
                as BoxDecoration;
        expect(b.color, badge);
        expect(tester.widget<Icon>(find.byIcon(icon)).color, c.textOnAccent);
        expect(textColor(tester, title), fg);
        expect(textColor(tester, 'Placeholder message'), fg);
        final button = tester.widget<IsharaButton>(find.byType(IsharaButton));
        expect(button.tone, tone);
        expect(button.label, action);
        expect(
          find.bySemanticsLabel('$title. Placeholder message'),
          findsOneWidget,
        );
        handle.dispose();
      });
    }

    testWidgets('tone fills the button (${mode.name})', (tester) async {
      await pumpThemed(
        tester,
        FeedbackSheet(
          result: FeedbackResult.incorrect,
          message: 'm',
          onContinue: () {},
        ),
        mode: mode,
      );
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(FilledButton),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, c.dangerDefault);
    });
  }

  testWidgets('almost: optional secondary text button', (tester) async {
    var skips = 0;
    await pumpThemed(
      tester,
      FeedbackSheet(
        result: FeedbackResult.almost,
        message: 'm',
        onContinue: () {},
        secondaryLabel: 'Skip — I can’t use the camera now',
        onSecondary: () => skips++,
      ),
    );
    expect(find.byType(IsharaButton), findsNWidgets(2));
    await tester.tap(find.text('Skip — I can’t use the camera now'));
    await tester.pumpAndSettle();
    expect(skips, 1);
  });

  for (final (result, haptic) in [
    (FeedbackResult.correct, 'HapticFeedbackType.lightImpact'),
    (FeedbackResult.incorrect, 'HapticFeedbackType.mediumImpact'),
  ]) {
    testWidgets('show(${result.name}) slides up with haptic and continues', (
      tester,
    ) async {
      var continues = 0;
      await pumpThemed(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => FeedbackSheet.show(
              context,
              result: result,
              message: 'm',
              onContinue: () {
                continues++;
                Navigator.of(context).pop();
              },
            ),
            child: const Text('check'),
          ),
        ),
      );
      await tester.tap(find.text('check'));
      await tester.pump();
      expect(haptics, [haptic]);
      await tester.pumpAndSettle();
      expect(find.byType(FeedbackSheet), findsOneWidget);
      await tester.tap(find.byType(IsharaButton));
      await tester.pumpAndSettle();
      expect(continues, 1);
      expect(find.byType(FeedbackSheet), findsNothing);
    });
  }
}
