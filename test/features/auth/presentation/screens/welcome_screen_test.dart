import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/router/app_routes.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:ishara_app/features/auth/presentation/screens/log_in_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:ishara_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_themed.dart';
import 'auth_screen_harness.dart';

const headline = 'Learn Nepali Sign Language, one sign at a time';

void main() {
  for (final mode in themeModes) {
    testWidgets('renders the Figma copy and CTAs in ${mode.name}', (
      tester,
    ) async {
      await pumpAuthScreen(tester, const WelcomeScreen(), mode: mode);
      final c = tokensFor(mode);

      expect(find.byType(HeroBackdrop), findsOneWidget);
      expect(textColor(tester, headline), c.staticWhite);
      expect(
        find.text('Short daily lessons with a camera coach.'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextLinkCTA, 'Get started'), findsOneWidget);
      expect(find.bySemanticsLabel('I already have an account'), findsOne);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, c.funTealHero);
    });
  }

  testWidgets('fits at 1.3x text scale', (tester) async {
    await pumpAuthScreen(tester, const WelcomeScreen(), textScale: 1.3);
    expect(tester.takeException(), isNull);
    expect(find.text(headline), findsOneWidget);
  });

  testWidgets('Get started opens Sign up', (tester) async {
    await pumpApp(tester, location: const WelcomeRoute().location);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    // push keeps the base URI in currentConfiguration; check the screen.
    expect(find.byType(SignUpScreen), findsOneWidget);
  });

  testWidgets('"I already have an account" opens Log in', (tester) async {
    await pumpApp(tester, location: const WelcomeRoute().location);
    await tester.tap(find.bySemanticsLabel('I already have an account'));
    await tester.pumpAndSettle();
    expect(find.byType(LogInScreen), findsOneWidget);
  });
}
