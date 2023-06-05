import 'package:flutter/material.dart';
import 'dart:math' as math;

class RateCircleWidget extends StatelessWidget {
  const RateCircleWidget(
      {Key? key,
      this.color1 = Colors.cyan,
      this.color2 = Colors.red,
      this.rate = 0.5,
      this.radius = 40,
      this.width = 10})
      : super(key: key);

  final Color color1;
  final Color color2;
  final double rate;
  final double radius;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi * (rate - 1),
      child: CustomPaint(
        painter: CirclePainer(color1, color2, rate, radius, width),
      ),
    );
  }
}

class CirclePainer extends CustomPainter {
  CirclePainer(this.color1, this.color2, this.rate, this.radius, this.width);
  final Color color1;
  final Color color2;
  final double rate;
  final double radius;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = color2
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    // canvas.drawCircle(Offset(size.width / 2, size.height / 2), 30, painter);

    final path = Path()
      ..addArc(
          Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2), radius: radius),
          math.pi * 0.05,
          math.pi * 2 * (1 - rate) * 0.9);

    canvas.drawPath(path, painter);

    painter.color = color1;
    final path2 = Path()
      ..addArc(
          Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2), radius: radius),
          -math.pi * 0.05,
          -math.pi * 2 * rate * 0.9);

    canvas.drawPath(path2, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
