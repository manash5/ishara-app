import 'package:material_ui/material_ui.dart';

import '../../theme/theme.dart';

/// Internal: shakes [child] once each time [wrong] turns true
/// (motion.md: wrong answer → one short horizontal shake).
class ShakeOnWrong extends StatefulWidget {
  const ShakeOnWrong({super.key, required this.wrong, required this.child});

  final bool wrong;
  final Widget child;

  @override
  State<ShakeOnWrong> createState() => _ShakeOnWrongState();
}

class _ShakeOnWrongState extends State<ShakeOnWrong> {
  int _trigger = 0;

  @override
  void didUpdateWidget(ShakeOnWrong oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.wrong && !oldWidget.wrong) _trigger++;
  }

  @override
  Widget build(BuildContext context) =>
      Shake(trigger: _trigger, child: widget.child);
}

/// Internal: Figma option colours shared by AnswerOption, VideoOption and
/// MatchTile — (fill, border, border width, foreground).
typedef OptionColors = (Color fill, Color border, double width, Color fg);

OptionColors optionColors(
  IsharaColors c, {
  bool selected = false,
  bool success = false,
  bool danger = false,
}) {
  if (success) {
    return (
      c.successSubtle,
      c.successDefault,
      IsharaSizes.selectedBorder,
      c.successText,
    );
  }
  if (danger) {
    return (
      c.dangerSubtle,
      c.dangerDefault,
      IsharaSizes.selectedBorder,
      c.dangerText,
    );
  }
  if (selected) {
    return (
      c.funLavenderSubtle,
      c.funLavender,
      IsharaSizes.selectedBorder,
      c.textPrimary,
    );
  }
  return (c.bgSurface, c.borderDefault, IsharaSizes.outline, c.textPrimary);
}
