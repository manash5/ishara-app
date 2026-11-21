import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import '../widgets/widgets.dart';

/// A button on a [ScreenPlaceholder] leading to the next screen in the flow.
class PlaceholderAction {
  const PlaceholderAction(this.label, this.onPressed, {this.primary = false});

  final String label;
  final VoidCallback? onPressed;

  /// Filled (main path) instead of outlined.
  final bool primary;
}

/// Temporary stand-in for a Figma frame: shows "NN · Name" and buttons to the
/// next screens so the whole flow can be clicked through.
///
/// Dev scaffolding for the UI-only phase, not a shared widget (it has no
/// Figma counterpart). Each screen replaces it with the real layout.
class ScreenPlaceholder extends StatelessWidget {
  const ScreenPlaceholder({
    super.key,
    required this.frame,
    required this.name,
    this.actions = const [],
    this.extras = const [],
    this.inShell = false,
    this.leading = IsharaAppBarLeading.back,
    this.onLeading,
  });

  /// Figma frame number, e.g. "13" (empty for routes without a frame).
  final String frame;
  final String name;
  final List<PlaceholderAction> actions;

  /// Extra content above the actions (toggles, step switchers…).
  final List<Widget> extras;

  /// Inside the bottom-bar shell: pad the content clear of the bar.
  final bool inShell;

  final IsharaAppBarLeading leading;

  /// Overrides the default back/close behaviour (pop).
  final VoidCallback? onLeading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    final canPop = Navigator.of(context).canPop();
    final title = frame.isEmpty ? name : '$frame · $name';
    return Scaffold(
      appBar: canPop || onLeading != null
          ? IsharaTopAppBar(
              title: name,
              leading: leading,
              onLeading: onLeading ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      body: SafeArea(
        bottom: !inShell,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            IsharaSpacing.screenMargin,
            IsharaSpacing.screenMargin,
            IsharaSpacing.screenMargin,
            inShell
                ? IsharaSizes.bottomBarContentPadding
                : IsharaSpacing.screenMargin,
          ),
          children: [
            Text(
              'Placeholder'.toUpperCase(),
              style: s.labelSmall.copyWith(color: c.textTertiary),
            ),
            const SizedBox(height: IsharaSpacing.s2),
            Text(title, style: s.headlineSmall.copyWith(color: c.textPrimary)),
            const SizedBox(height: IsharaSpacing.sectionGap),
            for (final child in extras) ...[
              child,
              const SizedBox(height: IsharaSpacing.listGap),
            ],
            for (final a in actions) ...[
              IsharaButton(
                label: a.label,
                onPressed: a.onPressed,
                variant: a.primary
                    ? IsharaButtonVariant.filled
                    : IsharaButtonVariant.outlined,
              ),
              const SizedBox(height: IsharaSpacing.listGap),
            ],
          ],
        ),
      ),
    );
  }
}
