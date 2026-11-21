import 'package:material_ui/material_ui.dart';

import '../../core/theme/theme.dart';
import 'sections/widget_sections.dart';

/// Debug-only `/gallery`: every shared widget in `lib/core/widgets/` with all
/// of its variants and states, under a light/dark toggle.
///
/// Registered in `main.dart` only when `kDebugMode`, so it is tree-shaken out
/// of release builds. Each section mirrors one Figma component set on the
/// Components page.
class WidgetsGalleryScreen extends StatefulWidget {
  const WidgetsGalleryScreen({super.key, this.initialBrightness});

  /// Defaults to the platform brightness.
  final Brightness? initialBrightness;

  static const String routeName = '/gallery';

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
            itemCount: widgetSections.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: IsharaSpacing.sectionGap),
            itemBuilder: (context, i) => widgetSections[i](context),
          ),
        ),
      ),
    );
  }
}
