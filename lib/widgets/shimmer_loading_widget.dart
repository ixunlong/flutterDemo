import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

import '../res/colours.dart';

class ShimmerLoading extends StatelessWidget{
  const ShimmerLoading({super.key,
    this.color = Colours.greyEE,
    this.highlightColor = Colours.white,
    this.shape = BoxShape.rectangle,
    required this.width,
    required this.height, this.borderRadius});

  final Color color;
  final Color highlightColor;
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: color,
        highlightColor: highlightColor,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(shape: shape,color: color,borderRadius: borderRadius)));
  }

}