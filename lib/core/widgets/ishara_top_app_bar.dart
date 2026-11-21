import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'ishara_icon_button.dart';

/// Figma `IsharaTopAppBar` → `leading`.
enum IsharaAppBarLeading { back, close }

/// Optional trailing action (Figma `showAction`).
@immutable
class IsharaAppBarAction {
  const IsharaAppBarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
}

/// Figma `IsharaTopAppBar`: M3 small app bar, 64dp, title/large.
class IsharaTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IsharaTopAppBar({
    super.key,
    this.title,
    required this.onLeading,
    this.leading = IsharaAppBarLeading.back,
    this.action,
  });

  /// Null = back/close only (auth forms, Figma 7:116).
  final String? title;
  final IsharaAppBarLeading leading;
  final VoidCallback? onLeading;
  final IsharaAppBarAction? action;

  @override
  Size get preferredSize => const Size.fromHeight(IsharaSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (icon, tooltip) = switch (leading) {
      IsharaAppBarLeading.back => (IsharaIcons.arrowLeft, 'Back'),
      IsharaAppBarLeading.close => (IsharaIcons.close, 'Close'),
    };
    // Fixed height so it doesn't fill loose constraints outside Scaffold.appBar.
    return SizedBox(
      height: IsharaSizes.appBarHeight,
      child: AppBar(
        toolbarHeight: IsharaSizes.appBarHeight,
        backgroundColor: c.bgCanvas,
        automaticallyImplyLeading: false,
        titleSpacing: IsharaSpacing.s1,
        leadingWidth: IsharaSizes.minTouch + IsharaSpacing.s1,
        leading: Padding(
          padding: const EdgeInsets.only(left: IsharaSpacing.s1),
          child: Center(
            child: IsharaIconButton(
              icon: icon,
              tooltip: tooltip,
              onPressed: onLeading,
            ),
          ),
        ),
        title: title == null
            ? null
            : Semantics(
                header: true,
                child: Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleLarge.copyWith(
                    color: c.textPrimary,
                  ),
                ),
              ),
        actions: [
          if (action case final a?)
            Padding(
              padding: const EdgeInsets.only(right: IsharaSpacing.s1),
              child: IsharaIconButton(
                icon: a.icon,
                tooltip: a.tooltip,
                onPressed: a.onPressed,
              ),
            ),
        ],
      ),
    );
  }
}
