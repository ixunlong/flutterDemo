// ignore_for_file: avoid_init_to_null

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sports/res/colours.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/view/navigation_page.dart';
import 'package:sports/widgets/common_dialog.dart';
import 'package:sports/widgets/select_bottomsheet.dart';
import 'package:sports/widgets/share_bottom_sheet.dart';
import 'package:tencent_kit/tencent_kit_platform_interface.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:wechat_kit/wechat_kit.dart';
// import 'package:weibo_kit/weibo_kit_platform_interface.dart';

// import 'package:sports/util/date_utils.dart' as date;

export 'datetime_ex1.dart';

class Utils {
  static String getImgPath(String name) {
    return 'assets/images/$name';
  }

  static String getFilePath(String name) {
    return 'assets/files/$name';
  }

  static String getSoundPath(String name) {
    return 'assets/sound/$name.mp3';
  }

  static String generateRandomString(int length) {
    final random = math.Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();
    return randomString;
  }

  //日期格式化
  static String formatTime(int timestamp) {
    int interval = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (interval < 60 * 1000) {
      interval = interval ~/ 1000;
      return '$interval秒前';
    } else if (interval < 60 * 60 * 1000) {
      interval = interval ~/ 60000;
      return '$interval分钟前';
    } else if (interval < 24 * 60 * 60 * 1000) {
      interval = interval ~/ 3600000;
      return '$interval小时前';
    } else if (interval < 3 * 24 * 60 * 60 * 1000) {
      interval = interval ~/ (3600000 * 24);
      return '$interval天前';
    } else {
      return DateUtilsExtension.formatTimeStamp(timestamp, 'MM-dd HH:mm');
    }
  }

  //阅读人数格式化
  static String formatReadNum(int num) {
    if (num < 9999) {
      return num.toString();
    } else {
      num = num ~/ 10000;
      return '$num万+';
    }
  }

  // Future<bool?> alertTip(String tip) {
  //   return Get.dialog(CupertinoAlertDialog(
  //     title: Text("提示"),
  //     content: Text(tip),
  //     actions: [CupertinoDialogAction(
  //       onPressed: () {
  //         Get.back(result:true);
  //       },
  //       child: Text("确定")
  //     )],
  //   ));
  // }

  static Future<bool?> alertQuery(String msg) {
    return Get.dialog(CommonDialog.alert((msg)));
    // return Get.dialog(CupertinoAlertDialog(
    //   title: Text("提示"),
    //   content: Text(msg),
    //   actions: [
    //     CupertinoDialogAction(
    //         onPressed: () {
    //           Get.back(result: false);
    //         },
    //         child: Text("取消")),
    //     CupertinoDialogAction(
    //         onPressed: () {
    //           Get.back(result: true);
    //         },
    //         child: Text("确定"))
    //   ],
    // ));
  }

  static Future<int?> sheetSelect(List<String> items) async {
    return await Get.bottomSheet(SelectBottomSheet(List.from(items)));
  }

  static FutureOr<T?> tryOrNullf<T>(FutureOr<T> Function() fn) async {
    try {
      return await fn();
    } catch (err) {
      log("$err");
      return null;
    }
  }

  static String numW(int num) {
    if (num < 10000) {
      return "$num";
    }
    return "${num ~/ 10000}万+";
  }

  static String numLimit(int v, {int limit = 99}) {
    if (v <= limit) {
      return "$v";
    }
    return "$limit+";
  }

  static String getFileSize(int length) {
    String size = "";
    //内存转换
    if (length < 0.1 * 1024) {
      size = length.toStringAsFixed(2);
      size = size + "B";
    } else if (length < 0.1 * 1024 * 1024) {
      size = (length / 1024).toStringAsFixed(2);
      // size = size.toStringAsFix
      size = size + "KB";
    } else if (length < 0.1 * 1024 * 1024 * 1024) {
      size = (length / (1024 * 1024)).toStringAsFixed(2);
      print(size.indexOf("."));
      size = size + "MB";
    } else {
      size = (length / (1024 * 1024 * 1024)).toStringAsFixed(2);
      size = size + "GB";
    }
    return size;
  }

  static const miCh = "′";

  static Future doRoute(String routestr) async {
    String ref = routestr;
    try {
      ref = String.fromCharCodes(base64Decode(ref));
    } catch (err) {}

    if (RegExp("^http[s]?://").hasMatch(ref)) {
      Get.toNamed(Routes.webview, arguments: {"url": ref});
      return;
    }
    log("do jump setp 2");
    _jsonJump(ref);
  }

  static String _resolvePath(String path, {String? subpath}) {
    final topPath = {
      '/home': '首页',
      '/match': '比赛',
      '/expert': "推荐",
      '/data': '数据',
      '/my': '我的'
    };
    return topPath[path] ?? path;
  }

  static _jsonJump(String source) {
    try {
      final map = jsonDecode(source);
      String path = map['path']! as String;
      final String? subpath = map['subpath'];
      final arguments = map['arguments'];
      Map<String, String>? params;
      if (map['params'] != null) {
        params = map['params']!.cast<String, String>();
      }
      path = _resolvePath(path, subpath: subpath);
      if (path.startsWith("/")) {
        Get.toNamed(path,
            arguments: arguments, parameters: params, preventDuplicates: false);
      } else {
        NavigationPage.callJump(path);
      }
    } catch (err) {
      log("json jump err ${err}");
    }
  }

  static onEvent(String eventId, {Map<String, dynamic>? params}) {
    log('友盟统计埋点============ eventId = $eventId,  params = $params');
    UmengCommonSdk.onEvent(eventId, params ?? {});
  }

  static String numberFormat(number) {
    var format = intl.NumberFormat('0,000');
    return format.format(number);
  }

  static String basketPositionCn(String? position) {
    switch (position) {
      case "C":
        return "中锋";
      case "SF":
        return "小前锋";
      case "PF":
        return "大前锋";
      case "SG":
        return "得分后卫";
      case "PG":
        return "组织后卫";
      case "F":
        return "前锋";
      case "G":
        return "后卫";
      default:
        return "";
    }
  }

  /// 2020-2021 转 20/21
  static String parseYear(String year) {
    String yearStr = year;
    if (yearStr.length > 4) {
      yearStr = '${yearStr.substring(2, 4)}/${yearStr.substring(7, 9)}';
    }
    return yearStr;
  }

  static int? get getGetxIntId => () {
        final id = int.tryParse(Get.parameters['id'] ?? "");
        log("get Getx Int id = $id");
        if (id != null) {
          return id;
        }
        if (Get.arguments is int) {
          return Get.arguments as int;
        } else {
          return null;
        }
      }.call();
  static String? get getGetxStringId =>
      Get.parameters['id'] ??
      () {
        if (Get.arguments is String) {
          return Get.arguments as String;
        }
      }.call();
}

typedef FilterFn<T> = bool Function(T item);

extension ListEx1<T> on List<T> {
  List<T> filter(FilterFn<T> fn) {
    List<T> l = [];
    for (var element in this) {
      if (fn(element)) {
        l.add(element);
      }
    }
    return l;
  }

  List<T>? filterOrNull(FilterFn<T> fn) {
    final l = filter(fn);
    if (l.isEmpty) {
      return null;
    }
    return l;
  }
}

extension ListExtension on List? {
  bool get hasValue => this != null && this!.isNotEmpty;
}

extension StringExtension on String? {
  bool get valuable => this != null && this!.isNotEmpty;
  int? toInt() {
    if (this == null) {
      return null;
    } else {
      return int.tryParse(this!);
    }
  }

  double? toDouble() {
    if (this == null) {
      return null;
    } else {
      return double.tryParse(this!);
    }
  }
}

extension StringEx1 on String {
  String lastString(int len) =>
      substring((length - len) > 0 ? (length - len) : 0, length);
}

extension WidgetEx1 on Widget {
  SizedBox sized({double? width = null, double? height = null}) =>
      SizedBox(width: width, height: height, child: this);
  GestureDetector tap(void Function()? fn) =>
      GestureDetector(onTap: fn, behavior: HitTestBehavior.opaque, child: this);
  rounded(double r) => Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(r)),
      clipBehavior: Clip.hardEdge,
      child: this);
  Center get center => Center(child: this);

  Widget badge(String? text, {bool border = false}) => Stack(
        clipBehavior: Clip.none,
        children: [
          this,
          if ((text ?? "").isNotEmpty)
            Positioned(
                top: 0,
                right: 0,
                width: 1,
                height: 1,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(minHeight: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colours.main,
                        borderRadius: BorderRadius.circular(20),
                        border: border
                            ? Border.all(color: Colors.white, width: 2)
                            : null),
                    // height: 11,
                    child: Text(
                      text!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ))
        ],
      );
}

extension FontWeightEx1 on FontWeight {
  static FontWeight get qxbBold => FontWeight.w600;
  static FontWeight get qxbNormal => FontWeight.w400;
  static FontWeight get qxbMedium => FontWeight.w500;
}

extension StateEx1 on State {
  update() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }
}

extension NullCheck on String? {
  bool get isNullOrEmpty => this == null || this == '';
}

extension TextWidth on Text {
  Container wrapTextWidth(double fontSize, FontWeight fontWeight) {
    var tp = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: data,
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight)))
      ..layout();
    return Container(width: tp.width, child: this);
  }
}

extension WidgetAlign on Widget {
  Widget get alignEnd =>
      Container(alignment: Alignment.centerRight, child: this);
  Widget get alignStart =>
      Container(alignment: Alignment.centerLeft, child: this);
  Widget get alignTop => Container(alignment: Alignment.topCenter, child: this);
  Widget get alignBottom =>
      Container(alignment: Alignment.bottomCenter, child: this);
}
