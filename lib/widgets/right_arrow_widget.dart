import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RightArrowWidget extends StatelessWidget {
  const RightArrowWidget(
      {super.key, this.width = 5, this.height = 10, this.color = Colors.black});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: Trianglepainter(color: color),
      ),
    );
  }
}

class Trianglepainter extends CustomPainter {
  Trianglepainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height / 2), painter);
    canvas.drawLine(
        Offset(size.width, size.height / 2), Offset(0, size.height), painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
