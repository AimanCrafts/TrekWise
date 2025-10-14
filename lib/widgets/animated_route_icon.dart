import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedRouteIcon extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final double circleRadius;
  final VoidCallback? onAnimationComplete;

  const AnimatedRouteIcon({
    super.key,
    this.size = 150,
    this.strokeWidth = 17,
    this.circleRadius = 24,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedRouteIcon> createState() => _AnimatedRouteIconState();
}

class _AnimatedRouteIconState extends State<AnimatedRouteIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RouteIconPainter(
              _controller.value,
              strokeWidth: widget.strokeWidth,
              circleRadius: widget.circleRadius,
            ),
          );
        },
      ),
    );
  }
}

class _RouteIconPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final double circleRadius;

  _RouteIconPainter(this.progress, {this.strokeWidth = 20, this.circleRadius = 20});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final circlePaint = Paint()..color = Colors.white;

    final topLeft = Offset(0, 0);
    final bottomRight = Offset(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);

    if (progress < 0.2) {
      double r = circleRadius * (progress / 0.2);
      canvas.drawCircle(topLeft, r, circlePaint);
      canvas.drawCircle(bottomRight, r, circlePaint);
      return;
    } else {
      canvas.drawCircle(topLeft, circleRadius, circlePaint);
      canvas.drawCircle(bottomRight, circleRadius, circlePaint);
    }

    double lineProgress = ((progress - 0.2) / 0.8).clamp(0.0, 1.0);

    // ---- LEFT PATH ----
    Path leftPath = Path()..moveTo(topLeft.dx, topLeft.dy);

    double verticalY = min(size.height / 2, size.height / 2 * lineProgress * 3);
    leftPath.lineTo(topLeft.dx, topLeft.dy + verticalY);

    if (lineProgress > 0.33) {
      double arcProg = ((lineProgress - 0.33) / 0.33).clamp(0.0, 1.0);
      double arcOffsetY = size.height * 0.5;
      Rect arcRect = Rect.fromLTWH(0, size.height / 2 - size.width / 2 + arcOffsetY, size.width / 2, size.width / 2);
      leftPath.arcTo(arcRect, pi, -pi * arcProg, false);
    }

    if (lineProgress > 0.66) {
      double midProg = ((lineProgress - 0.66) / 0.34).clamp(0.0, 1.0);
      leftPath.lineTo(center.dx, size.height / 2 - (size.height / 2 - center.dy) * midProg);
    }

    canvas.drawPath(leftPath, paint);

    // ---- RIGHT PATH ----
    Path rightPath = Path()..moveTo(bottomRight.dx, bottomRight.dy);

    double verticalY2 = min(size.height / 2, size.height / 2 * lineProgress * 3);
    rightPath.lineTo(bottomRight.dx, bottomRight.dy - verticalY2);

    if (lineProgress > 0.33) {
      double arcProg = ((lineProgress - 0.33) / 0.33).clamp(0.0, 1.0);
      double arcOffsetY = -size.height * 0.3;
      Rect arcRect = Rect.fromLTWH(size.width / 2, size.height / 2 - size.width / 4 + arcOffsetY, size.width / 2, size.width / 2);
      rightPath.arcTo(arcRect, 0, -pi * arcProg, false);
    }

    if (lineProgress > 0.66) {
      double midProg = ((lineProgress - 0.66) / 0.34).clamp(0.0, 1.0);
      rightPath.lineTo(center.dx, size.height / 2 + (center.dy - size.height / 2) * midProg);
    }

    canvas.drawPath(rightPath, paint);
  }

  @override
  bool shouldRepaint(covariant _RouteIconPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
