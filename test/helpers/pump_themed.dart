import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:material_ui/material_ui.dart';

/// Both brightnesses, for "test in Light and Dark" loops.
const themeModes = [ThemeMode.light, ThemeMode.dark];

/// The colour tokens a widget sees under [mode].
IsharaColors tokensFor(ThemeMode mode) =>
    mode == ThemeMode.dark ? IsharaColors.dark : IsharaColors.light;

/// Pumps [child] inside a MaterialApp using the Ishara themes.
Future<void> pumpThemed(
  WidgetTester tester,
  Widget child, {
  ThemeMode mode = ThemeMode.light,
  bool disableAnimations = false,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: disableAnimations),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    ),
  );
}

/// The effective (fully merged) text style of the text found by [finder].
TextStyle? renderedStyle(WidgetTester tester, Finder finder) =>
    tester.renderObject<RenderParagraph>(finder).text.style;

/// The effective colour of [text] as painted.
Color? textColor(WidgetTester tester, String text) =>
    renderedStyle(tester, find.text(text))?.color;
