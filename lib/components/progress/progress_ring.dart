import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../Core/constants/colors.dart';

/// Circular completion ring that animates smoothly between fractions.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.fraction,
    required this.size,
    this.strokeWidth = 8,
    this.trackColor = AppColorPalette.surfaceTintBlue,
    this.progressColor = AppColorPalette.primaryBlue,
    this.center,
  });

  /// Completed share of the workout, from 0.0 to 1.0.
  final double fraction;
  final double size;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: fraction.clamp(0, 1)),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double animatedFraction, Widget? _) {
          return CustomPaint(
            painter: _RingPainter(
              fraction: animatedFraction,
              strokeWidth: strokeWidth,
              trackColor: trackColor,
              progressColor: progressColor,
            ),
            child: Center(child: center),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  final double fraction;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset ringCenter = size.center(Offset.zero);
    final double radius = (size.shortestSide - strokeWidth) / 2;

    final Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor;
    canvas.drawCircle(ringCenter, radius, trackPaint);

    if (fraction <= 0) {
      return;
    }
    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = progressColor;
    canvas.drawArc(
      Rect.fromCircle(center: ringCenter, radius: radius),
      -math.pi / 2,
      2 * math.pi * fraction,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
