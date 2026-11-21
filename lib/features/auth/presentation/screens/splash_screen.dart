import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/splash_intro.dart';

/// Figma "01 Splash" (7:10): calm intro, then continues on its own.
///
/// It asks for /learn and lets the session redirect decide between Welcome,
/// onboarding and Learn. With reduced motion the final frame shows at once
/// and is held for [SplashMotion.reducedHold].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.colors.funTealHero,
        body: SplashIntro(progress: _controller, drift: _drift),
      ),
    );
  }
}
