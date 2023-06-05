import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:sports/widgets/common_button.dart';

class TipResources {
  _TipResources() {}

  static List<LbtEntity> _tips =
      SpUtils.appTips?.map((e) => LbtEntity.fromJson(e)).toList() ?? [];
  static List<LbtEntity> get tips =>
      _tips.map((e) => LbtEntity.fromJson(e.toJson())).toList(growable: false);

  static DateTime? _fetchTime;
  static DateTime? get fetchTime => _fetchTime;
  static String? _userid;
  static String? get userid => _userid;

  static Future _fetchTipResources() async {
    final uid = User.auth?.userId;
    final list = await Api.getAppList("app_res_tips");
    if (list?.isEmpty ?? true) {
      return;
    }
    _fetchTime = DateTime.now();
    _userid = uid;
    _tips = list!;
    SpUtils.appTips = _tips.map((e) => e.toJson()).toList();
  }

  static Future fetchTipResources() async {
    _sc = StreamController.broadcast();
    await _fetchTipResources();
    _sc?.add(null);
    _sc?.close();
    _sc = null;
  }

  static StreamController? _sc;

  static next(void Function() fn) {
    if (_sc != null) {
      _sc?.stream.listen((event) {
        fn.call();
      });
    } else {
      fn.call();
    }
  }

  static List<LbtEntity> getTips(String title) {
    return tips.filter((item) => item.title == title);
  }

  static LbtEntity? getTip(String title) {
    final l = getTips(title);
    if (l.isNotEmpty) {
      return l.first;
    }
    return null;
  }

  static List<LbtEntity> get viewpointTips =>
      tips.filter((item) => item.title == "viewpoint-tips");

  static LbtEntity? get switchRecharge => getTip("switch-recharge");

  static List<LbtEntity>? get discountDescribes =>
      tips.filterOrNull((item) => item.title == "describe-discount");

  static LbtEntity? get gift4newuser => getTip("activity-gift-1zhe");

  static List<LbtEntity>? get gift4newuserTips =>
      tips.filterOrNull((item) => item.title == "activity-gift-1zhe-tips");

  static LbtEntity? get onlineAvatarLeft => getTip("online-avatar-left");
}

class NewUserGiftDialog extends StatelessWidget {
  const NewUserGiftDialog(
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
                    Get.back();
                    tip.doJump();
                  },
                  minHeight: btn['height'] ?? 52,
                )
              ],
            ),
          ),
          const SizedBox( height: 10 ),
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

class TipGift {
  static bool hasTipedIn7Days(String uid) {
    try {
      final json = SpUtils.gift4newuser;
      Json? info = json[uid];
      if (info == null) {
        return false;
      }
      int millis = info['time'] ?? 0;
      final time = DateTime.fromMillisecondsSinceEpoch(millis);
      return DateTime.now().difference(time).inDays < 7;
    } catch (err) {}
    return true;
  }

  static tagTiped(String uid) {
    final json = SpUtils.gift4newuser;
    json[uid] = {"time": DateTime.now().millisecondsSinceEpoch};
    SpUtils.gift4newuser = json;
  }

  static bool _tiping = false;
  static LbtEntity? _lastData;
  static String? _lastUserid;
  static DateTime? _lastTime;

  static Future<LbtEntity?> getActivity1zhe() async {
    final items = await Api.getAppList("app_login");
    return items
        ?.filterOrNull((item) => item.title == "activity-gift-1zhe")
        ?.first;
  }

  static _checkNewuserGift() async {
    final uid = User.auth?.userId;
    if (!uid.valuable || uid == null) {
      return;
    }
    if (hasTipedIn7Days(uid)) {
      return;
    }
    // 检查 uid 是否相等

    final tip = await getActivity1zhe(); //TipResources.gift4newuser;

    if (tip == null || tip.imgUrl == null) {
      return;
    }

    final f = await DefaultCacheManager().getSingleFile(tip.imgUrl ?? "");
    final bytes = await f.readAsBytes();
    final image = await decodeImageFromList(bytes);

    // (await image.toByteData())?.buffer.asUInt8List();
    // final image = Image.memory(f.readAsBytesSync());
    tagTiped(uid);
    _lastUserid = uid;
    _lastData = tip;

    final w = Get.width * 0.75;

    await Get.dialog(
        NewUserGiftDialog(
            tip: tip,
            image: Image.memory(bytes, scale: 3),
            width: w,
            height: w / image.width * image.height),
        barrierDismissible: false);
  }

  static checkNewuserGift() async {
    if (_tiping) {
      return;
    }
    _tiping = true;
    try {
      await _checkNewuserGift();
    } catch (err) {}
    _tiping = false;
  }
}
