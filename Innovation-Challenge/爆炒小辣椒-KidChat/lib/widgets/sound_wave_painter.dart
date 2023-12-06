import 'dart:math' as math;

import 'package:flutter/material.dart';

class SoundWavePainter extends CustomPainter {
  final double startAngle;

  final int tipCount;
  final double tipControlRatio;
  final double radiusRatio;
  final double downloadProgress;
  final double palyProgress;

  final Color fillColor;

  Path? _path;

  SoundWavePainter({
    this.startAngle = 0.0,
    this.tipControlRatio = 1.0,
    this.downloadProgress = 0.0,
    this.palyProgress = 0.0,
    required this.tipCount,
    required this.radiusRatio,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fillColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    // canvas.drawLine(
    //     Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    // canvas.drawLine(
    //     Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);

    final center = Offset(size.width / 2, size.height / 2);

    final path = Path();

    final radius = math.min(size.width, size.height) * radiusRatio / 2;

    path.addOval(Rect.fromCircle(center: center, radius: radius));

    if (tipCount == 0 && downloadProgress > 0.0 && downloadProgress < 1.0) {
      // 绘制一圈下载进度条
      final paint = Paint()
        ..color = Colors.purple
        ..strokeWidth = 8.0
        ..style = PaintingStyle.stroke;
      if (downloadProgress > 0.0 && downloadProgress < 1.0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius + 4),
          -math.pi / 2,
          math.pi * 2 * downloadProgress,
          true,
          paint,
        );
      }
      if (palyProgress > 0.0 && palyProgress < 1.0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius + 4),
          -math.pi / 2,
          math.pi * 2 * palyProgress,
          true,
          paint..color = Colors.blue,
        );
      }
    }

    // debugPrint("ratio: $ratio parts: $parts startAngle: $startAngle");
    // debugPrint("radius: $radius");
    // 将整个圆分成parts份
    for (var i = 0; i < tipCount; i++) {
      final a = startAngle + math.pi * 2 / tipCount * i;
      final sweep = math.pi * 2 / tipCount;
      final control = a + sweep / 2;
      // 先移动到起点
      path.moveTo(
          radius * math.cos(a) + center.dx, center.dy + radius * math.sin(a));

      // 计算控制点
      final controlPoint = Offset(
          radius * tipControlRatio * math.cos(control) + center.dx,
          center.dy + radius * tipControlRatio * math.sin(control));

      // 计算跨度终点
      final endPoint = Offset(radius * math.cos(a + sweep) + center.dx,
          center.dy + radius * math.sin(a + sweep));

      path.quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    }

    canvas.drawPath(path, paint);

    _path = path;
  }

  void addWave(Path path, double startAngle, double sweepAngle) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return _path != (oldDelegate as SoundWavePainter)._path ||
        fillColor != oldDelegate.fillColor;
  }

  @override
  bool? hitTest(Offset position) {
    return _path?.contains(position);
  }
}
