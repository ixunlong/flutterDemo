import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_qiyu/flutter_qiyu.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/util/tip_resources.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'dart:io';

extension StringEx2 on String {
  String get https => this.startsWith("http://")
      ? this.replaceFirst("http://", "https://")
      : this;
}

class OnlineContact {
  static const appKey = "70dce1cecf8c5cebb6bbb0d48a5d7254";
  static final instance = OnlineContact();

  String? _lastUserId = null;
  bool _isLogin = false;
  int _unreadCount = 0;
  bool _uinfobusy = false;
  // bool _inChatWindow = false;

  bool get isLogin => _isLogin;
  int get unreadCount => _unreadCount;
  String? get lastUserId => _lastUserId;
  bool inChatWindow = false;

  void Function()? onUnreadChange;

  unreadCountChange(int count) {
    if (_unreadCount == count) {
      return;
    }
    _unreadCount = count;
    onUnreadChange?.call();
  }

  init() async {
    // final b = await QiYu.registerApp(appKey: appKey, appName: "qxb_kefu");
    // log("qiyu regist $b");
    // QiYu.registerListener(unreadCountChange);
    // QiYu.setCustomUIConfig({
    //   "serviceHeadImage":"images/weibo.png"
    // });
    // TipResources.next(() {
    // var url = (TipResources.onlineAvatarLeft?.imgUrl ?? "").https;
    // QiYu.setServiceHeadImageUrl(url);
    // });
  }

  setUserinfo() async {
    final userid = User.auth?.userId;
    log("set user info $userid $_lastUserId $_isLogin $_uinfobusy");
    if (_isLogin) {
      if (_lastUserId == userid) {
        return;
      }
    }
    if (_uinfobusy) {
      return;
    }
    _uinfobusy = true;
    try {
      final cond1 = (!_isLogin && _lastUserId == null);
      final cond2 = _isLogin;
      if (cond1 || cond2) {
        // QiYu.logout();
        // QiYu.cleanCache();
        // await Future.delayed(Duration(milliseconds: 100));
        // log("set user logout $userid $_lastUserId $_isLogin $_uinfobusy");
      }
      final data = '''
            [{"key":"real_name", "value":"${User.info?.name}"},
            {"key":"mobile_phone", "hidden":true, "value":"${User.info?.phone}"},
            {"key":"email", "value":""},
            {"index":0, "key":"uuid", "label":"uuid", "value":"${HeaderDeviceInfo.uuid}", "href":""},
            {"index":1, "key":"account", "label":"账号", "value":"${User.auth?.userId}", "href":""},
            {"index":2, "key":"model", "label":"手机", "value":"${HeaderDeviceInfo.model}"},
            {"index":5, "key":"reg_date", "label":"注册日期", "value":""},
            {"index":6, "key":"last_login", "label":"上次登录时间", "value":""}]
            ''';
      // QYUserInfoParams userInfoParams =
      // QYUserInfoParams.fromJson({'userId': '${userid}', 'data': data});
      // _isLogin = await QiYu.setUserInfo(userInfoParams);
      // await QiYu.setCustomerHeadImageUrl((User.info?.avatar ?? "").https);
      // log("QiYu set avaer = ${User.info?.avatar}");
      if (_isLogin) {
        _lastUserId = userid;
      }
      log("set user after $userid $_lastUserId $_isLogin");
    } catch (err) {
      log("set user info err $err");
    }
    _uinfobusy = false;
  }

  openServiceWindow() async {
    await setUserinfo();
    // QYServiceWindowParams serviceWindowParams = QYServiceWindowParams.fromJson({
    // 'source': {'sourceTitle': '', 'sourceUrl': '', 'sourceCustomInfo': ''},

    // 'commodityInfo': {
    //   'commodityInfoTitle': 'Flutter商品',
    //   'commodityInfoDesc': '这是来自网易七鱼Flutter的商品描述',
    //   'pictureUrl':
    //       'http://qiyukf.com/res/img/companyLogo/blmn.png',
    //   'commodityInfoUrl': 'http://www.qiyukf.com',
    //   'note': '￥1000',
    //   'show': true
    // },

    //   'sessionTitle': '红球会客服',
    //   'groupId': 0,
    //   'staffId': 0,
    //   'robotId': 0,
    //   'robotFirst': false,
    //   'faqTemplateId': 0,
    //   'vipLevel': 0,
    //   'showQuitQueue': true,
    //   'showCloseSessionEntry': true
    // });

    // await QiYu.openServiceWindow(serviceWindowParams);
  }
}
