import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import 'ishara_sizes.dart';

/// Lucide glyphs used by the Figma kit (`Icon/*` components).
abstract final class IsharaIcons {
  static const IconData arrowLeft = LucideIcons.arrowLeft;
  static const IconData close = LucideIcons.x;
  static const IconData chevronRight = LucideIcons.chevronRight;
  static const IconData check = LucideIcons.check;
  static const IconData eye = LucideIcons.eye;
  static const IconData eyeOff = LucideIcons.eyeOff;
  static const IconData mail = LucideIcons.mail;
  static const IconData hand = LucideIcons.hand;
  static const IconData bell = LucideIcons.bell;
  static const IconData target = LucideIcons.target;
  static const IconData wifiOff = LucideIcons.wifiOff;
  static const IconData camera = LucideIcons.camera;
  static const IconData search = LucideIcons.search;
  static const IconData flame = LucideIcons.flame;
  static const IconData zap = LucideIcons.zap;
  static const IconData lock = LucideIcons.lock;
  static const IconData rotateCcw = LucideIcons.rotateCcw;
  static const IconData trophy = LucideIcons.trophy;
  static const IconData house = LucideIcons.house;
  static const IconData bookOpen = LucideIcons.bookOpen;
  static const IconData user = LucideIcons.user;
  static const IconData flipHorizontal = LucideIcons.flipHorizontal;
  static const IconData lightbulb = LucideIcons.lightbulb;
  static const IconData settings = LucideIcons.settings;
  static const IconData moon = LucideIcons.moon;
  static const IconData sun = LucideIcons.sun;
  static const IconData globe = LucideIcons.globe;
  static const IconData shieldCheck = LucideIcons.shieldCheck;
  static const IconData logOut = LucideIcons.logOut;
  static const IconData clock = LucideIcons.clock;
  static const IconData info = LucideIcons.info;
  static const IconData cameraOff = LucideIcons.cameraOff;
  static const IconData scan = LucideIcons.scan;
  static const IconData flag = LucideIcons.flag;
}

/// The custom filled icons from Figma (`Icon/*-fill`); Lucide has none.
enum IsharaFilledIconKind {
  flame('assets/icons/flame_fill.svg'),
  heart('assets/icons/heart_fill.svg'),
  zap('assets/icons/zap_fill.svg'),
  star('assets/icons/star_fill.svg'),
  play('assets/icons/play_fill.svg');

  const IsharaFilledIconKind(this.asset);
  final String asset;
}

/// A filled icon tinted with a theme token at runtime.
class IsharaFilledIcon extends StatelessWidget {
  const IsharaFilledIcon(
    this.kind, {
    super.key,
    required this.color,
    this.size = IsharaSizes.iconLg,
    this.semanticLabel,
  });

  final IsharaFilledIconKind kind;
  final Color color;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      kind.asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
