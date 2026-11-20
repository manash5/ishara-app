import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/theme/theme.dart';
import 'package:ishara_app/core/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_themed.dart';

/// Every interactive shared widget in one scrollable column.
Widget _kit() => ListView(
  padding: const EdgeInsets.all(IsharaSpacing.screenMargin),
  children: [
    IsharaButton(label: 'Continue', onPressed: () {}),
    IsharaButton(
      label: 'Skip',
      variant: IsharaButtonVariant.outlined,
      onPressed: () {},
    ),
    IsharaButton(
      label: 'Later',
      variant: IsharaButtonVariant.text,
      onPressed: () {},
    ),
    GoogleSignInButton(onPressed: () {}),
    const IsharaTextField(label: 'Email', prefixIcon: IsharaIcons.mail),
    Row(
      children: [
        for (final v in IsharaIconButtonVariant.values)
          IsharaIconButton(
            icon: IsharaIcons.arrowLeft,
            tooltip: 'Back ${v.name}',
            variant: v,
            onPressed: () {},
          ),
        IsharaSwitch(value: true, onChanged: (_) {}, semanticLabel: 'Sound'),
      ],
    ),
    SectionHeader(title: 'This week', actionLabel: 'See all', onAction: () {}),
    SignListTile(
      title: 'Namaste',
      subtitle: 'Greetings',
      statusLabel: 'Learned',
      onTap: () {},
    ),
    const LeaderboardTile(rank: 1, name: 'Sujata R.', xp: 420),
    SettingsTile(icon: IsharaIcons.bell, label: 'Reminders', onTap: () {}),
    SettingsTile(
      icon: IsharaIcons.bell,
      label: 'Daily reminder',
      trailing: SettingsTrailing.toggle,
      switchValue: true,
      onSwitchChanged: (_) {},
    ),
    SelectionCard(
      icon: IsharaIcons.target,
      title: 'Regular',
      description: '10 min a day',
      selected: true,
      onTap: () {},
    ),
    const StatCard(value: '12', caption: 'Day streak'),
    const IsharaChip(label: 'New'),
    const StepIndicator(current: 2),
    const IsharaAvatar(name: 'Manash Lama'),
    const SpeechBubble(text: 'Which sign is this?'),
    const IsharaLogo(variant: IsharaLogoVariant.lockup),
    IsharaSnackbar(
      message: 'You’re offline.',
      actionLabel: 'Retry',
      onAction: () {},
    ),
    SizedBox(
      height: 160,
      child: HeroBackdrop(
        child: Center(
          child: TextLinkCTA(label: 'Get started', onPressed: () {}),
        ),
      ),
    ),
  ],
);

void main() {
  for (final mode in themeModes) {
    testWidgets('tap targets ≥48dp and labelled (${mode.name})', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      tester.view.physicalSize = const Size(1080, 6000);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: Scaffold(body: _kit()),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('renders at 1.3× text scale without overflow (${mode.name})', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 8000);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.3)),
              child: Scaffold(body: _kit()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
