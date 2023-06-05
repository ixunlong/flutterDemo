import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_html/style.dart';
import 'package:gaimon/gaimon.dart';
import 'package:get/get.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/res/styles.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/home/news_view.dart';
import 'package:vibration/vibration.dart';

class AppNewsFloatWidget extends StatefulWidget {
  const AppNewsFloatWidget({super.key});

  static bool pageInit = false;
  static bool _dragging = false;
  static bool _needCollect = false;
  static bool get needCollect => DateTime.now().difference(_lastDrag).inSeconds < 1 ? _needCollect : false;
  static int? _newsId;
  static int? get newsId => _newsId;
  static DateTime _lastDrag = DateTime.now();
  
  static final _sc = StreamController<PointerMoveEvent?>.broadcast();
  static updateDragging(bool v) {
    if (_dragging == v) { return; }
    _dragging = v;
    if (!v) { pageInit = false; }
    _sc.add(null);
  }
  static updateDragPoint(PointerMoveEvent e) {
    if (!_dragging || pageInit) { return; }
    _lastDrag = DateTime.now();
    _sc.add(e);
  }

  @override
  State<AppNewsFloatWidget> createState() => _AppNewsFloatWidgetState();
}

class _AppNewsFloatWidgetState extends State<AppNewsFloatWidget> {

  @override
  void initState() {
    super.initState();
  }

  late final size = MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AppNewsFloatWidget._sc.stream,
      builder: (context, snapshot) {
        final event = snapshot.data;
        if (event == null) { return Container(); }
        final distance = (Get.size.bottomRight(Offset.zero) - event.position).distance;
        
        final x = snapshot.data?.localPosition.dx ?? 0;
        final bsize = AppNewsFloatWidget._needCollect ? x * 1.1 : x;

        // log("${Get.currentRoute} ${Get.arguments} ${event.position} distance = $distance bsize = $bsize ");
        AppNewsFloatWidget._newsId = Utils.getGetxIntId;
        final needCollect = distance < bsize/2;
        if (needCollect != AppNewsFloatWidget._needCollect) {
          AppNewsFloatWidget._needCollect = needCollect;
          if (needCollect) {
            Gaimon.medium();
          }
        }

        return Positioned(
          right: -bsize/2,
          bottom: -bsize/2,
          child: Container(
            width: bsize,
            height: bsize,
            decoration: const BoxDecoration(
              color: Colours.grey66,
              shape: BoxShape.circle
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: bsize/2,
                height: bsize/2,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: OverflowBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: Container()),
                        Image.asset(Utils.getImgPath("icons_float.png"),width: 24,height: 24,color: Colors.white.withOpacity(0.5))
                          .marginOnly(right: 30),
                        Text("浮窗",style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: 12),)
                          .marginOnly(top: 10,right: 30),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ),
        );
    });
  }
}