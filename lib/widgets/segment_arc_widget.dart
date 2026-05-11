// AnimationController
import 'dart:math';

import 'package:flutter/material.dart';

class SegmentedArcLoader extends StatefulWidget {
  final Color color;
  final double size;
  const SegmentedArcLoader({this.color = Colors.white, this.size = 22});

  @override
  State<SegmentedArcLoader> createState() => SegmentedArcLoaderState();
}

class SegmentedArcLoaderState extends State<SegmentedArcLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _ArcPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _ArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const totalDots = 8;
    final step = (2 * pi) / totalDots;
    final rotationOffset = 2 * pi * progress;

    for (int i = 0; i < totalDots; i++) {
      final angle = step * i + rotationOffset;
      final opacity = (1.0 - (i / totalDots)).clamp(0.08, 1.0);
      final dotRadius = (size.width * 0.09).clamp(2.0, 5.0);
      final dx = center.dx + (radius - dotRadius) * cos(angle - pi / 2);
      final dy = center.dy + (radius - dotRadius) * sin(angle - pi / 2);

      canvas.drawCircle(
        Offset(dx, dy),
        dotRadius,
        Paint()..color = color.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}
