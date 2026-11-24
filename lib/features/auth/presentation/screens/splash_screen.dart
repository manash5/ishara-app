import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../providers/session_provider.dart';
import '../widgets/splash_intro.dart';

/// Figma "01 Splash" (7:10): calm intro, then continues on its own.
///
/// Once the intro has played and the stored session is restored
/// ([SessionState.ready]), it asks for /learn and lets the session redirect
/// decide between Welcome, onboarding and Learn. With reduced motion the
/// final frame shows at once and is held for [SplashMotion.reducedHold].
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: SplashMotion.total,
  );

  /// Ambient float of the backdrop circles, looping for as long as the
  /// Splash is on screen.
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: SplashMotion.driftPeriod,
  );
  Timer? _hold;
  bool _started = false;

  /// The intro is done; leave as soon as the session is ready.
  bool _introDone = false;
  bool _left = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (IsharaMotion.reduced(context)) {
      _controller.value = 1;
      _hold = Timer(SplashMotion.reducedHold, _continue);
    } else {
      _drift.repeat();
      _controller.forward().then((_) => _continue());
    }
  }

  void _continue() {
    if (!mounted) return;
    _introDone = true;
    _leaveIfReady(ref.read(sessionProvider).ready);
  }

  void _leaveIfReady(bool ready) {
    if (!_introDone || !ready || _left || !mounted) return;
    _left = true;
    const LearnRoute().go(context);
  }

  @override
  void dispose() {
    _hold?.cancel();
    _controller.dispose();
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      sessionProvider.select((s) => s.ready),
      (_, ready) => _leaveIfReady(ready),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.colors.funTealHero,
        body: SplashIntro(progress: _controller, drift: _drift),
      ),
    );
  }
}
