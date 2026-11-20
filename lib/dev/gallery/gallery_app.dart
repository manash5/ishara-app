import 'package:material_ui/material_ui.dart';

import '../../core/theme/theme.dart';
import 'sections/colors_section.dart';
import 'sections/motion_section.dart';
import 'sections/spacing_radius_section.dart';
import 'sections/type_section.dart';

/// Shows every Foundations token and the motion primitives in Light and Dark.
class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key, this.initialMode = ThemeMode.light});

  final ThemeMode initialMode;

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  late ThemeMode _mode = widget.initialMode;

  static const _order = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];

  void _cycleMode() => setState(
    () => _mode = _order[(_order.indexOf(_mode) + 1) % _order.length],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ishara gallery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _mode,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ishara gallery'),
          actions: [
            IconButton(
              key: const Key('gallery-theme-toggle'),
              tooltip: 'Theme: ${_mode.name} (tap to change)',
              onPressed: _cycleMode,
              icon: Icon(switch (_mode) {
                ThemeMode.light => Icons.light_mode,
                ThemeMode.dark => Icons.dark_mode,
                ThemeMode.system => Icons.brightness_auto,
              }),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(IsharaSpacing.screenMargin),
          children: const [
            MotionSection(),
            SizedBox(height: IsharaSpacing.sectionGap),
            ColorsSection(),
            SizedBox(height: IsharaSpacing.sectionGap),
            TypeSection(),
            SizedBox(height: IsharaSpacing.sectionGap),
            SpacingRadiusSection(),
          ],
        ),
      ),
    );
  }
}
