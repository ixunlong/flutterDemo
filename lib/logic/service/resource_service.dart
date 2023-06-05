import 'dart:developer';

import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/utils.dart';

class ResourceService extends GetxService {
  List<LbtEntity>? _expertContact;
  List<LbtEntity>? _appLaunch;
  List<LbtEntity>? navigationTheme;

  List<LbtEntity>? appStart;
  //导航栏初始index
  LbtEntity? navigationIndex;
  //邀请好友提示语
  LbtEntity? inviteTip;
  //邀请好友配置
  LbtEntity? inviteInfo;
  //专家申请顶部引导
  LbtEntity? expertApplyBanner;
  //进入h5
  LbtEntity? starth5;
  Future<ResourceService> init() async {
    getExpertContact();
    // getAppLaunch();
    return this;
  }

  //专家客服
  Future getExpertContact() async {
    _expertContact =
        SpUtils.expertContact?.map((e) => LbtEntity.fromJson(e)).toList();
    final expert = await Api.getAppList("app_expert_contact");
    if (expert != null) {
      _expertContact = expert;
      SpUtils.expertContact = expert.map((e) => e.toJson()).toList();
    }
  }

  //启动页
  Future getAppLaunch() async {
    // _appLaunch = SpUtils.appLaunch?.map((e) => LbtEntity.fromJson(e)).toList();
    try {
      final reslut = await Api.getAppList("app_launch", receiveTimeout: 2000);
      if (reslut != null) {
        _appLaunch = reslut;
        SpUtils.appLaunch = reslut.map((e) => e.toJson()).toList();
      }
    } catch (e) {}
  }

  //导航栏主题
  Future getNavigationTheme() async {
    // _appLaunch = SpUtils.appLaunch?.map((e) => LbtEntity.fromJson(e)).toList();
    try {
      final reslut =
          await Api.getAppList("app_navigation_bar", receiveTimeout: 2000);
      if (reslut != null) {
        navigationTheme = reslut;
        // SpUtils.appLaunch = reslut.map((e) => e.toJson()).toList();
      }
    } catch (e) {}
  }

  //启动配置
  Future getAppStart() async {
    // _appLaunch = SpUtils.appLaunch?.map((e) => LbtEntity.fromJson(e)).toList();
    log('${HeaderDeviceInfo.descrption}');
    try {
      final reslut = await Api.getAppList("app_start", receiveTimeout: 2000);
      if (reslut != null) {
        appStart = reslut;
        for (LbtEntity entity in reslut) {
          if (entity.title == 'initial_navigation_index') {
            navigationIndex = entity;
          }
          if (entity.title == 'invite_info') {
            inviteInfo = entity;
          }
          if (entity.title == 'expert_apply_banner') {
            expertApplyBanner = entity;
          }
          if (entity.button == 'start_h5') {
            starth5 = entity;
          }
        }
      }
    } catch (e) {}
  }

  //启动配置
  Future getAppLogin() async {
    try {
      final reslut = await Api.getAppList("app_login", receiveTimeout: 2000);
      if (reslut != null) {
        bool hasInviteTip = false;
        for (LbtEntity entity in reslut) {
          if (entity.title == 'invite_tip') {
            inviteTip = entity;
            hasInviteTip = true;
          }
        }
        if (hasInviteTip == false) {
          inviteTip = null;
        }
      }
    } catch (e) {}
  }

  LbtEntity? get expertContact {
    if (_expertContact == null || _expertContact!.isEmpty) {
      return null;
    } else {
      return _expertContact?.first;
    }
  }

  LbtEntity? get appLaunch {
    if (_appLaunch == null || _appLaunch?.length == 0) {
      return null;
    } else {
      return _appLaunch?.first;
    }
  }

  List<LbtEntity>? get webgames =>
      appStart?.filterOrNull((item) => item.title == "web-game-entry");
}
