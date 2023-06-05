import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static _configEasyloading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Color(0xff4c4c4c)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.white.withOpacity(0.0)
      ..dismissOnTap = false;
  }

  static show(String msg) {
    _configEasyloading();
    EasyLoading.showToast(msg,
        toastPosition: EasyLoadingToastPosition.center,
        maskType: EasyLoadingMaskType.custom);
  }

  static showDismiss(String msg, [int? seconds]) {
    _configEasyloading();
    EasyLoading.showToast(msg,
        toastPosition: EasyLoadingToastPosition.center,
        maskType: EasyLoadingMaskType.custom,
        dismissOnTap: true,
        duration: seconds == null ? null : Duration(seconds: seconds));
  }
}
