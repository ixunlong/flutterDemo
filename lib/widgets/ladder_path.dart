import 'package:flutter/cupertino.dart';

class LadderPath extends CustomClipper<Path>{
  LadderPath(this.reverse);

  final bool reverse;

  @override
  Path getClip(Size size) {
    var x = size.width;
    var y = size.height;
    var path = Path();
    path.moveTo(point(x, 0), y);
    path.quadraticBezierTo(point(x, x*0.021), y*0.882, point(x, x*0.0266), y*0.7641);
    path.lineTo(point(x, x*0.061), y*0.176);
    path.quadraticBezierTo(point(x, x*0.069), 0, point(x, x*0.085), 0);
    path.lineTo(point(x, x*0.851), 0);
    path.quadraticBezierTo(point(x, x*0.872), 0, point(x, x*0.888), y*0.176);
    path.lineTo(point(x, x*0.926), y*0.559);
    path.quadraticBezierTo(point(x, x*0.957), y*0.882, point(x, x), y);
    return path;
  }

  double point(double x,double point){
    return reverse?x-point:point;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}