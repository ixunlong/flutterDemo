import 'dart:developer';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_identity/device_identity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Getx;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/error_interceptor.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/app_config.dart';
import 'package:sports/util/method_channel_utils.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';

// public static final String appId = "appId"; //产品标识
// public static final String channel = "channel"; //渠道
// public static final String version = "version"; //app版本
// public static final String os = "os"; //操作系统
// public static final String osVersion = "osVersion"; //操作系统版本
// public static final String pnt = "pnt"; //经纬度
// public static final String network = "network"; //网络
// public static final String model = "model"; //手机型号
// uuid
// idfa

// 渠道       平台   渠道号
// AppStore  iOS   c10000
// PC官网     安卓   c11000
// 华为       安卓   c11001
// 小米       安卓   c11002
// OPPO      安卓   c11003
// VIVO      安卓   c11004
// 魅族       安卓   c11005
// 应用宝     安卓   c11006
// 百度       安卓   c11007
// 360       安卓   c11008
//其他自定义  安卓    c12***

class HeaderDeviceInfo {
  static const appid = "qxb";
  //默认给个android 苹果会在初始化时赋值
  static String channel = "";
  static String version = "";
  static String os = "";
  static String osVersion = "";
  static String pnt = "";
  static String network = "";
  static String model = "";
  static String uuid = "";
  static String idfa = "";
  static String imei = "";
  static String oaid = "";
  static String pushId = "";

  static Map<String, String> get json => {
        "appid": HeaderDeviceInfo.appid,
        "channel": HeaderDeviceInfo.channel,
        "version": HeaderDeviceInfo.version,
        "os": HeaderDeviceInfo.os,
        "osVersion": HeaderDeviceInfo.osVersion,
        "pnt": HeaderDeviceInfo.pnt,
        "network": HeaderDeviceInfo.network,
        "model": HeaderDeviceInfo.model,
        "uuid": HeaderDeviceInfo.uuid,
        "idfa": HeaderDeviceInfo.idfa,
        "imei": HeaderDeviceInfo.imei,
        "oaid": HeaderDeviceInfo.oaid,
        "pushId": HeaderDeviceInfo.pushId
      };

  static String get descrption => "${json}";
  static describe() {
    log("header ext info = ${HeaderDeviceInfo.descrption}");
  }

  static init() async {
    HeaderDeviceInfo.uuid = SpUtils.appUuid;
    await AppConfig.readfromfile();
    if (Platform.isAndroid) {
      HeaderDeviceInfo.os = "android";
      // MethodChannelUtils.getAndroidChannel().then((value) {
      //   HeaderDeviceInfo.channel = value ?? '';
      // });
      HeaderDeviceInfo.channel = AppConfig.config.channel ?? '';
    } else if (Platform.isIOS) {
      HeaderDeviceInfo.os = "ios";
      HeaderDeviceInfo.channel = "c10000";
    } else {
      HeaderDeviceInfo.os = "other";
    }

    // PackageInfo.fromPlatform().then((value) {
    //   HeaderDeviceInfo.version = value.version;
    // });
    final package = await PackageInfo.fromPlatform();
    HeaderDeviceInfo.version = package.version;

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      HeaderDeviceInfo.model = deviceInfo.model;
      HeaderDeviceInfo.osVersion = deviceInfo.fingerprint;
      // DeviceInfoPlugin().androidInfo.then((info) {
      //   HeaderDeviceInfo.model = info.model;
      //   HeaderDeviceInfo.osVersion = info.fingerprint;
      // });
    }
    if (Platform.isIOS) {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      HeaderDeviceInfo.model = deviceInfo.utsname.nodename ?? "";
      HeaderDeviceInfo.osVersion = deviceInfo.systemVersion ?? "";
      // DeviceInfoPlugin().iosInfo.then((info) {
      //   HeaderDeviceInfo.model = info.utsname.nodename ?? "";
      //   HeaderDeviceInfo.osVersion = info.systemVersion ?? "";
      // });
    }
    await getIDFA();
    await getAndroidId();
    HeaderDeviceInfo.describe();
  }

  static DateTime _lastTime4idfa = DateTime.fromMillisecondsSinceEpoch(0);

  static getIDFA() async {
    if (Platform.isAndroid) {
      return;
    }
    if (HeaderDeviceInfo.idfa.isNotEmpty) {
      return;
    }
    if (DateTime.now().difference(_lastTime4idfa).inSeconds < 60) {
      return;
    }
    _lastTime4idfa = DateTime.now();
    try {
      final auth = await AdvertisingId.isLimitAdTrackingEnabled;
      final id = await AdvertisingId.id(true);
      log("idfa = $id auth = $auth");
      HeaderDeviceInfo.idfa = id ?? "";
    } catch (err) {
      log("get idfa error $err");
    }
  }

  static getAndroidId() async {
    if (Platform.isIOS) {
      return;
    }
    await DeviceIdentity.register();
    String imei = await DeviceIdentity.imei;
    String oaid = await DeviceIdentity.oaid;
    HeaderDeviceInfo.imei = imei;
    HeaderDeviceInfo.oaid = oaid;
  }

  static networkSet(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi) {
      HeaderDeviceInfo.network = "wifi";
    } else if (result == ConnectivityResult.mobile) {
      HeaderDeviceInfo.network = "mobile";
    } else if (result == ConnectivityResult.none) {
      HeaderDeviceInfo.network = "none";
    } else {
      HeaderDeviceInfo.network = "other";
    }
  }
}

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final auth = SpUtils.loginAuth;
    options.headers["Authorization"] = auth?.token;
    log("token = ${auth?.token}");

    // options.headers["appid"] = HeaderDeviceInfo.appid;
    // options.headers["channel"] = HeaderDeviceInfo.channel;
    // options.headers["version"] = HeaderDeviceInfo.version;
    // options.headers["os"] = HeaderDeviceInfo.os;
    // options.headers["osVersion"] = HeaderDeviceInfo.osVersion;
    // options.headers["pnt"] = HeaderDeviceInfo.pnt;
    // options.headers["network"] = HeaderDeviceInfo.network;
    // options.headers["model"] = HeaderDeviceInfo.model;
    // options.headers["uuid"] = HeaderDeviceInfo.uuid;
    // options.headers["idfa"] = HeaderDeviceInfo.idfa;
    HeaderDeviceInfo.getIDFA();
    options.headers.addAll(HeaderDeviceInfo.json);

    // log("begin request========= ${options.uri}");
    super.onRequest(options, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   super.onResponse(response, handler);

  // }
}
