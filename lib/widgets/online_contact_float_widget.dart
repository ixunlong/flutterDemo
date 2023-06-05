import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_qiyu/flutter_qiyu.dart';
import 'package:get/get.dart';
import 'package:sports/util/online_contact.dart';
import 'package:sports/util/utils.dart';
import 'dart:io';

class OnlineContactFloatWidget extends StatefulWidget {
  const OnlineContactFloatWidget({super.key});

  @override
  State<OnlineContactFloatWidget> createState() => _OnlineContactFloatWidgetState();
}

class _OnlineContactFloatWidgetState extends State<OnlineContactFloatWidget> {

  Offset showPosition = Offset.zero;
  double size = 40;
  bool draged = false;
  bool hide = true;
  int vcount = 0;
  bool animted = false;

  Future toHide(bool bhide,{Duration delay = Duration.zero}) async {
    vcount += 1;
    final f = vcount;
    await Future.delayed(delay);
    
    
    if (f == vcount && !draged) {
      animted = true;
      update();
      hide = bhide;
      update();
      Future.delayed(Duration(milliseconds: 300)).then((value){
        animted = false;
        update();
      });
    }
  }

  unreadCountChange() {
    if (OnlineContact.instance.unreadCount == 0) {
      toHide(true);
    } else if (!OnlineContact.instance.inChatWindow) {
      toHide(false).then((value) {
        toHide(true,delay: Duration(seconds: 4));
      });
    }
    // log("un read changed");
    // update();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // OnlineContact.instance.onUnreadChange = unreadCountChange;
    showPosition = Offset(Get.width - size - 16, Get.height - 100);
    toHide(true);
  }

  @override
  void dispose() {
    if (OnlineContact.instance.onUnreadChange == unreadCountChange) {
      OnlineContact.instance.onUnreadChange = null;
    }
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final gesture = GestureDetector(
      onTap: () {
        log("tap to hide");
        toHide(true);
        OnlineContact.instance.openServiceWindow();
      },
      onPanStart: (details) {
        draged = true;
        update();
      },
      onPanEnd: (details) {
        draged = false;
        log("pan end to hide");
        toHide(true, delay: Duration(seconds: 4));
      },
      onPanUpdate: (details) {
        showPosition = Offset(showPosition.dx + details.delta.dx, showPosition.dy + details.delta.dy);
        update();
      },
      child: content()
    );
    return draged ? Positioned(
      left: showPosition.dx,
      top: showPosition.dy,
      child: gesture, 
    ) : AnimatedPositioned(
      left: hide ? ((showPosition.dx > Get.width/2) ? Get.width + size : -size) : showPosition.dx,
      top: showPosition.dy,
      child: gesture, 
      duration: const Duration(milliseconds: 200));
  }

  Widget content() {
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow( color: Colors.amber,blurRadius: 5 )]
      ),
      child: Text("${OnlineContact.instance.unreadCount}"),
    );
  }
}