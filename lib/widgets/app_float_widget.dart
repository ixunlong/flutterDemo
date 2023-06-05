import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/app_news_float2_widget.dart';
import 'package:sports/widgets/app_news_float_widget.dart';
import 'package:sports/widgets/app_tip_widget.dart';
import 'package:sports/widgets/online_contact_float_widget.dart';
import 'app_tip_widget.dart';

class AppFloatWidget extends StatefulWidget {
  const AppFloatWidget({super.key, required this.child});

  final Widget? child;

  

  @override
  State<AppFloatWidget> createState() => _AppFloatWidgetState();
}

class _AppFloatWidgetState extends State<AppFloatWidget> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        // log("point move $event");
        AppNewsFloatWidget.updateDragPoint(event);
      },
      onPointerUp: (event) {
        AppNewsFloatWidget.updateDragging(false);
      },
      onPointerCancel: (event) {
        AppNewsFloatWidget.updateDragging(false);
      },
      child: Material(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Stack(
          children: [
            Container(child: widget.child,),
            // const OnlineContactFloatWidget()
            const AppTipWidget(),
            const AppNewsFloatWidget(),
            const AppNewsFloat2Widget()
          ],
        )) 
      ),
    );
  }

}