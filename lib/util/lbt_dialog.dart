import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/widgets/common_button.dart';
import 'package:sports/widgets/common_dialog.dart';

class LbtDialogImageWidget extends StatelessWidget {
  const LbtDialogImageWidget(
      {super.key,
      required this.tip,
      required this.image,
      required this.width,
      required this.height});

  final LbtEntity tip;
  final Image image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    log("width $width height $height");
    Json btn = {};
    try {
      btn = jsonDecode(tip.button ?? "");
    } catch (err) {}
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            height: height,
            decoration:
                BoxDecoration(image: DecorationImage(image: image.image,fit: BoxFit.fitWidth)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: btn['top'] ?? 0,
                ),
                CommonButton(
                  onPressed: () {
                    Get.back(result: true);
                  },
                  minHeight: btn['height'] ?? height,
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(side: BorderSide.none),
              child: Container(
                child: Image.asset(Utils.getImgPath("close_icon_circle.png")),
                width: 32,
                height: 32,
              ))
        ],
      ),
    );
  }
}

class LbtDialogUtil {

  static List<String> showedLbts = SpUtils.lbtDialogIds;

  static bool checking = false;

  static Future<bool> _handleLbtDialog(LbtEntity element,String route) async {
    
    final splited = element.title?.split(":") ?? [];
    if (splited.length == 2 && route != splited[1]) { return false; }

    final id = element.id ?? 0;
    final idx = showedLbts.indexWhere((element) => element.startsWith("${id}:"));
    final str = idx >= 0 ? showedLbts[idx] : "$id:0";
    final time = DateTime.fromMillisecondsSinceEpoch(int.parse(str.split(":").last));
    final now = DateTime.now();
    
    if (idx >= 0) {
      try {
        final obj = jsonDecode(element.button ?? "") as Map<String,dynamic>;
        final seconds = obj['duration'];
        if (seconds > now.difference(time).inSeconds) { return false; }
      } catch(e) { return false; }
    }

    Widget? dialogWidget;

    log("check lbt dialog ${element.toJson()}");
    bool r = false;
    if (element.imgUrl?.isNotEmpty ?? false) {
      
      log("check lbt dialog img ${element.toJson()}");
      final f = await DefaultCacheManager().getSingleFile(element.imgUrl!);
      final bytes = await f.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final w = Get.width * 0.75;
      dialogWidget = LbtDialogImageWidget(
        tip: element,
        image: Image.memory(bytes, scale: 3),
        width: w,
        height: (w / image.width) * image.height);

    } else if (element.content?.isNotEmpty ?? false) {

      log("check lbt dialog content ${element.toJson()}");
      dialogWidget = CommonDialog.alert("", content: element.content!);

    }

    if (dialogWidget != null && Get.overlayContext != null) {
      
      r = true;
      
      final msg = "${id}:${DateTime.now().millisecondsSinceEpoch}";
      if (idx >= 0) { showedLbts[idx] = msg; } 
      else { showedLbts.add(msg); }
      log("check ${showedLbts}");

      final a = await showDialog(
        barrierDismissible: false,
        context: Get.overlayContext!, builder: (context) => dialogWidget!);
      if (a is bool && a) { await element.doJump(); }

    }
    return r;
  }

  static checkShowDialog({String? curRoute}) async {
    
    if (checking) { return; }
    if (Get.isDialogOpen ?? true) { return; }

    final route = curRoute ?? Get.currentRoute;
    if (route == Routes.navigation || route == '/') { return; }
    
    checking = true;
    await Future.delayed(500.ms);

    bool handleSomething = false;
    final r = Get.find<ResourceService>();
    final list = r.appStart?.filterOrNull(
            (item) => item.title?.startsWith("app-dialog") ?? false) ?? [];
            
    for (var element in list) {
      try {
        if (await _handleLbtDialog(element,route)) {
          handleSomething = true;
        }
      } catch (err) {}
    }
    
    if (handleSomething) { 
      //控制 只有40个 lbt 对象
      if (showedLbts.length > 40) { showedLbts.removeRange(0, showedLbts.length - 40); }
      SpUtils.lbtDialogIds = showedLbts; 
    }

    checking = false;
  }
}
