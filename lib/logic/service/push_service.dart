import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aliyun_push/aliyun_push.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sports/http/api.dart';
// import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/app_config.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';

class PushService extends GetxService {
  // JPush? jpush;
  // Stream<Map<String, dynamic>>
  final _dataStream = StreamController<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get dataStream => _dataStream.stream;
  AliyunPush? push;
  Future<PushService> init() async {
    return this;
  }

  initPush() async {
    if (SpUtils.requestNotification == null && Platform.isAndroid) {
      await Permission.notification.request();
      SpUtils.requestNotification = true;
    }
    push = AliyunPush();
    if (Platform.isIOS) {
      push!
          .initPush(
              appKey: '333825456',
              appSecret: 'd049312963d3414c82ff7b2cb91beec2')
          .then((value) {
        log('$value');
        getDeviceId();
      });
      // log('$a');
    } else {
      // push!.setAndroidLogLevel(2);
      bool debug = AppConfig.config.isDebug;
      push!.createAndroidChannel(
          debug ? 'dev' : 'release', debug ? '测试通道' : '常规推送', 3, '比赛、关注专家等通知');
      await push!.initPush();
      await push!.initAndroidThirdPush();
      getDeviceId();
      // log('2');
      // push!.addAlias('chiluo');
    }
    push!.addMessageReceiver(
      onNotification: (message) async {
        log('onNotification $message');
      },
      onMessage: (message) async {
        log('onMessage $message');
      },
      onNotificationOpened: (message) async {
        log('$message');
        try {
          Map<String, dynamic> data;
          if (Platform.isIOS) {
            data = Map<String, dynamic>.from(message);
          } else {
            // final extra = message['extraMap'];
            // final dataString = message['extraMap'];
            final dataString = message['extraMap'];
            data = jsonDecode(dataString);
            // data = message['extraMap'];
            // handleNotification(data);
          }
          // handleNotification(data);
          if (_dataStream.hasListener) {
            _dataStream.add(data);
          } else {
            handleNotification(data);
          }
        } catch (e) {
          log('push==============$e');
        }
      },
    );
    // final deviceId = await push!.getDeviceId();

    // push!.getDeviceId().then((value) {
    //   log('$value');
    // }, onError: (e) {
    //   log('$e');
    // });
  }

  void getDeviceId() async {
    try {
      final deviceId = await push!.getDeviceId();
      HeaderDeviceInfo.pushId = deviceId;
      HeaderDeviceInfo.describe();
      Api.getAppList("app_start", receiveTimeout: 1500);
    } catch (e) {
      log('$e');
    }
  }

  // initJpush() async {
  //   jpush = JPush();
  //   try {
  //     jpush!.addEventHandler(
  //         // 接收通知回调方法。
  //         onReceiveNotification: (Map<String, dynamic> message) async {
  //       log('$message');
  //     },
  //         // 点击通知回调方法。
  //         onOpenNotification: (Map<String, dynamic> message) async {
  //       try {
  //         Map<String, dynamic> data;
  //         if (Platform.isIOS) {
  //           data = Map<String, dynamic>.from(message['extras']);
  //         } else {
  //           final extra = message['extras'];
  //           final dataString = extra['cn.jpush.android.EXTRA'];
  //           data = jsonDecode(dataS
  //         log('push==============$e');
  //       }

  //       log('$message');tring);
  //           // handleNotification(data);
  //         }
  //         // handleNotification(data);
  //         if (_dataStream.hasListener) {
  //           _dataStream.add(data);
  //         } else {
  //           handleNotification(data);
  //         }
  //       } catch (e) {
  //     },
  //         // 接收自定义消息回调方法。
  //         onReceiveMessage: (Map<String, dynamic> message) async {
  //       log('$message');
  //     });
  //   } on PlatformException {}
  //   jpush!.setup(
  //     appKey: '9b221e8c46238cba451a06c6',
  //     channel: Platform.isIOS ? 'iOS' : 'Android',
  //     production: AppConfig.config.isDebug ? false : true,
  //     debug: AppConfig.config.isDebug ? true : false,
  //   );
  //   jpush!.setAuth();
  //   jpush!.applyPushAuthority(
  //       NotificationSettingsIOS(sound: true, alert: true, badge: true));
  //   jpush!.getRegistrationID().then((rid) {
  //     log("flutter get registration id : $rid");
  //     jpush!.setAlias(HeaderDeviceInfo.uuid);
  //   });
  // }

  handleNotification(Map<String, dynamic> data) {
    String? path = data['path'];
    if (RegExp("^http[s]?://").hasMatch(path!)) {
      Get.toNamed(Routes.webview,
          arguments: {"url": path}, preventDuplicates: false);
    } else {
      String arguments = data['arguments'];
      if (path == Routes.webview) {
        Get.toNamed(Routes.webview,
            arguments: {"url": arguments}, preventDuplicates: false);
      } else {
        final intArgument = arguments.toInt();
        if (intArgument == null) {
          Get.toNamed(path, arguments: arguments, preventDuplicates: false);
        } else {
          Get.toNamed(path, arguments: intArgument, preventDuplicates: false);
        }
      }
    }
  }
}
