import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

void main() {
  InputDecorator decorator(WidgetTester tester) =>
      tester.widget<InputDecorator>(find.byType(InputDecorator));

  /// The border actually in effect for the decorator's current state.
  InputBorder activeBorder(WidgetTester tester, ThemeMode mode) {
    final d = decorator(tester);
    final theme = mode == ThemeMode.dark ? AppTheme.dark : AppTheme.light;
    final dec = d.decoration.applyDefaults(theme.inputDecorationTheme);
    if (dec.errorText != null) {
      return d.isFocused ? dec.focusedErrorBorder! : dec.errorBorder!;
    }
    return d.isFocused ? dec.focusedBorder! : dec.enabledBorder!;
  }

  for (final mode in themeModes) {
    final c = tokensFor(mode);

    group('IsharaTextField (${mode.name})', () {
      testWidgets('empty: label, hint, muted fill, no border', (tester) async {
        await pumpThemed(
          tester,
          const IsharaTextField(
            label: 'Email',
            hint: 'you@example.com',
            prefixIcon: IsharaIcons.mail,
          ),
          mode: mode,
        );
        expect(textColor(tester, 'Email'), c.textPrimary);
        expect(find.text('you@example.com'), findsOneWidget);
        final theme = Theme.of(tester.element(find.byType(TextField)));
        expect(theme.inputDecorationTheme.fillColor, c.bgSurfaceMuted);
        expect(
          (activeBorder(tester, mode) as OutlineInputBorder).borderSide,
          BorderSide.none,
        );
        expect(
          (activeBorder(tester, mode) as OutlineInputBorder).borderRadius,
          IsharaRadius.brLg,
        );
        expect(find.byIcon(IsharaIcons.mail), findsOneWidget);
      });

      testWidgets('filled → focused shows 2px accent border', (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        await pumpThemed(
          tester,
          IsharaTextField(label: 'Email', controller: controller),
          mode: mode,
        );
        await tester.enterText(find.byType(TextField), 'a@b.co');
        await tester.pump();
        expect(controller.text, 'a@b.co');
        expect(decorator(tester).isFocused, isTrue);
        final side =
            (activeBorder(tester, mode) as OutlineInputBorder).borderSide;
        expect(side.color, c.accentDefault);
        expect(side.width, IsharaSizes.selectedBorder);
      });

      testWidgets('error: 2px danger border and danger helper', (tester) async {
        await pumpThemed(
          tester,
          const IsharaTextField(
            label: 'Email',
            helperText: 'We never share it',
            errorText: 'Enter a valid email',
          ),
          mode: mode,
        );
        final side =
            (activeBorder(tester, mode) as OutlineInputBorder).borderSide;
        expect(side.color, c.dangerDefault);
        expect(side.width, IsharaSizes.selectedBorder);
        expect(textColor(tester, 'Enter a valid email'), c.dangerText);
      });

      testWidgets('subtext and icon follow Figma geometry', (tester) async {
        await pumpThemed(
          tester,
          const SizedBox(
            width: 364,
            child: IsharaTextField(
              label: 'Email',
              hint: 'hint',
              prefixIcon: IsharaIcons.mail,
              errorText: 'Bad email',
            ),
          ),
          mode: mode,
        );
        final label = tester.getTopLeft(find.text('Email'));
        final field = tester.getRect(find.byType(InputDecorator));
        final error = tester.getTopLeft(find.text('Bad email'));
        // Flush with the label, 8 below the field.
        expect(error.dx, label.dx);
        expect(error.dy - field.bottom, IsharaSpacing.stackGap);
        // Icon 16 from the field edge; text 12 after the icon.
        final icon = tester.getRect(find.byIcon(IsharaIcons.mail));
        expect(icon.left - field.left, IsharaSpacing.s4);
        expect(
          tester.getTopLeft(find.text('hint')).dx - icon.right,
          IsharaSpacing.s3,
        );
      });

      testWidgets('helper uses text/secondary', (tester) async {
        await pumpThemed(
          tester,
          const IsharaTextField(label: 'Name', helperText: 'Shown to others'),
          mode: mode,
        );
        expect(textColor(tester, 'Shown to others'), c.textSecondary);
      });

      testWidgets('semantics: text field named by its label', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpThemed(
          tester,
          const IsharaTextField(label: 'Email'),
          mode: mode,
        );
        expect(find.bySemanticsLabel(RegExp('Email')), findsWidgets);
        final data = tester
            .getSemantics(find.byType(EditableText))
            .getSemanticsData();
        expect(data.flagsCollection.isTextField, isTrue);
        handle.dispose();
      });
    });
  }
}
