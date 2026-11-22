import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/dictionary_models.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/sign_detail_sections.dart';
import '../widgets/sign_status_tone.dart';

/// Figma "14 Sign detail" (Light 12:1025 · Dark 60:6840): pushed inside the
/// Dictionary branch, so the floating bottom bar stays visible and the
/// "Practise this sign" footer sits just above it.
class SignDetailScreen extends ConsumerWidget {
  const SignDetailScreen({super.key, required this.signId});

  final String signId;

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      const DictionaryRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(signDetailProvider(signId));
    final title = detail.value?.sign.name ?? '';
    return Scaffold(
      backgroundColor: context.colors.bgCanvas,
      appBar: IsharaTopAppBar(title: title, onLeading: () => _back(context)),
      body: switch (detail) {
        AsyncValue(hasValue: true, :final value) =>
          value == null
              ? _Message(
                  child: StateMessage(
                    title: 'Sign not found',
                    body: 'This sign isn’t in the dictionary.',
                    actionLabel: 'Back to dictionary',
                    onAction: () => const DictionaryRoute().go(context),
                  ),
                )
              : _SignDetailBody(detail: value),
        AsyncValue(hasError: true) => _Message(
          child: StateMessage(
            title: 'Couldn’t load this sign',
            body: 'Check your connection and try again.',
            actionLabel: 'Try again',
            onAction: () => ref.invalidate(signDetailProvider(signId)),
          ),
        ),
        _ => const _SignDetailSkeleton(),
      },
    );
  }
}

class _SignDetailBody extends StatelessWidget {
  const _SignDetailBody({required this.detail});

  final SignDetail detail;

  @override
  Widget build(BuildContext context) {
    final sign = detail.sign;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              IsharaSpacing.screenMargin,
              IsharaSpacing.s2,
              IsharaSpacing.screenMargin,
              IsharaSpacing.s4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SignVideo(semanticLabel: 'Sign video: ${sign.name}'),
                const SizedBox(height: IsharaSpacing.s6),
                SignMeaningSection(
                  name: sign.name,
                  statusLabel: sign.status.label,
                  statusTone: sign.status.chipTone,
                  meaning: detail.meaning,
                ),
                const SizedBox(height: IsharaSpacing.s6),
                SignHowToSection(steps: detail.steps),
                if (detail.etiquetteTip case final tip?) ...[
                  const SizedBox(height: IsharaSpacing.s6),
                  EtiquetteTipCard(tip: tip),
                ],
              ],
            ),
          ),
        ),
        // Figma `footer` (12:1192), lifted above the floating bottom bar.
        Padding(
          padding: const EdgeInsets.fromLTRB(
            IsharaSpacing.screenMargin,
            IsharaSpacing.s3,
            IsharaSpacing.screenMargin,
            IsharaSizes.bottomBarContentPadding,
          ),
          child: IsharaButton(
            label: 'Practise this sign',
            icon: IsharaIcons.camera,
            onPressed: () => const PracticeRoute().push<void>(context),
          ),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        IsharaSpacing.screenMargin,
        IsharaSpacing.s2,
        IsharaSpacing.screenMargin,
        IsharaSizes.bottomBarContentPadding,
      ),
      child: child,
    );
  }
}

/// Loading: the video frame and text lines as muted blocks.
class _SignDetailSkeleton extends StatelessWidget {
  const _SignDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final muted = BoxDecoration(
      color: context.colors.bgSurfaceMuted,
      borderRadius: IsharaRadius.brLg,
    );
    return Semantics(
      label: 'Loading sign',
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            IsharaSpacing.screenMargin,
            IsharaSpacing.s2,
            IsharaSpacing.screenMargin,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SignVideoPlayer(semanticLabel: 'Sign video'),
              const SizedBox(height: IsharaSpacing.s6),
              Container(height: IsharaSpacing.s8, decoration: muted),
              const SizedBox(height: IsharaSpacing.s2),
              Container(height: IsharaSpacing.s10, decoration: muted),
            ],
          ),
        ),
      ),
    );
  }
}
