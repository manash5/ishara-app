import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Shared layout of Figma "03 Sign up", "04 Log in" and "05 Forgot password":
/// back-only [IsharaTopAppBar], heading (headline/small + body/medium), body
/// sections 24 apart, and an optional [footer] pinned to the bottom.
///
/// Scrolls when the keyboard or a large text scale needs the room.
class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.footer,
  });

  final String title;
  final String subtitle;

  /// Body sections under the heading (Figma `body`, gap space/6).
  final List<Widget> children;

  /// Figma `footer` (padding 12 × screen margin).
  final Widget? footer;

  /// Back pops when there is somewhere to go back to, else returns to
  /// Welcome (e.g. after a deep link).
  static void back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      const WelcomeRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.textStyles;
    return Scaffold(
      // Figma 7:116 / 7:215 / 7:290: back button only.
      appBar: IsharaTopAppBar(onLeading: () => back(context)),
      body: SafeArea(
        top: false,
        child: AutofillGroup(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        IsharaSpacing.screenMargin,
                        IsharaSpacing.stackGap,
                        IsharaSpacing.screenMargin,
                        IsharaSpacing.s0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              title,
                              style: s.headlineSmall.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: IsharaSpacing.stackGap),
                          Text(
                            subtitle,
                            style: s.bodyMedium.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                          for (final child in children) ...[
                            const SizedBox(height: IsharaSpacing.s6),
                            child,
                          ],
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (footer case final footer?)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: IsharaSpacing.screenMargin,
                          vertical: IsharaSpacing.s3,
                        ),
                        child: footer,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Figma `fields` group: form fields 16 apart.
class AuthFields extends StatelessWidget {
  const AuthFields({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: IsharaSpacing.s4),
          children[i],
        ],
      ],
    );
  }
}
