import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../features/auth/presentation/providers/fake_session_provider.dart';
import 'sections/gallery_section.dart';
import 'sections/widget_sections.dart';

/// Debug-only `/gallery`: every shared widget in `lib/core/widgets/` with all
/// of its variants and states, under a light/dark toggle.
///
/// Registered by the router only when `kDebugMode` (`appRoutes`). The first
/// section flips the fake session so the redirects can be exercised; the rest
/// mirror the Figma Components page, one section per component set.
class WidgetsGalleryScreen extends StatefulWidget {
  const WidgetsGalleryScreen({super.key, this.initialBrightness});

  /// Defaults to the platform brightness.
  final Brightness? initialBrightness;

  @override
  State<WidgetsGalleryScreen> createState() => _WidgetsGalleryScreenState();
}

class _WidgetsGalleryScreenState extends State<WidgetsGalleryScreen> {
  Brightness? _brightness;

  @override
  Widget build(BuildContext context) {
    final brightness =
        _brightness ??
        widget.initialBrightness ??
        MediaQuery.platformBrightnessOf(context);
    final dark = brightness == Brightness.dark;
    return Theme(
      data: dark ? AppTheme.dark : AppTheme.light,
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.colors.bgCanvas,
          appBar: AppBar(
            title: const Text('Widget gallery'),
            actions: [
              IconButton(
                key: const Key('widgets-gallery-theme-toggle'),
                tooltip: dark ? 'Switch to light' : 'Switch to dark',
                onPressed: () => setState(
                  () => _brightness = dark ? Brightness.light : Brightness.dark,
                ),
                icon: Icon(dark ? Icons.dark_mode : Icons.light_mode),
              ),
            ],
          ),
          body: ListView.separated(
            key: const Key('widgets-gallery-list'),
            padding: const EdgeInsets.all(IsharaSpacing.screenMargin),
            itemCount: widgetSections.length + 1,
            separatorBuilder: (_, _) =>
                const SizedBox(height: IsharaSpacing.sectionGap),
            itemBuilder: (context, i) => i == 0
                ? const FakeSessionSection()
                : widgetSections[i - 1](context),
          ),
        ),
      ),
    );
  }
}

/// Switches for the fake session; changes re-run the router redirects.
class FakeSessionSection extends ConsumerWidget {
  const FakeSessionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(fakeSessionProvider);
    final notifier = ref.read(fakeSessionProvider.notifier);
    return GallerySection(
      title: 'Fake session',
      subtitle: 'Drives the router redirects until real auth lands',
      children: [
        SettingsTile(
          key: const Key('gallery-session-logged-in'),
          icon: IsharaIcons.user,
          label: 'Logged in',
          trailing: SettingsTrailing.toggle,
          switchValue: session.loggedIn,
          onSwitchChanged: notifier.setLoggedIn,
        ),
        SettingsTile(
          key: const Key('gallery-session-onboarded'),
          icon: IsharaIcons.check,
          label: 'Onboarding done',
          trailing: SettingsTrailing.toggle,
          switchValue: session.onboardingDone,
          onSwitchChanged: notifier.setOnboardingDone,
        ),
      ],
    );
  }
}
