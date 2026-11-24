import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  Finder button(String label) => find.widgetWithText(IsharaButton, label);

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    testWidgets('title, body and actions in tokens (${mode.name})', (
      tester,
    ) async {
      var confirmed = 0;
      var cancelled = 0;
      await pumpThemed(
        tester,
        ConfirmDialog(
          title: 'Delete your account?',
          body: 'You can’t undo this.',
          confirmLabel: 'Delete account',
          cancelLabel: 'Cancel',
          onConfirm: () => confirmed++,
          onCancel: () => cancelled++,
        ),
        mode: mode,
      );
      expect(textColor(tester, 'Delete your account?'), c.textPrimary);
      expect(textColor(tester, 'You can’t undo this.'), c.textSecondary);
      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialog.backgroundColor, c.bgSurfaceRaised);
      expect(
        tester.widget<IsharaButton>(button('Delete account')).tone,
        IsharaButtonTone.danger,
      );
      await tester.tap(button('Delete account'));
      await tester.tap(button('Cancel'));
      expect((confirmed, cancelled), (1, 1));
    });
  }

  testWidgets('a non-destructive confirm uses the accent tone', (tester) async {
    await pumpThemed(
      tester,
      ConfirmDialog(
        title: 'Save?',
        body: 'Body',
        confirmLabel: 'Save',
        cancelLabel: 'Cancel',
        destructive: false,
        onConfirm: () {},
        onCancel: () {},
      ),
    );
    expect(
      tester.widget<IsharaButton>(button('Save')).tone,
      IsharaButtonTone.accent,
    );
  });

  group('showConfirmDialog', () {
    Future<Future<bool>> open(WidgetTester tester) async {
      late Future<bool> result;
      await pumpThemed(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => result = showConfirmDialog(
              context,
              title: 'Quit?',
              body: 'Body',
              confirmLabel: 'Quit',
              cancelLabel: 'Stay',
            ),
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('true on confirm', (tester) async {
      final result = await open(tester);
      await tester.tap(button('Quit'));
      await tester.pumpAndSettle();
      expect(await result, isTrue);
    });

    testWidgets('false on cancel', (tester) async {
      final result = await open(tester);
      await tester.tap(button('Stay'));
      await tester.pumpAndSettle();
      expect(await result, isFalse);
    });

    testWidgets('false when dismissed by tapping outside', (tester) async {
      final result = await open(tester);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(await result, isFalse);
    });
  });
}
