import 'package:flutter/services.dart';

class MethodChannelUtils {
  static const MethodChannel _channel = MethodChannel('qxb_method_channel');

  /// ios用
  static showHud() {
    _channel.invokeMethod('showHud');
  }

  static dismissHud() {
    _channel.invokeMethod('dismissHud');
  }

  static showHudWithStatus(String msg) {
    _channel.invokeMethod('showHudWithStatus', msg);
  }

  /// android用
  static Future<String?> getAndroidChannel() async {
    return await _channel.invokeMethod<String?>('getAndroidChannel');
  }
}
