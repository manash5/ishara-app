import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';
import 'gallery_section.dart';

/// Motion tokens plus live press / selection / feedback demos.
///
/// Demo copy is generic placeholder text — no NSL sign content.
class MotionSection extends StatefulWidget {
  const MotionSection({super.key});

  @override
  State<MotionSection> createState() => _MotionSectionState();
}

class _MotionSectionState extends State<MotionSection> {
  bool _reduceMotion = false;

  static const _durations = {
    'instant': IsharaMotion.instant,
    'fast': IsharaMotion.fast,
    'standard': IsharaMotion.standard,
    'page': IsharaMotion.page,
    'celebrate': IsharaMotion.celebrate,
  };

  static const _curves = {
    'enter': 'Easing.emphasizedDecelerate',
    'exit': 'Easing.emphasizedAccelerate (~75% duration)',
    'move': 'Easing.standard',
    'playful': 'Curves.easeOutBack (roadmap + results only)',
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final caption = text.bodySmall?.copyWith(color: c.textSecondary);

    return GallerySection(
      title: 'Motion',
      subtitle: 'IsharaMotion · spec: .claude/rules/motion.md',
      children: [
        for (final e in _durations.entries)
          Text('${e.key} — ${e.value.inMilliseconds} ms', style: caption),
        for (final e in _curves.entries)
          Text('${e.key} — ${e.value}', style: caption),
        SwitchListTile(
          key: const Key('gallery-reduce-motion'),
          contentPadding: EdgeInsets.zero,
          title: Text('Reduce motion', style: text.titleMedium),
          subtitle: Text(
            'Simulates MediaQuery.disableAnimations for the demos below',
            style: caption,
          ),
          value: _reduceMotion,
          onChanged: (v) => setState(() => _reduceMotion = v),
        ),
        MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: _reduceMotion),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GalleryCaption('Press'),
              _PressDemo(),
              GalleryCaption('Selection'),
              _SelectionDemo(),
              GalleryCaption('Answer feedback'),
              _FeedbackDemo(),
              GalleryCaption('Results: pop, count-up, confetti'),
              _CelebrateDemo(),
            ],
          ),
        ),
      ],
    );
  }
}

class _PressDemo extends StatelessWidget {
  const _PressDemo();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PressableScale(
          child: FilledButton(onPressed: () {}, child: const Text('Continue')),
        ),
        const SizedBox(height: IsharaSpacing.listGap),
        PressableScale(
          onPressed: () {},
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
              child: Text(
                'Tappable card — scales to 0.97',
                style: text.bodyLarge,
              ),
            ),
          ),
        ),
        const SizedBox(height: IsharaSpacing.listGap),
        const _LipTile(),
      ],
    );
  }
}

/// A 3D roadmap-style tile whose face drops into its lip on press.
class _LipTile extends StatefulWidget {
  const _LipTile();

  @override
  State<_LipTile> createState() => _LipTileState();
}

class _LipTileState extends State<_LipTile> {
  bool _pressed = false;

  static const double _faceHeight = IsharaSpacing.s12 + IsharaSpacing.s2;
  static const double _lip = IsharaLip.standard;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: 'Roadmap-style button (press into lip)',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: SizedBox(
          height: _faceHeight + _lip,
          child: Stack(
            children: [
              Positioned.fill(
                top: _lip,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.funLimeLip,
                    borderRadius: IsharaRadius.brLg,
                  ),
                ),
              ),
              LipPress(
                pressed: _pressed,
                lipHeight: _lip,
                child: Container(
                  height: _faceHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.funLime,
                    borderRadius: IsharaRadius.brLg,
                  ),
                  child: Text(
                    'Start lesson',
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: c.funTealHero),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionDemo extends StatefulWidget {
  const _SelectionDemo();

  @override
  State<_SelectionDemo> createState() => _SelectionDemoState();
}

class _SelectionDemoState extends State<_SelectionDemo> {
  static const _options = ['Option A', 'Option B', 'Option C'];
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        for (var i = 0; i < _options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: IsharaSpacing.listGap),
            child: Semantics(
              selected: _selected == i,
              button: true,
              child: PressableScale(
                key: Key('gallery-option-$i'),
                onPressed: () => setState(() => _selected = i),
                child: SelectionHighlight(
                  selected: _selected == i,
                  child: Padding(
                    padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
                    child: Row(
                      children: [Text(_options[i], style: text.titleMedium)],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum _Result { correct, wrong }

class _FeedbackDemo extends StatefulWidget {
  const _FeedbackDemo();

  @override
  State<_FeedbackDemo> createState() => _FeedbackDemoState();
}

class _FeedbackDemoState extends State<_FeedbackDemo> {
  _Result? _result;
  int _shakes = 0;

  Future<void> _answer(_Result result) async {
    setState(() {
      _result = result;
      if (result == _Result.wrong) _shakes++;
    });
    await (result == _Result.correct
        ? IsharaFeedback.correct()
        : IsharaFeedback.wrong());
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      sheetAnimationStyle: IsharaFeedback.sheetAnimationStyle,
      builder: (context) => _DemoFeedbackSheet(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final (fill, border, label) = switch (_result) {
      _Result.correct => (c.successSubtle, c.successDefault, 'Correct'),
      _Result.wrong => (c.dangerSubtle, c.dangerDefault, 'Try again'),
      null => (c.bgSurface, c.borderDefault, 'Your answer'),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Shake(
          trigger: _shakes,
          child: AnimatedContainer(
            key: const Key('gallery-answer'),
            duration: IsharaMotion.duration(context, IsharaMotion.instant),
            curve: IsharaMotion.move,
            padding: const EdgeInsets.all(IsharaSpacing.cardPadding),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: IsharaRadius.brLg,
              border: Border.all(
                color: border,
                width: SelectionHighlight.selectedBorderWidth,
              ),
            ),
            child: Text(label, style: text.titleMedium),
          ),
        ),
        const SizedBox(height: IsharaSpacing.listGap),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                key: const Key('gallery-wrong'),
                onPressed: () => _answer(_Result.wrong),
                child: const Text('Wrong'),
              ),
            ),
            const SizedBox(width: IsharaSpacing.inlineGap),
            Expanded(
              child: FilledButton(
                key: const Key('gallery-correct'),
                onPressed: () => _answer(_Result.correct),
                child: const Text('Correct'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Stand-in for the real `FeedbackSheet` (built later from its Figma node).
class _DemoFeedbackSheet extends StatelessWidget {
  const _DemoFeedbackSheet({required this.result});

  final _Result result;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final correct = result == _Result.correct;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          IsharaSpacing.screenMargin,
          0,
          IsharaSpacing.screenMargin,
          IsharaSpacing.screenMargin,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  correct ? Icons.check_circle : Icons.cancel,
                  color: correct ? c.successDefault : c.dangerDefault,
                ),
                const SizedBox(width: IsharaSpacing.inlineGap),
                Text(
                  correct ? 'Nice work' : 'Not quite',
                  style: text.titleLarge?.copyWith(
                    color: correct ? c.successText : c.dangerText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: IsharaSpacing.stackGap),
            Text(
              'Slides up in standard / enter, leaves at ~75% with exit.',
              style: text.bodyMedium?.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: IsharaSpacing.s4),
            FilledButton(
              key: const Key('gallery-sheet-continue'),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lesson results motion (26–27): PopIn + CountUp + ConfettiBurst. Replay
/// rebuilds them with a new key.
class _CelebrateDemo extends StatefulWidget {
  const _CelebrateDemo();

  @override
  State<_CelebrateDemo> createState() => _CelebrateDemoState();
}

class _CelebrateDemoState extends State<_CelebrateDemo> {
  int _run = 0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: IsharaSizes.streakHero * 2,
      child: Stack(
        key: ValueKey(_run),
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopIn(
                  child: Container(
                    width: IsharaSizes.resultBadge,
                    height: IsharaSizes.resultBadge,
                    decoration: BoxDecoration(
                      color: c.funLime,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IsharaIcons.check,
                      size: IsharaSizes.resultBadgeIcon,
                      color: c.funTealHero,
                    ),
                  ),
                ),
                CountUp(
                  value: 15,
                  builder: (context, xp) => Text(
                    '+$xp XP',
                    style: context.textStyles.stat.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _run++),
                  child: const Text('Replay'),
                ),
              ],
            ),
          ),
          const Positioned.fill(child: ConfettiBurst()),
        ],
      ),
    );
  }
}
