import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';

/// The trek trail through a unit's waypoints, drawn bottom → top: solid
/// [walkedColor] up to the last reached stop, then dotted [aheadColor].
/// [progress] (0 → 1) draws it in on first load.
class TrailPainter extends CustomPainter {
  TrailPainter({
    required this.points,
    required this.walked,
    required this.walkedColor,
    required this.aheadColor,
    required this.progress,
  }) : super(repaint: progress);

  /// Waypoint centres, first lesson (bottom) first.
  final List<Offset> points;

  /// How many [points] are reached (the trail is solid between them).
  final int walked;
  final Color walkedColor;
  final Color aheadColor;
  final Animation<double> progress;

  static const double width = IsharaSizes.lipCard;
  static const double dotGap = IsharaSpacing.s3;
  static const double dotRadius = IsharaSizes.lipCard / 2;

  /// Smooth curve through [pts] (Catmull–Rom as cubic Béziers).
  static Path curveThrough(List<Offset> pts) {
    final path = Path();
    if (pts.isEmpty) return path;
    path.moveTo(pts.first.dx, pts.first.dy);
    for (var i = 0; i < pts.length - 1; i++) {
      final p0 = pts[math.max(i - 1, 0)];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = pts[math.min(i + 2, pts.length - 1)];
      final c1 = p1 + (p2 - p0) / 6;
      final c2 = p2 - (p3 - p1) / 6;
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final full = curveThrough(points);
    final metrics = full.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final drawn = metric.length * progress.value;

    final walkedLength = walked < 2
        ? 0.0
        : curveThrough(points.sublist(0, walked))
              .computeMetrics()
              .fold<double>(0, (sum, m) => sum + m.length);

    final solid = Paint()
      ..color = walkedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    final solidEnd = math.min(walkedLength, drawn);
    if (solidEnd > 0) {
      canvas.drawPath(metric.extractPath(0, solidEnd), solid);
    }

    final dot = Paint()..color = aheadColor;
    for (var d = walkedLength; d <= drawn; d += dotGap) {
      final t = metric.getTangentForOffset(d);
      if (t != null) canvas.drawCircle(t.position, dotRadius, dot);
    }
  }

  @override
  bool shouldRepaint(TrailPainter old) =>
      old.points != points ||
      old.walked != walked ||
      old.walkedColor != walkedColor ||
      old.aheadColor != aheadColor;
}

/// Two snow-capped peaks for the unit banner (decorative).
class RidgePainter extends CustomPainter {
  const RidgePainter({required this.rock, required this.snow});

  final Color rock;
  final Color snow;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    void peak(double left, double top, double right, double apex) {
      final base = Path()
        ..moveTo(left, h)
        ..lineTo(apex, top)
        ..lineTo(right, h)
        ..close();
      canvas.drawPath(base, Paint()..color = rock);
      // Snow cap: the top third of the peak.
      final capY = top + (h - top) / 3;
      final lx = apex - (apex - left) * (capY - top) / (h - top);
      final rx = apex + (right - apex) * (capY - top) / (h - top);
      final cap = Path()
        ..moveTo(apex, top)
        ..lineTo(rx, capY)
        ..lineTo((apex + rx) / 2, capY - (capY - top) / 4)
        ..lineTo(apex, capY)
        ..lineTo((apex + lx) / 2, capY - (capY - top) / 4)
        ..lineTo(lx, capY)
        ..close();
      canvas.drawPath(cap, Paint()..color = snow);
    }

    peak(w * 0.05, h * 0.35, w * 0.75, w * 0.4);
    peak(w * 0.4, 0, w * 1.05, w * 0.72);
  }

  @override
  bool shouldRepaint(RidgePainter old) => old.rock != rock || old.snow != snow;
}

/// A string of prayer flags — the trek's reward stop.
class PrayerFlagsPainter extends CustomPainter {
  const PrayerFlagsPainter({required this.colors, required this.string});

  final List<Color> colors;
  final Color string;

  @override
  void paint(Canvas canvas, Size size) {
    final sag = size.height * 0.25;
    final line = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 2, sag * 2, size.width, 0);
    canvas.drawPath(
      line,
      Paint()
        ..color = string
        ..style = PaintingStyle.stroke
        ..strokeWidth = IsharaSizes.outline,
    );
    final metric = line.computeMetrics().first;
    final n = colors.length;
    final flagW = size.width / (n + 1);
    for (var i = 0; i < n; i++) {
      final t = metric.getTangentForOffset(metric.length * (i + 1) / (n + 1))!;
      final p = t.position;
      final flag = Path()
        ..moveTo(p.dx - flagW / 2.6, p.dy)
        ..lineTo(p.dx + flagW / 2.6, p.dy)
        ..lineTo(p.dx, p.dy + size.height - sag)
        ..close();
      canvas.drawPath(flag, Paint()..color = colors[i]);
    }
  }

  @override
  bool shouldRepaint(PrayerFlagsPainter old) =>
      !listEquals(old.colors, colors) || old.string != string;
}
