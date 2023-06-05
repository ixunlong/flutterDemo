import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/logic/service/resource_service.dart';
import 'package:sports/model/auth_entity.dart';
import 'package:sports/model/config_entity.dart';
import 'package:sports/model/user_info_entity.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/tip_resources.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/util/web_socket_connection.dart';

class FollowMatch {
  FollowMatch({required this.id, required this.time});
  final int id;
  final DateTime time;
}

class MatchFocusItem {
  MatchFocusItem(this.type);
  final int type;
  List<int> _list = [];

  bool isFocus(int id) => _list.indexWhere((element) => element == id) != -1;

  Future refreshFocusList() async {
    _list = [];
    try {
      final r = await Api.getMatchFocusList(type: type);
      final l = r.data['d']['list'] as List;
      _list = l.map((e) => e as int).toList();
    } catch (err) {}
  }

  Future<bool> focus(int id) async {
    if (isFocus(id)) {
      return true;
    }
    if (await Api.makeMatchFocusUpdate([id], true, type: type)) {
      _list.add(id);
      return true;
    }
    return false;
  }

  Future<bool> unFocus(int id) async {
    if (!isFocus(id)) {
      return true;
    }
    if (await Api.makeMatchFocusUpdate([id], false, type: type)) {
      _list.removeWhere((element) => element == id);
      return true;
    }
    return false;
  }

  clear() {
    _list = [];
  }
}

class User {
  static AuthEntity? get auth => SpUtils.loginAuth;

  static UserInfoEntity? info;

  static bool get isLogin => auth != null;

  static bool _isStateInlogin = false;

  static String get nickname => "nickname";
  static String get phone => "phone";
  static DateTime get loginTime => DateTime.now();

  static bool get isPersonVerified => info?.realName != null && info?.cardId != null;

  static doLogout() async {
    // if (User.auth != null) {
    //   try {
    //     await Api.logout();
    //   } catch (e) {}
    // }
    SpUtils.loginAuth = null;
    info = null;
    _fml = [];
    soccerFocuses.clear();
    basketballFocuses.clear();
    Get.find<ConfigService>().logout();
    Get.find<ResourceService>().inviteTip = null;
  }

  static Future<bool> cancelAccount() async {
    final result = await Api.cancelAccount();
    if (result == 200) {
      SpUtils.loginAuth = null;
      info = null;
      _fml = [];
      return true;
    }
    return false;
  }

  static doLogin() async => await needLogin(() async => null);

  static Future<dynamic> _doFetchUserInfo() async {
    try {
      final userInfo = await Api.getUserInfo();
      info = userInfo;
    } catch (e) {}
  }

  static Future<dynamic> fetchUserInfos({bool fetchFocus = true}) async {
    WsConnection.reconnect();
    if (!isLogin) {
      return null;
    }
    log('fetchUserInfos');
    Api.syncNewsRead();
    TipGift.checkNewuserGift();
    return await Future.wait([
      _doFetchUserInfo(),
      if (fetchFocus) doFetchFocus(),
      if (fetchFocus) basketballFocuses.refreshFocusList()
    ]);
  }

  static FutureOr<T?> needLogin<T>(FutureOr<T> Function() success,
      {FutureOr<T> Function()? fail}) async {
    if (isLogin) {
      return await success.call();
    }
    if (_isStateInlogin) {
      return null;
    }
    _isStateInlogin = true;
    await Get.toNamed(Routes.login);
    _isStateInlogin = false;
    if (isLogin) {
      success.call();
    } else {
      return await fail?.call();
    }
    return null;
  }

  static Future visitorLogin() async {
    final result = await Api.visitorLogin(HeaderDeviceInfo.uuid);
    if (result != null) {
      ToastUtils.show('游客登录成功');
      SpUtils.loginAuth = result;
      await fetchUserInfos();
    }
    return;
  }

  //专家关注列表逻辑

  //比赛关注列表逻辑

  static final basketballFocuses = MatchFocusItem(2);
  static final soccerFocuses = MatchFocusItem(1);

  static List<FollowMatch> _fml = [];
  static Future<dynamic> doFetchFocus() async {
    try {
      final r = await Api.getMatchFocusList();
      final l = r.data['d']['list'] as List;
      final fml = l.map((e) => FollowMatch(id: e, time: DateTime.now()));
      _fml = fml.toList();
      _followSC.add(List.from(_fml));
    } catch (e) {}
  }

  static final _followSC = StreamController.broadcast();
  static Stream get followStream => _followSC.stream;

  static bool isFollow(int id) =>
      _fml.indexWhere((element) => element.id == id) != -1;

  static Future follow(int id) async => await User.needLogin(() async {
        if (!isFollow(id)) {
          final item = FollowMatch(id: id, time: DateTime.now());
          _fml.insert(0, item);
          final r = await Api.makeMatchFocusUpdate([id], true);
          if (r) {
            _followSC.add(List.from(_fml));
          } else {
            _fml.removeWhere((element) => element.time == item.time);
          }
        }
      });

  static Future unFollow(int id) async => await User.needLogin(() async {
        if (isFollow(id)) {
          final idx = _fml.indexWhere((element) => element.id == id);
          final item = _fml.removeAt(idx);
          // _fml.removeWhere((element) => element.id == id);
          final r = await Api.makeMatchFocusUpdate([id], false);
          if (r) {
            _followSC.add(List.from(_fml));
          } else {
            _fml.add(item);
          }
        }
      });

  static Future<bool?> nameUpdate(String name) async =>
      await needLogin(() async {
        final r = await Api.nameUpdate(name) ?? false;
        if (r) {
          info?.name = name;
        }
        return r;
      });
}
