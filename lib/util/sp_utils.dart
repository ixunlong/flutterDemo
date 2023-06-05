import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/app_update_entity.dart';
import 'package:sports/model/auth_entity.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/app_config.dart';
import 'package:sports/util/user.dart';
import 'package:uuid/uuid.dart';

typedef Json = Map<String, dynamic>;

class SpUtils {
  static late SharedPreferences sp;

  static const localReadHistoryKey = "localReadHistory";
  static const _homeDataKey = "homeData";
  static const _loginAuthKey = "loginAuth";
  static const _updateInfoKey = "appUpdateInfoKey";
  static const _agreePrivacyKey = "agreePrivacy";
  static const _baseUrlKey = "baseUrl";
  static const _matchAllFilterDataKey = "matchAllFilterData";
  static const _requestNotification = "requestNotification";
  //一级 热门比赛
  static const _matchOneLevelKey = "matchOneLevelKey";
  static const _basketOneLevelKey = "basketOneLevelKey";
  static const _appUuid = "appUuid";
  static const _appContactKey = "appContact";
  static const _appTipsKey = "appTips";
  static const _expertContactKey = "expertContact";
  static const _localSettingsKey = "localSettings";
  static const _appLaunchKey = "appLaunch";
  static const _gift4NewuserKey = "gift4newuser";
  static const _showFocusTeamKey = "showFocusTeam";
  //设置
  static const _soccerConfigKey = "soccerConfig";
  static const _basketConfigKey = "basketConfig";
  static const _pushConfigKey = "pushConfig";
  static const _configTimeKey = "configTime";
  static const _notifySetted = "notifySetted";
  static const _lbtDialogIds = "lbtDialogIds";

  static initSp() async {
    sp = await SharedPreferences.getInstance();
  }

  static bool? get agreePrivacy {
    return sp.getBool(_agreePrivacyKey);
  }

  static set agreePrivacy(bool? value) {
    sp.setBool(_agreePrivacyKey, value ?? false);
  }

  static bool? get showFocusTeam {
    return sp.getBool(_showFocusTeamKey + (User.auth?.userId ?? ''));
  }

  static set showFocusTeam(bool? value) {
    sp.setBool(_showFocusTeamKey + (User.auth?.userId ?? ''), value ?? false);
  }

  static bool setJson(String key, Map<String, dynamic>? json) {
    try {
      if (json == null) {
        sp.remove(key);
      } else {
        final str = jsonEncode(json);
        sp.setString(key, str);
      }
      return true;
    } catch (err) {
      log("set json data err $err");
      return false;
    }
  }

  static Map<String, dynamic>? getJson(String key) {
    try {
      final str = sp.getString(key)!;
      return jsonDecode(str);
    } catch (err) {
      log("get json err $err");
    }
  }

  static Map<String, dynamic>? get homeData => getJson(_homeDataKey);
  static set homeData(Map<String, dynamic>? json) =>
      setJson(_homeDataKey, json);

  static Map<String, dynamic>? get matchAllFilterData =>
      getJson(_matchAllFilterDataKey);
  static set matchAllFilterData(Map<String, dynamic>? json) =>
      setJson(_matchAllFilterDataKey, json);

  static Map<String, dynamic>? get matchOneLevelKey =>
      getJson(_matchOneLevelKey);
  static set matchOneLevelKey(Map<String, dynamic>? json) =>
      setJson(_matchOneLevelKey, json);

  static Map<String, dynamic>? get basketOneLevelKey =>
      getJson(_basketOneLevelKey);
  static set basketOneLevelKey(Map<String, dynamic>? json) =>
      setJson(_basketOneLevelKey, json);

  static AuthEntity? _loginAuth;
  static AuthEntity? get loginAuth {
    if (_loginAuth != null) {
      return _loginAuth;
    }
    final str = sp.getString(_loginAuthKey);
    try {
      final json = jsonDecode(str ?? "");
      final auth = AuthEntity.fromJson(json);
      _loginAuth = auth;
      return auth;
    } catch (err) {
      log("sp utils get login err ${err}");
      return null;
    }
  }

  static set loginAuth(AuthEntity? en) {
    try {
      _loginAuth = en;
      final json = en?.toJson();
      final str = jsonEncode(json);
      sp.setString(_loginAuthKey, str);
    } catch (err) {
      if (en == null) {
        sp.remove(_loginAuthKey);
      }
      log("set login auth err ${err}");
    }
  }

  static AppUpdateEntity? get appUpdateInfo {
    final infostr = sp.getString(_updateInfoKey);
    if (infostr == null) {
      return null;
    }
    try {
      final json = jsonDecode(infostr);
      return AppUpdateEntity.fromJson(json);
    } catch (err) {
      log("get app update info err $err");
      return null;
    }
  }

  static set appUpdateInfo(AppUpdateEntity? info) {
    if (info == null) {
      sp.remove(_updateInfoKey);
      return;
    }
    try {
      final str = jsonEncode(info.toJson());
      sp.setString(_updateInfoKey, str);
    } catch (err) {
      log("set app update info err $err");
    }
  }

  static String get baseUrl =>
      sp.getString(_baseUrlKey) ??
      (kDebugMode ? Constant.devBaseUrl : Constant.prodBaseUrl);
  static set baseUrl(String v) =>
      v.isEmpty ? sp.remove(_baseUrlKey) : sp.setString(_baseUrlKey, v);

  static String get appUuid =>
      sp.getString(_appUuid) ??
      () {
        final uuid = const Uuid().v1();
        sp.setString(_appUuid, uuid);
        return uuid;
      }.call();

  static Json? get appContact => getJson(_appContactKey);
  static set appContact(Json? value) => setJson(_appContactKey, value);

  static List? get appTips => getJson(_appTipsKey)?['list'];
  static set appTips(List? l) => setJson(_appTipsKey, {"list": l});

  static List? get expertContact => getJson(_expertContactKey)?['list'];
  static set expertContact(List? list) =>
      setJson(_expertContactKey, {"list": list});

  static Json get localSettings => getJson(_localSettingsKey) ?? {};
  static set localSettings(Json json) => setJson(_localSettingsKey, json);

  static List? get appLaunch => getJson(_appLaunchKey)?['list'];
  static set appLaunch(List? list) => setJson(_appLaunchKey, {"list": list});

  static Json get gift4newuser => getJson(_gift4NewuserKey) ?? {};
  static set gift4newuser(Json json) => setJson(_gift4NewuserKey, json);

  static SoccerConfig? get soccerConfig {
    final infostr = sp.getString(_soccerConfigKey);
    if (infostr == null) {
      return null;
    }
    try {
      Map<String, dynamic> json = jsonDecode(infostr);
      Map<int, String> intJson = Map<int, String>();
      for (var key in json.keys) {
        intJson[int.parse(key)] = json[key] ?? '';
      }
      return SoccerConfig.fromJson(intJson);
    } catch (err) {
      return null;
    }
  }

  static set soccerConfig(SoccerConfig? info) {
    if (info == null) {
      sp.remove(_soccerConfigKey);
      return;
    }
    try {
      final str = jsonEncode(info.toStringJson());
      sp.setString(_soccerConfigKey, str);
    } catch (err) {
      log('sp utils err');
    }
  }

  static BasketConfig? get basketConfig {
    final data = sp.getString(_basketConfigKey);
    if (data == null) {
      return null;
    }
    try {
      final json = jsonDecode(data);
      Map<int, String> intJson = Map<int, String>();
      for (var key in json.keys) {
        intJson[int.parse(key)] = json[key] ?? '';
      }
      return BasketConfig.fromJson(intJson);
    } catch (err) {
      return null;
    }
  }

  static set basketConfig(BasketConfig? data) {
    if (data == null) {
      sp.remove(_basketConfigKey);
      return;
    }
    try {
      final str = jsonEncode(data.toStringJson());
      sp.setString(_basketConfigKey, str);
    } catch (err) {}
  }

  static PushConfig? get pushConfig {
    final data = sp.getString(_pushConfigKey);
    if (data == null) {
      return null;
    }
    try {
      final json = jsonDecode(data);
      Map<int, String> intJson = Map<int, String>();
      for (var key in json.keys) {
        intJson[int.parse(key)] = json[key] ?? '';
      }
      return PushConfig.fromJson(intJson);
    } catch (err) {
      return null;
    }
  }

  static set pushConfig(PushConfig? data) {
    if (data == null) {
      sp.remove(_pushConfigKey);
      return;
    }
    try {
      final str = jsonEncode(data.toStringJson());

      sp.setString(_pushConfigKey, str);
    } catch (err) {}
  }

  static int? get configTime {
    return sp.getInt(_configTimeKey);
  }

  static set configTime(int? value) {
    sp.setInt(_configTimeKey, value ?? 0);
  }

  static bool get notifySetted => sp.getBool(_notifySetted) ?? false;
  static set notifySetted(bool v) => sp.setBool(_notifySetted, v);

  static List<String> get lbtDialogIds => sp.getStringList(_lbtDialogIds) ?? [];
  static set lbtDialogIds(List<String>? n) {
    if (n == null) {
      sp.remove(_lbtDialogIds);
    } else {
      sp.setStringList(_lbtDialogIds, n);
    }
  }

  static bool? get requestNotification {
    return sp.getBool(_requestNotification);
  }

  static set requestNotification(bool? value) {
    sp.setBool(_requestNotification, value ?? true);
  }
}
