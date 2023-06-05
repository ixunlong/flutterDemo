import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/widgets/app_news_float_widget.dart';

class NewsTransition extends CustomTransition {
  @override
  Widget buildTransition(BuildContext context, Curve? curve, Alignment? alignment, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    
    final dragging = (animation.value > 0.015) && (animation.value < 0.99);
    if (secondaryAnimation.value == 0 && Platform.isIOS) {
      AppNewsFloatWidget.updateDragging(dragging);
    }
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1,0),end: const Offset(0, 0)).animate(animation),
      child: child,);
  }
}