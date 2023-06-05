import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sports/http/apis/couponapi.dart';
import 'package:sports/http/dio_utils.dart';
import 'package:sports/http/request_interceptor.dart';
import 'package:sports/model/app_update_entity.dart';
import 'package:sports/model/auth_entity.dart';
import 'package:sports/model/basketball/bb_info_entity.dart';
import 'package:sports/model/basketball/bb_lineup_entity.dart';
import 'package:sports/model/config_entity.dart';
import 'package:sports/model/data/basket/basket_points_entity.dart';
import 'package:sports/model/data/basket/basket_schedule_entity.dart';
import 'package:sports/model/data/data_cup_points_entity.dart';
import 'package:sports/model/data/data_rank_entity.dart';
import 'package:sports/model/data/league_list_entity.dart';
import 'package:sports/model/data_transfer_entity.dart';
import 'package:sports/model/expert/expert_search_entity.dart';
import 'package:sports/model/expert/expert_top_entity.dart';
import 'package:sports/model/expert/expert_views_entity.dart';
import 'package:sports/model/home/home_news_entity.dart';
import 'package:sports/model/home/index_class_entity.dart';
import 'package:sports/model/home/lbt_entiry.dart';
import 'package:sports/model/match/basket_list_entity.dart';
import 'package:sports/model/match/basket_match_data_entity.dart';
import 'package:sports/model/match/basket_match_data_team_entity.dart';
import 'package:sports/model/match/basket_match_data_temavg_entity.dart';
import 'package:sports/model/match/bb_match_data_compare_entity.dart';
import 'package:sports/model/match/match_data_entity.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/model/match/match_odds_ok_entity.dart';
import 'package:sports/model/match/match_point_entity.dart';
import 'package:sports/model/match/match_video_entity.dart';
import 'package:sports/model/match/soccer_odds_entity.dart';
import 'package:sports/model/mine/coin_history_entity.dart';
import 'package:sports/model/mine/order_entity.dart';
import 'package:sports/model/odds_company_entity.dart';
import 'package:sports/model/recharge_entity.dart';
import 'package:sports/model/team/basket_team_detail_entity.dart';
import 'package:sports/model/team/bb_team/bb_team_count_entity.dart';
import 'package:sports/model/team/bb_team/bb_team_data_year_entity.dart';
import 'package:sports/model/team/bb_team/bb_team_player_entity.dart';
import 'package:sports/model/team/focus_team_list_entity.dart';
import 'package:sports/model/team/my_team_focus_entity.dart';
import 'package:sports/model/team/team_lineup_entity.dart';
import 'package:sports/model/team/team_schedule_entity.dart';
import 'package:sports/model/third_auth_entity.dart';
import 'package:sports/model/user_info_entity.dart';
import 'package:sports/util/local_read_history.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/toast_utils.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';

import '../model/data/basket/basket_season_entity.dart';
import '../model/data/data_points_entity.dart';
import '../model/data/data_schedule_entity.dart';
import '../model/data/data_type_entity.dart';
import '../model/data/league_channel_entity.dart';
import '../model/expert/expert_apply_entity.dart';
import '../model/expert/expert_detail_entity.dart';
import '../model/expert/expert_focus_entity.dart';
import '../model/expert/expert_idea_entity.dart';
import '../model/expert/expert_idea_list_entity.dart';
import '../model/expert/plan_Info_entity.dart';
import '../model/match/match_intelligence_entity.dart';
import '../model/match/soccer_data_entity.dart';
import '../model/match/soccer_lineup_entity.dart';
import '../model/mine/coin_detail_entity.dart';
import '../model/mine/order_list_entity.dart';
import '../model/team/bb_team/bb_team_schedule_entity.dart';
import '../model/team/team_detail_entity.dart';

class Api {
  ///发送验证码
  static Future<int?> sendSmsCode(String phone, int code) async {
    final data = {'code': code, 'phone': phone};
    final result =
        await DioUtils.post('/resource/rse-sms-do/sendCode', params: data);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  static Future<int?> kaptchaValidate(String code, String key) async {
    final data = {'key': key, 'code': code};
    final result =
        await DioUtils.post('/resource/app-do/kaptchaValidate', params: data);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  ///登录
  //accessCode 二次登陆用
  //channel 渠道
  //version 版本号
  //token 一键登录token
  static Future<AuthEntity?> login(
      {String? phone,
      String? smsCode,
      String? accessCode,
      String? channel,
      String? version,
      String? token}) async {
    final data = {
      'phone': phone,
      'smsCode': smsCode ?? '',
      'accessCode': accessCode ?? '',
      'channel': channel ?? '',
      'version': version ?? '',
      'tokenCode': token ?? ''
    };
    final result = await DioUtils.post('/user/usr-do/login', params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return AuthEntity.fromJson(result.data['d']);
    }
    return null;
  }

  ///游客登录
  static Future<AuthEntity?> visitorLogin(String uuid) async {
    final data = {
      'uuid': uuid,
    };
    final result =
        await DioUtils.post('/user/usr-do/visitorLogin', params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return AuthEntity.fromJson(result.data['d']);
    }
    return null;
  }

  ///三方登录
  static Future<AuthEntity?> thirdLogin(
      {String? qqAccessToken,
      String? qqOpenid,
      String? wbAccessToken,
      String? wbUid,
      String? iosIdentityToken,
      String? wxCode}) async {
    final data = {
      'qqAccessToken': qqAccessToken,
      'qqOpenid': qqOpenid,
      'wbAccessToken': wbAccessToken,
      'wbUid': wbUid,
      'iosIdentityToken': iosIdentityToken,
      'wxCode': wxCode,
    };
    final result = await DioUtils.post('/user/app-auth/authLogin',
        params: data, showLoading: true);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return AuthEntity.fromJson(result.data['d']);
    }
    return null;
  }

  ///三方绑定
  static Future<int?> thirdBind(
      {String? qqAccessToken,
      String? qqOpenid,
      String? wbAccessToken,
      String? wbUid,
      String? iosIdentityToken,
      String? wxCode}) async {
    final data = {
      'qqAccessToken': qqAccessToken,
      'qqOpenid': qqOpenid,
      'wbAccessToken': wbAccessToken,
      'wbUid': wbUid,
      'iosIdentityToken': iosIdentityToken,
      'wxCode': wxCode,
    };
    final result = await DioUtils.post('/user/app-auth/authBind',
        params: data, showLoading: true);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  ///三方解绑
  static Future<int?> thirdUnbind(int type) async {
    final result = await DioUtils.post('/user/app-auth/authUnBind',
        params: type, showLoading: true);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  ///获取绑定信息
  static Future<List<ThirdAuthEntity>?> getAuthList() async {
    final result =
        await DioUtils.post('/user/app-auth/authList', showLoading: true);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return result.data['d']
          .map<ThirdAuthEntity>((e) => ThirdAuthEntity.fromJson(e))
          .toList();
    }
    return null;
  }

  ///绑定手机
  static Future<AuthEntity?> bindPhone(
      {String? phone,
      String? userId,
      String? smsCode,
      String? tokenCode}) async {
    final data = {
      'phone': phone,
      'smsCode': smsCode ?? '',
      'userId': userId ?? '',
      'tokenCode': tokenCode ?? ''
    };
    final result = await DioUtils.post('/user/usr-do/bindPhone', params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return AuthEntity.fromJson(result.data['d']);
    }
    return null;
  }

  ///刷新登录凭证
  //accessCode 二次登陆用
  //channel 渠道
  //version 版本号
  static Future<AuthEntity?> refreshLogin() async {
    final auth = SpUtils.loginAuth!;
    // if (auth == null) {
    //   return null;
    // }
    final r = await login(phone: auth.phone ?? "", accessCode: auth.accessCode);
    if (r == null) {
      return null;
    }
    auth.token = r.token;
    SpUtils.loginAuth = auth;
    return auth;
  }

  ///账户注销
  static Future<int?> cancelAccount() async {
    final result = await DioUtils.post('/user/usr-do/cancel');
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  ///用户配置查询
  static Future<List<ConfigEntity>?> getConfigList(List<int> typeList) async {
    final data = {'typeList': typeList, 'userId': User.auth?.userId};
    final result = await DioUtils.post('/user/usr-do/configList', params: data);
    // log("get config list $result");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return result.data['d']
          .map<ConfigEntity>((e) => ConfigEntity.fromJson(e))
          .toList();
    }
    return null;
  }

  ///修改头像
  static Future<int?> avatarUpdate(String avatar,
      {bool showLoading = false}) async {
    final data = {'avatar': avatar, 'userId': User.auth?.userId};
    final result = await DioUtils.post('/user/usr-do/avatarUpdate',
        params: data, showLoading: showLoading);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  ///用户配置更新
  static Future<int?> setConfigList(
      List<ConfigEntity> config, String userId, int userType) async {
    final dataList = config
        .map(
            (e) => {'config': e.config, 'type': e.type, 'typeName': e.typeName})
        .toList();
    final data = {'list': dataList, 'userId': userId, 'userType': userType};
    final result =
        await DioUtils.post('/user/usr-do/configUpdate', params: data);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  static Future<List<LbtEntity>?> getAppList(String id,
      {int? receiveTimeout}) async {
    final data = {"id": id};
    final result = await DioUtils.post("/resource/app-do/list",
        params: data, receiveTimeout: receiveTimeout);
    if (result.statusCode == 200 && result.data["c"] == 200) {
      return (result.data["d"] as List)
          .map((e) => LbtEntity.fromJson(e))
          .toList();
    }
    return null;
  }

  static Future<List<IndexClassEntity>?> getClassInfoList() async {
    final result = await DioUtils.post("/info/app-do/class/list");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return (result.data['d'] as List)
          .map((e) => IndexClassEntity.fromJson(e))
          .toList();
    }
    return null;
  }

  static Future<Response> getHomeNews(int id, int page, int size) async {
    return await DioUtils.post("/info/app-do/list", params: {
      "data": {"id": id},
      "page": page,
      "size": size
    });
  }

  static Future<Response> getHotMatches() async {
    return await DioUtils.post("/match/app-fb-do/hotList");
  }

  ///获取全部比赛
  static Future<List<MatchEntity>?> getMatchAllList() async {
    final result = await DioUtils.post("/match/app-fb-do/matchAll");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<MatchEntity> data = result.data['d']
          .map<MatchEntity>((e) => MatchEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///获取进行中比赛
  static Future<List<MatchEntity>?> getMatchBeginList() async {
    final result = await DioUtils.post("/match/app-fb-do/matchIng");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<MatchEntity> data = result.data['d']
          .map<MatchEntity>((e) => MatchEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///获取比赛赛果
  static Future<List<MatchEntity>?> getMatchResultList(String time) async {
    final data = {'id': time};
    final result =
        await DioUtils.post("/match/app-fb-do/matchResult", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<MatchEntity> data = result.data['d']
          .map<MatchEntity>((e) => MatchEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///获取比赛赛程
  static Future<List<MatchEntity>?> getMatchScheduleList(String time) async {
    final data = {'id': time};
    final result =
        await DioUtils.post("/match/app-fb-do/matchSchedule", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<MatchEntity> data = result.data['d']
          .map<MatchEntity>((e) => MatchEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///比赛信息
  static Future<Response> getMatchInfo(int id) async {
    return await DioUtils.post("/match/app-match-do/info", params: id);
  }

  ///热门、一级联赛列表
  static Future<LeagueListEntity?> getLeagueList() async {
    final result = await DioUtils.post("/data/app-do/leagues");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = LeagueListEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///比赛数据
  static Future<MatchDataEntity?> getMatchData(int id) async {
    final result =
        await DioUtils.post("/match/app-match-do/analyseData", params: id);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = MatchDataEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///比赛积分
  static Future<MatchPointEntity?> getMatchPoint(int id) async {
    final result = await DioUtils.post("/data/app-do/standing", params: id);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = MatchPointEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///获取比赛技术统计
  static Future<Response> getMatchTech(int id) async {
    return await DioUtils.post("/match/app-match-do/technic", params: id);
  }

  ///比赛阵容
  static Future<List<SoccerLineupEntity?>?> getMatchLineup(int id) async {
    final result =
        await DioUtils.post("/match/app-match-do/lineup", params: id);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = SoccerLineupEntity.fromJson(result.data['d']);
      final data1 =
          SoccerLineupEntity.fromJson(result.data['d']["prevMessage"]);
      data1.isLastLineup = true;
      return [data1, data];
    }
    return null;
  }

  ///上场比赛阵容
  static Future<SoccerLineupEntity?> getLastMatchLineup(int id) async {
    final result =
        await DioUtils.post("/match/app-match-do/lineup", params: id);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      var data = SoccerLineupEntity.fromJson(result.data['d']["prevMessage"]);
      return data;
    }
    return null;
  }

  ///球员个人数据统计
  static Future<SoccerDataEntity?> getSoccerData(
      int matchId, int playerId) async {
    final result = await DioUtils.post("/match/app-match-do/player/technic",
        params: {"matchId": matchId, "playerId": playerId});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = SoccerDataEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///伤病数据
  static Future<SoccerLineupEntity?> getLineupSuspend(int id) async {
    final result =
        await DioUtils.post("/match/app-match-do/lineup", params: id);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      var data = SoccerLineupEntity.fromJson(result.data['d']["prevMessage"]);
      return data;
    }
    return null;
  }

  ///获取比赛重要事件
  static Future<Response?> getMatchEvent(int id, int flag) async {
    if (flag == 1) {
      final result =
          await DioUtils.post("/match/app-match-do/event", params: id);
      return result;
    } else {
      final result =
          await DioUtils.post("/match/app-match-do/lineup", params: id);
      return result;
    }
  }

  ///获取足球关注列表
  ///type 1 为足球  type 2 为篮球
  static Future<Response> getMatchFocusList({int type = 1}) async {
    return await DioUtils.post("/user/usr-do/matchFocusList",
        params: {"type": type, "userId": User.auth?.userId ?? ""});
  }

  static Future<Response> getBasketballMatchFocusList() =>
      getMatchFocusList(type: 2);

  ///增加或删除足球关注
  static Future<bool> makeMatchFocusUpdate(List<int> ids, bool isFocus,
          {int type = 1}) async =>
      await Utils.tryOrNullf(() async {
        final response =
            await DioUtils.post("/user/usr-do/matchFocusUpdate", params: {
          "type": type,
          "userId": User.auth?.userId ?? "",
          "addOrDel": isFocus ? 1 : 2,
          "list": ids
        });
        return response.data['d'] ?? false;
      }) ??
      false;

  static Future<bool> makeBasketballMatchFocusUpdate(
          List<int> ids, bool isFocus) =>
      makeMatchFocusUpdate(ids, isFocus, type: 2);

  static Future<Response> getMatchTextLive(int id,
      {bool isAll = false, int? liveId}) async {
    return await DioUtils.post("/match/app-match-do/textLive",
        params: {"qxbId": id, "strategy": isAll ? 0 : (liveId ?? 1)});
  }

  static Future<AppUpdateEntity?> checkUpdate(String version) async {
    try {
      final r = await DioUtils.post("/resource/app-do/version", params: {
        "appId": "qxb",
        "channelId": HeaderDeviceInfo.channel,
        "version": version
      });
      return AppUpdateEntity.fromJson(r.data['d']);
    } catch (err) {
      return null;
    }
  }

  ///登出
  static Future<Response> logout() async {
    return await DioUtils.post("/user/usr-do/logout");
  }

  static Future<UserInfoEntity?> getUserInfo() async =>
      await Utils.tryOrNullf(() async {
        final response = await DioUtils.post("/user/usr-do/userInfo",
            params: {"id": SpUtils.loginAuth?.userId ?? ""});
        return UserInfoEntity.fromJson(response.data['d']);
      });

  static Future<bool?> nameUpdate(String name) async =>
      await Utils.tryOrNullf(() async {
        final response = await DioUtils.post("/user/usr-do/nameUpdate",
            params: {"name": name, "userId": User.auth?.userId ?? ''});
        if (response.data['c'] != 200) {
          ToastUtils.show(response.data['m']);
        }
        return response.data['c'] == 200;
      });

  static Future<MatchIntelligenceEntity?> getMatchIntelligence(int id) async {
    final result =
        await DioUtils.post("/match/app-match-do/matchRemark", params: id);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = MatchIntelligenceEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///获取用户关注
  static Future<List<MatchEntity>?> getMatchFocus() async {
    final result = await DioUtils.post("/match/app-fb-do/matchFocus",
        params: {"id": User.auth?.userId ?? ""});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<MatchEntity> data = result.data['d']
          .map<MatchEntity>((e) => MatchEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  @Deprecated("使用 getNews2")
  static Future<HomeNewsEntity?> getNews(int id) async =>
      await Utils.tryOrNullf(() async {
        final result =
            await DioUtils.post("/info/app-do/info", params: {"id": id});
        return HomeNewsEntity.fromJson(result.data['d']);
      });

  static Future<HomeNewsEntity?> getNews2(int id, {int? classId}) async =>
      await Utils.tryOrNullf(() async {
        final result = await DioUtils.post("/info/app-do/news/info",
            params: {"id": id, 'classId': classId});
        return HomeNewsEntity.fromJson(result.data['d']);
      });

  static Future<Response> getNewsRecommendList(int? id, int? cid) =>
      DioUtils.post('/info/app-do/recommendList',
          params: {"id": id, "classId": cid});

  //视频新闻详情
  static Future<HomeNewsEntity?> getVideoNews(int id, int? classId) async =>
      await Utils.tryOrNullf(() async {
        final result = await DioUtils.post("/info/app-do/news/info",
            params: {"id": id, "classId": classId});
        return HomeNewsEntity.fromJson(result.data['d']);
      });

  ///获取充值选项
  static Future<List<RechargeEntity>?> getRechargeList(
      String platformType) async {
    final data = {'platformType': platformType};
    final result =
        await DioUtils.post("/user/usr-do/payItem/rsp", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<RechargeEntity> data = result.data['d']
          .map<RechargeEntity>((e) => RechargeEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  static Future<PlanInfoEntity?> getPlanInfo(int planId) async {
    try {
      final response =
          await DioUtils.post("/plan/app-plan-do/planInfo", params: {
        "expertId": "",
        "expertType": "1",
        "planId": "$planId",
        "userId": "${User.auth?.userId}"
      });
      return PlanInfoEntity.fromJson(response.data['d']);
    } catch (err) {
      log("get plan info err $err");
      return null;
    }
  }

  ///专家推荐
  static Future<List<ExpertTopEntity>?> getExpertTop(int id) async {
    final result =
        await DioUtils.post("/plan/app-expert-do/expertTop", params: id);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<ExpertTopEntity> data = result.data['d']
          .map<ExpertTopEntity>((e) => ExpertTopEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///全部专家
  static Future<ExpertViewsEntity?> getExpertAll(
      int page, int size, int expertType) async {
    final result =
        await DioUtils.post("/plan/app-expert-do/getExpertList", params: {
      "data": {"type": expertType},
      "page": page,
      "pageSize": size
    });
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = ExpertViewsEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///查询专家
  static Future<List<ExpertSearchEntity>?> getExpert(String input) async {
    final result = await DioUtils.post("/plan/app-expert-do/expertSearch",
        params: {"expertName": input, "userId": User.info?.id});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<ExpertSearchEntity> data = result.data['d']
          .map<ExpertSearchEntity>((e) => ExpertSearchEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///专家最新观点
  static Future<List<Rows>?> getExpertNewViews(
      String expertId, int sportsId) async {
    final result = await DioUtils.post("/plan/app-plan-do/expertLastPlan",
        params: {"expertId": expertId, "sportsId": sportsId});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<Rows> data =
          result.data['d'].map<Rows>((e) => Rows.fromJson(e)).toList();
      return data;
    }
    return null;
  }

  ///专家热门观点
  static Future<List<Rows>?> getExpertHotViews(
      int page, int size, int searchType) async {
    final result =
        await DioUtils.post("/plan/app-plan-do/lastPlanHot", params: {
      "page": page,
      "pageSize": size,
      "data": {"searchType": searchType, "sportsId": 0}
    });
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<Rows> data =
          result.data['d'].map<Rows>((e) => Rows.fromJson(e)).toList();
      return data;
    }
    return null;
  }

  ///专家历史观点
  static Future<ExpertViewsEntity?> getExpertHistoryViews(
      String id, int page, int size, int sportsId) async {
    final result =
        await DioUtils.post("/plan/app-plan-do/planHistory", params: {
      "page": page,
      "pageSize": size,
      "data": {"expertId": id, "sportsId": sportsId}
    });
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = ExpertViewsEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///关注专家观点
  static Future<ExpertViewsEntity?> getExpertFocusViews() async {
    final result = await DioUtils.post("/plan/app-plan-do/lastPlanFocus",
        params: {"userId": User.auth?.userId, "sportsId": 0});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = ExpertViewsEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///专家专栏
  static Future<List<ExpertIdeaEntity>?> getIdeaExpertList(
      int page, int size) async {
    final result = await DioUtils.post("/plan/app-idea/expertList", params: {
      "page": page,
      "pageSize": size,
    });
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<ExpertIdeaEntity> data = result.data['d']
          .map<ExpertIdeaEntity>((e) => ExpertIdeaEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///专家详情
  static Future<ExpertDetailEntity?> getExpertDetail(String id) async {
    final result = await DioUtils.post("/plan/app-expert-do/expertDetail",
        params: {"expertId": id});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = ExpertDetailEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///专家订阅文章列表
  static Future<ExpertIdeaListEntity?> getExpertIdeaList(
      String id, int page, int size) async {
    final result =
        await DioUtils.post("/plan/app-idea/expertIdeaList", params: {
      "d": {
        "page": page,
        "pageSize": size,
        "data": {"expertId": id}
      }
    });
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = ExpertIdeaListEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///比赛详情关注观点
  static Future<ExpertViewsEntity?> getMatchViews(
      String matchId, int page, int size, int index, int sportsId) async {
    List<String> url = [
      "matchPlanFocus",
      "matchPlan",
      "matchPlanFree",
      "matchPlanBack",
      "matchPlanRed"
    ];
    final result =
        await DioUtils.post("/plan/app-plan-match-do/${url[index]}", params: {
      "page": page,
      "pageSize": size,
      "data": {
        "matchId": matchId,
        "userId": index == 0 ? User.auth?.userId : "",
        "sportsId": "$sportsId"
      }
    });
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = ExpertViewsEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///下单
  static Future<OrderEntity?> generatePayOrder(
      {String? itemId,
      double? payAmt,
      int? payType,
      bool showLoading = false}) async {
    final data = {
      'itemId': itemId ?? 0,
      'payAmt': payAmt ?? 0,
      'payType': payType,
      'userId': User.auth?.userId
    };
    final result = await DioUtils.post("/user/usr-do/pay/save",
        params: data, showLoading: showLoading);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return OrderEntity.fromJson(result.data['d']);
    }
    return null;
  }

  ///验证ios内购
  static Future<int?> verifyIosPay(
      String? qxbOrderId, String receiptData, String productId) async {
    final data = {
      'qxbOrderId': qxbOrderId,
      'receiptDate': receiptData,
      'userId': User.auth?.userId,
      'productId': productId,
    };
    final result = await DioUtils.post("/user/usr-do/iosPay", params: data);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  ///金币明细列表
  static Future<List<CoinHistoryEntity>?> goldHistoryList(
      int page, int pageSize) async {
    final data = {
      'data': {
        'status': 2,
        'userId': User.auth?.userId,
        'goldSign': '',
        'phone': ''
      },
      'page': page,
      'pageSize': pageSize
    };
    final result = await DioUtils.post("/user/usr-do/gold/list", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<CoinHistoryEntity> data = result.data['d']['rows']
          .map<CoinHistoryEntity>((e) => CoinHistoryEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///关注专家
  static Future<int?> expertFocus(String expertId) async {
    final data = {
      'expertId': expertId,
      'userId': User.auth?.userId,
    };
    final result =
        await DioUtils.post("/plan/app-expert-do/bind", params: data);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  ///取消关注
  static Future<int?> expertUnfocus(String expertId) async {
    final data = {
      'expertId': expertId,
      'userId': User.auth?.userId,
    };
    final result =
        await DioUtils.post("/plan/app-expert-do/unbind", params: data);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  ///专家关注列表
  static Future<ExpertFocusEntity?> expertFocusList(
      int page, int pageSize) async {
    final data = {
      'data': {
        'userId': User.auth?.userId,
      },
      'page': page,
      'pageSize': pageSize
    };
    final result = await DioUtils.post("/plan/app-expert-do/my", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return ExpertFocusEntity.fromJson(result.data['d']);
    }
    return null;
  }

  ///球队关注列表
  static Future<List<MyTeamFocusEntity>?> teamFocusList() async {
    final result = await DioUtils.post("/data/app-do/myTeamFocusList");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<MyTeamFocusEntity> data = result.data['d']
          .map<MyTeamFocusEntity>((e) => MyTeamFocusEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///金币明细
  static Future<CoinDetailEntity?> coinDetail(String goldId) async {
    final data = {
      'goldId': goldId,
      'userId': User.auth?.userId,
    };
    final result =
        await DioUtils.post("/user/usr-do/gold/detailInfo", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return CoinDetailEntity.fromJson(result.data['d']);
    }
    return null;
  }

  static Future<Response?> planOrder(double gold, String planId,
      {double? couponGold, String? couponId}) async {
    return await DioUtils.post("/plan/app-plan-do/order",
        params: {
          "gold": gold,
          "planId": planId,
          "userId": User.auth?.userId,
          "couponGold": couponGold,
          "couponId": couponId
        },
        showToast: false);
  }

  ///我的已购
  static Future<List<OrderListEntity>?> orderList(
      int page, int pageSize) async {
    final data = {
      'data': {
        'userId': User.auth?.userId,
      },
      'page': page,
      'pageSize': pageSize
    };
    final result =
        await DioUtils.post("/plan/app-plan-do/orderList", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<OrderListEntity> data = result.data['d']
          .map<OrderListEntity>((e) => OrderListEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  static Future<Response> getMatchAnalive(int matchid) async {
    return await DioUtils.post("/match/app-match-do/anaLive", params: matchid);
  }

  ///专家申请
  static Future<ExpertApplyEntity?> expertApply(ExpertApplyEntity data) async {
    final result = await DioUtils.post("/plan/app-expert-do/apply",
        params: data.toJson(), showLoading: true);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return ExpertApplyEntity.fromJson(result.data['d']);
    }
    return null;
  }

  ///专家申请查询
  static Future<ExpertApplyEntity?> expertApplyInfo() async {
    String userId = User.info!.id!;
    final data = {'id': userId};
    final result = await DioUtils.post("/plan/app-expert-do/applyInfo",
        params: data, showLoading: true);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return ExpertApplyEntity.fromJson(result.data['d']);
    }
    return null;
  }

  static Future<List<LeagueChannelEntity>?> myLeagueChannels() async {
    try {
      final r = await DioUtils.post("/data/app-do/leagueChannel",
          params: {"userId": User.auth?.userId});
      final l = r.data['d'] as List;
      return l.map((e) => LeagueChannelEntity.fromJson(e)).toList();
    } catch (err) {
      log("my league channels err $err");
    }
    return null;
  }

  static Future<List<LeagueChannelAreaEntity>?> leagueChannelsAll() async {
    try {
      final r = await DioUtils.post("/data/app-do/leagueChannelAll");
      final l = r.data['d'] as List;
      return l.map((e) => LeagueChannelAreaEntity.fromJson(e)).toList();
    } catch (err) {
      log("$err");
    }
    return null;
  }

  static Future<bool> updateLeagueChannel(List<LeagueChannelEntity> l) async {
    try {
      final r = await DioUtils.post("/data/app-do/leagueChannelUpdate",
          params: {
            "leagueIds": l.map((e) => e.leagueId).toList(),
            "userId": User.auth?.userId
          });
      return r.data['c'] == 200;
    } catch (err) {}
    return false;
  }

  ///联赛查询
  static Future<LeagueChannelEntity?> getLeague(String leagueId) async {
    try {
      final r = await DioUtils.post("/data/app-do/leagueChannelById",
          params: {"leagueId": leagueId});
      final l = r.data['d'] as List;
      return LeagueChannelEntity.fromJson(l[0]);
    } catch (err) {
      log("league err $err");
    }
    return null;
  }

  ///球队页面结构
  static Future<List<DataTypeEntity>?> getTeamStruct(
      String season, int qxbLeagueId) async {
    final data = {'qxbLeagueId': qxbLeagueId, 'season': season};
    final result =
        await DioUtils.post("/data/app-channel-do/teamStruct", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<DataTypeEntity> data = result.data['d']['searchTypes']
          .map<DataTypeEntity>((e) => DataTypeEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///球队
  static Future<Response> getTeamData(
      String season, int qxbLeagueId, int searchType,
      {bool needLoading = false}) async {
    final data = {
      'qxbLeagueId': qxbLeagueId,
      'season': season,
      'searchType': searchType
    };
    final result = await DioUtils.post("/data/app-channel-do/team",
        params: data, showLoading: needLoading);
    return result;
  }

  ///球员页面结构
  static Future<List<DataTypeEntity>?> getPlayerStruct(
      String season, int qxbLeagueId) async {
    final data = {'qxbLeagueId': qxbLeagueId, 'season': season};
    final result =
        await DioUtils.post("/data/app-channel-do/playerStruct", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<DataTypeEntity> data = result.data['d']['searchTypes']
          .map<DataTypeEntity>((e) => DataTypeEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///球员
  static Future<Response> getPlayerData(
      String season, int qxbLeagueId, int searchType,
      {bool needLoading = false}) async {
    final data = {
      'qxbLeagueId': qxbLeagueId,
      'season': season,
      'searchType': searchType
    };
    final result = await DioUtils.post("/data/app-channel-do/player",
        params: data, showLoading: needLoading);
    return result;
  }

  ///数据赛程
  static Future<List<DataScheduleEntity>?> dataSchedule(
      int leagueId, String season) async {
    try {
      final r = await DioUtils.post("/data/app-do/schedule",
          params: {"leagueId": leagueId, "season": season});
      final l = r.data['d'] as List;
      return l.map((e) => DataScheduleEntity.fromJson(e)).toList();
    } catch (err) {}
    return null;
  }

  ///数据积分
  static Future<DataPointsEntity?> getLeaguePoints(
      int qxbLeagueId, String season) async {
    final data = {
      'qxbLeagueId': qxbLeagueId,
      'season': season,
    };
    final result =
        await DioUtils.post("/data/app-channel-do/standing", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      DataPointsEntity? data = DataPointsEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///数据杯赛积分
  static Future<DataCupPointsEntity?> getCupPoints(
      int qxbLeagueId, String season) async {
    final data = {
      'qxbLeagueId': qxbLeagueId,
      'season': season,
    };
    final result =
        await DioUtils.post("/data/app-channel-do/cupStanding", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      DataCupPointsEntity? data =
          DataCupPointsEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///数据转会
  static Future<DataTransferEntity?> getDataTransfer(
      int qxbLeagueId, String season) async {
    final data = {
      'qxbLeagueId': qxbLeagueId,
      'season': season,
    };
    final result =
        await DioUtils.post("/data/app-channel-do/transfer", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      DataTransferEntity data = DataTransferEntity.fromJson(result.data['d']);
      return data;
    }
  }

  ///澳客赔率
  static Future<MatchOddsOkEntity?> getOddsOk(int matchId) async {
    final result =
        await DioUtils.post("/odds/app-odds-do/oddsOkMatch", params: matchId);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      MatchOddsOkEntity data = MatchOddsOkEntity.fromJson(result.data['d']);
      return data;
    }
  }

  static final coupon = CouponApi();

  ///球队简介
  static Future<TeamDetailEntity?> getTeamDetail(int id) async {
    final data = {'id': id};
    final result =
        await DioUtils.post("/data/app-team-channel-do/view", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      TeamDetailEntity data = TeamDetailEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///球队阵容
  static Future<List<TeamLineupEntity>> getTeamLineup(int id) async {
    final data = {
      'id': id,
    };
    final result =
        await DioUtils.post("/data/app-team-channel-do/lineup", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<TeamLineupEntity> data = result.data['d']
          .map<TeamLineupEntity>((e) => TeamLineupEntity.fromJson(e))
          .toList();
      return data;
    }
    return [];
  }

  ///球队简介
  static Future<List<String>?> getSystemAvatar() async {
    final result = await DioUtils.post("/user/usr-do/avatarList");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      return result.data['d'].cast<String>();
    }
    return null;
  }

  ///球队赛程
  static Future<TeamScheduleEntity?> getTeamSchedule(
      int id, String year) async {
    final data = {'qxbTeamId': id, 'year': year};
    final result =
        await DioUtils.post("/data/app-team-channel-do/match", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      TeamScheduleEntity data = TeamScheduleEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///球队赛程年份
  static Future<List<TeamScheduleYearEntity>> getTeamScheduleYear(
      int id) async {
    final result = await DioUtils.post("/data/app-team-channel-do/matchYear",
        params: {'id': id});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<TeamScheduleYearEntity> data = result.data['d']
          .map<TeamScheduleYearEntity>(
              (e) => TeamScheduleYearEntity.fromJson(e))
          .toList();
      return data;
    }
    return [];
  }

  ///数据排名
  static Future<List<DataRankEntity>> getDataRank(
      {required int type, String? area, String? month}) async {
    final data = {
      'type': type, // 1男足 2女足 3俱乐部
      'rankMonth': month,
      'areaCn': area
    };
    final result = await DioUtils.post("/data/app-do/rankList", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<DataRankEntity> data = result.data['d']
          .map<DataRankEntity>((e) => DataRankEntity.fromJson(e))
          .toList();
      return data;
    }
    return [];
  }

  ///数据排名月份
  static Future<List<DataRankMonthEntity>> getDataRankMonth(int type) async {
    final result = await DioUtils.post("/data/app-do/rankMonthList",
        params: {'type': type});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<DataRankMonthEntity> data = result.data['d']
          .map<DataRankMonthEntity>((e) => DataRankMonthEntity.fromJson(e))
          .toList();
      return data;
    }
    return [];
  }

  ///篮球数据排名
  static Future<List<DataBbRankEntity>> getDataBbRank(
      {required int type, int? area, String? month}) async {
    final data = {
      'type': type, // 1男篮 2女篮
      'month': month,
      'regionId': area
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-data-do/fibaRank",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<DataBbRankEntity> data = result.data['d']
          .map<DataBbRankEntity>((e) => DataBbRankEntity.fromJson(e))
          .toList();
      return data;
    }
    return [];
  }

  ///篮球数据排名月份
  static Future<List<DataBbRankMonthEntity>> getDataBbRankMonth(
      int type) async {
    final result = await DioUtils.post(
        "/basketball/app-basketball-data-do/fibaRankMonth",
        params: {'type': type});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<DataBbRankMonthEntity> data = result.data['d']
          .map<DataBbRankMonthEntity>((e) => DataBbRankMonthEntity.fromJson(e))
          .toList();
      return data;
    }
    return [];
  }

  ///关注球队  1关注 2取消关注
  static Future<int?> focusTeam(int id, int isFocus) async {
    final data = {
      "addOrDel": isFocus,
      "list": [id],
      'userId': User.auth?.userId,
    };
    final result =
        await DioUtils.post("/data/app-do/teamFocusUpdate", params: data);
    if (result.statusCode == 200) {
      return result.data['c'];
    }
    return null;
  }

  ///关注球队选择列表
  static Future<List<FocusTeamListEntity>?> teamForSelect() async {
    final result = await DioUtils.post("/data/app-do/teamForSelect");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<FocusTeamListEntity> data = result.data['d']
          .map<FocusTeamListEntity>((e) => FocusTeamListEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///比赛详情指数
  static Future<List<SoccerOddsEntity>?> getMatchOdds(
      int playType, int id) async {
    final data = {"playType": playType, "qxbMatchId": id};
    final result =
        await DioUtils.post("/odds/app-odds-do/exponent", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<SoccerOddsEntity> data = result.data['d']
          .map<SoccerOddsEntity>((e) => SoccerOddsEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///比赛详情指数详情
  static Future<List<SoccerOddsDetailEntity>?> getMatchOddsDetail(
      int id, int companyId, int playType, String line) async {
    final data = {
      "companyId": companyId,
      "playType": playType,
      "qxbMatchId": id,
      "line": line
    };
    final result =
        await DioUtils.post("/odds/app-odds-do/exponentInfo", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<SoccerOddsDetailEntity> data = result.data['d']
          .map<SoccerOddsDetailEntity>(
              (e) => SoccerOddsDetailEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///比赛详情指数详情公司列表
  static Future<List<SoccerOddsCompanyEntity>?> getMatchOddsCompany(
      int id, int playType) async {
    final data = {"playType": playType, "qxbMatchId": id};
    final result =
        await DioUtils.post("/odds/app-odds-do/companyArray", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<SoccerOddsCompanyEntity> data = result.data['d']
          .map<SoccerOddsCompanyEntity>(
              (e) => SoccerOddsCompanyEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球比赛详情指数
  static Future<List<SoccerOddsEntity>?> getBbMatchOdds(
      int playType, int id) async {
    final data = {"playType": playType, "qxbMatchId": id};
    final result =
        await DioUtils.post("/basketball/app-odds-do/exponent", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<SoccerOddsEntity> data = result.data['d']
          .map<SoccerOddsEntity>((e) => SoccerOddsEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球详情指数详情
  static Future<List<SoccerOddsDetailEntity>?> getBbMatchOddsDetail(
      int id, int companyId, int playType, String line) async {
    final data = {
      "companyId": companyId,
      "playType": playType,
      "qxbMatchId": id,
      "line": line
    };
    final result = await DioUtils.post("/basketball/app-odds-do/exponentInfo",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<SoccerOddsDetailEntity> data = result.data['d']
          .map<SoccerOddsDetailEntity>(
              (e) => SoccerOddsDetailEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球详情指数详情公司列表
  static Future<List<SoccerOddsCompanyEntity>?> getBbMatchOddsCompany(
      int id, int playType) async {
    final data = {"playType": playType, "qxbMatchId": id};
    final result = await DioUtils.post("/basketball/app-odds-do/companyArray",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<SoccerOddsCompanyEntity> data = result.data['d']
          .map<SoccerOddsCompanyEntity>(
              (e) => SoccerOddsCompanyEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///赔率公司列表
  static Future<List<OddsCompanyEntity>?> getOddsCompany() async {
    final result = await DioUtils.post("/odds/app-odds-do/oddsCompany");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<OddsCompanyEntity> data = result.data['d']
          .map<OddsCompanyEntity>((e) => OddsCompanyEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球详情阵容关键数据
  static Future<BbLineupKeyDataEntity?> getBbLineupKeyData(int id) async {
    final result = await DioUtils.post(
        "/basketball/app-basketball-match-do/keyData",
        params: {'matchId': id});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BbLineupKeyDataEntity data =
          BbLineupKeyDataEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球详情阵容列表
  static Future<List<BbLineupDataEntity>?> getBbLineupData(
      int id, int teamType) async {
    final data = {
      "matchId": id,
      "teamType": teamType,
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-match-do/player/technic",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BbLineupDataEntity> data = result.data['d']
          .map<BbLineupDataEntity>((e) => BbLineupDataEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球详情阵容伤病列表
  static Future<BbLineupSuspendDataEntity?> getBbLineupSuspendData(
      int id) async {
    final result = await DioUtils.post(
        "/basketball/app-basketball-match-do/player/injury",
        params: {"matchId": id});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BbLineupSuspendDataEntity data =
          BbLineupSuspendDataEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球详情情报
  static Future<BbInfoEntity?> getBbInfo(int id) async {
    final result = await DioUtils.post(
        "/basketball/app-basketball-match-do/teamRemark",
        params: {"matchId": id});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BbInfoEntity data = BbInfoEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球比赛对比
  static Future<BasketMatchDataTeamEntity?> getTeamSimple(int id) async {
    final data = {
      "qxbMatchId": id,
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-match-do/teamSimple",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BasketMatchDataTeamEntity data =
          BasketMatchDataTeamEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球比赛场均对比
  static Future<BasketMatchDataTeamAvgEntity?> getTeamAvg(int id) async {
    final data = {
      "qxbMatchId": id,
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-match-do/avgData",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BasketMatchDataTeamAvgEntity data =
          BasketMatchDataTeamAvgEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  //篮球比赛对比、场均
  static Future<BbMatchDataCompareEntity?> getTeamCompare(int id) async {
    final data = {
      "qxbMatchId": id,
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-match-do/appTeamSimple",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BbMatchDataCompareEntity data =
          BbMatchDataCompareEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球比赛对阵数据
  static Future<BasketMatchDataEntity?> getTeamMatchData(int id) async {
    final data = {
      "qxbMatchId": id,
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-match-do/teamMatchData",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BasketMatchDataEntity data =
          BasketMatchDataEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球热门、一级联赛列表
  static Future<LeagueListEntity?> getBasketLeagueList() async {
    final result =
        await DioUtils.post("/basketball/app-basketball-match-do/leagues");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      final data = LeagueListEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///获取用户关注
  static Future<List<BasketListEntity>?> getBasketMatchFocus() async {
    final result = await DioUtils.post("/basketball/app-bb-do/matchFocus",
        params: {"id": User.auth?.userId ?? ""});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BasketListEntity> data = result.data['d']
          .map<BasketListEntity>((e) => BasketListEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///获取全部比赛
  static Future<List<BasketListEntity>?> getBasketMatchAllList() async {
    final result = await DioUtils.post("/basketball/app-bb-do/matchAll");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BasketListEntity> data = result.data['d']
          .map<BasketListEntity>((e) => BasketListEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///获取进行中比赛
  static Future<List<BasketListEntity>?> getBasketMatchBeginList() async {
    final result = await DioUtils.post("/basketball/app-bb-do/matchIng");
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BasketListEntity> data = result.data['d']
          .map<BasketListEntity>((e) => BasketListEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///获取比赛赛果
  static Future<List<BasketListEntity>?> getBasketMatchResultList(
      String time) async {
    final data = {'id': time};
    final result =
        await DioUtils.post("/basketball/app-bb-do/matchResult", params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BasketListEntity> data = result.data['d']
          .map<BasketListEntity>((e) => BasketListEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///获取比赛赛程
  static Future<List<BasketListEntity>?> getBasketMatchScheduleList(
      String time) async {
    final data = {'id': time};
    final result = await DioUtils.post("/basketball/app-bb-do/matchSchedule",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BasketListEntity> data = result.data['d']
          .map<BasketListEntity>((e) => BasketListEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球球队赛程
  static Future<BbTeamScheduleEntity?> getBbTeamSchedule(int id, String year,
      {int? kind, int? leagueId}) async {
    final data = {
      'qxbTeamId': id,
      'matchYear': year,
      "kind": kind,
      "leagueId": leagueId
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-team-channel-do/matchSchedule",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BbTeamScheduleEntity data =
          BbTeamScheduleEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球球队赛程年份
  static Future<List<BbTeamScheduleYearEntity>> getBbTeamScheduleYear(
      int id) async {
    final result = await DioUtils.post(
        "/basketball/app-basketball-team-channel-do/matchScheduleYear",
        params: {'id': id});
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BbTeamScheduleYearEntity> data = result.data['d']
          .map<BbTeamScheduleYearEntity>(
              (e) => BbTeamScheduleYearEntity.fromJson(e))
          .toList();
      return data;
    }
    return [];
  }

  ///篮球球队简介
  static Future<BasketTeamDetailEntity?> getBasketTeamDetail(int id) async {
    final data = {'id': id};
    final result = await DioUtils.post(
        "/basketball/app-basketball-team-channel-do/view",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BasketTeamDetailEntity data =
          BasketTeamDetailEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球球队数据年份
  static Future<List<BbTeamDataYearEntity>?> getBasketTeamDataYear(
      int id) async {
    final data = {
      'id': id,
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-team-channel-do/statisticsYear",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BbTeamDataYearEntity> data = result.data['d']
          .map<BbTeamDataYearEntity>((e) => BbTeamDataYearEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球球队阵容年份
  static Future<List<BbTeamDataYearEntity>?> getBasketTeamLineupYear(
      int id) async {
    final data = {
      'id': id,
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-team-channel-do/squadYear",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BbTeamDataYearEntity> data = result.data['d']
          .map<BbTeamDataYearEntity>((e) => BbTeamDataYearEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球球队阵容
  static Future<List<BbTeamPlayerEntity>?> getBasketTeamLineup(
      int qxbTeamId, int? seasonId, int? leagueId, int? scopeId) async {
    final data = {
      'qxbTeamId': qxbTeamId,
      'seasonId': seasonId,
      'leagueId': leagueId,
      'scopeId': scopeId,
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-team-channel-do/squad",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<BbTeamPlayerEntity> data = result.data['d']
          .map<BbTeamPlayerEntity>((e) => BbTeamPlayerEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球球队统计
  static Future<BbTeamCountEntity?> getBasketTeamStatistics(int qxbTeamId,
      int seasonId, int? leagueId, int? scopeId, int? stageId) async {
    final data = {
      'qxbTeamId': qxbTeamId,
      'seasonId': seasonId,
      'leagueId': leagueId,
      'scopeId': scopeId,
      'stageId': stageId
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-team-channel-do/statistics",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BbTeamCountEntity data = BbTeamCountEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球数据积分排名
  static Future<BasketPointsEntity?> getBasketPoints(
      int leagueId, int seasonId) async {
    final data = {
      'leagueId': leagueId,
      'seasonId': seasonId,
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-data-do/rank",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      BasketPointsEntity? data = BasketPointsEntity.fromJson(result.data['d']);
      return data;
    }
    return null;
  }

  ///篮球数据赛程
  static Future<List<BasketScheduleEntity>?> getBasketSchedule(
      int leagueId, String seasonId) async {
    try {
      final r = await DioUtils.post(
          "/basketball/app-basketball-data-do/schedule",
          params: {"leagueId": leagueId, "seasonId": seasonId});
      final l = r.data['d'] as List;
      return l.map((e) => BasketScheduleEntity.fromJson(e)).toList();
    } catch (err) {}
    return null;
  }

  ///篮球数据赛程
  static Future<List<BasketSeasonEntity>?> getBasketSeason(int leagueId) async {
    try {
      final r = await DioUtils.post(
          "/basketball/app-basketball-data-do/getSeasonId",
          params: {"leagueId": leagueId});
      final l = r.data['d'] as List;
      return l.map((e) => BasketSeasonEntity.fromJson(e)).toList();
    } catch (err) {}
    return null;
  }

  ///篮球球员页面结构
  static Future<List<DataTypeEntity>?> getBasketPlayerStruct(
      int seasonId, int qxbLeagueId) async {
    final data = {'qxbLeagueId': qxbLeagueId, 'seasonId': seasonId};
    final result = await DioUtils.post(
        "/basketball/app-basketball-data-do/playerStruct",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<DataTypeEntity> data = result.data['d']['searchTypes']
          .map<DataTypeEntity>((e) => DataTypeEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///篮球球员
  static Future<Response> getBasketPlayerData(
      int seasonId, int qxbLeagueId, int searchType,
      {bool needLoading = false}) async {
    final data = {
      'qxbLeagueId': qxbLeagueId,
      'seasonId': seasonId,
      'searchType': searchType
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-data-do/player",
        params: data,
        showLoading: needLoading);
    return result;
  }

  static Future<Response> authCheckName(
          String cardID, String name, String code) =>
      DioUtils.post("/user/app-auth/checkName",
          showLoading: true,
          params: {'cardNo': cardID, 'name': name, 'smsCode': code});

  ///球队页面结构
  static Future<List<DataTypeEntity>?> getBbTeamStruct(
      int seasonId, int qxbLeagueId) async {
    final data = {'qxbLeagueId': qxbLeagueId, 'seasonId': seasonId};
    final result = await DioUtils.post(
        "/basketball/app-basketball-data-do/teamStruct",
        params: data);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<DataTypeEntity> data = result.data['d']['searchTypes']
          .map<DataTypeEntity>((e) => DataTypeEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///球队
  static Future<Response> getBbTeamData(
      int seasonId, int qxbLeagueId, int searchType,
      {bool needLoading = false}) async {
    final data = {
      'qxbLeagueId': qxbLeagueId,
      'seasonId': seasonId,
      'searchType': searchType
    };
    final result = await DioUtils.post(
        "/basketball/app-basketball-data-do/team",
        params: data,
        showLoading: needLoading);
    return result;
  }

  ///视频直播源
  static Future<List<MatchVideoEntity>?> getVideoList(int matchId, int sportsId,
      {bool needLoading = false}) async {
    final data = {
      'matchId': matchId,
      'sportsId': sportsId,
    };
    final result = await DioUtils.post("/info/info-video-do/list",
        params: data, showLoading: needLoading);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      List<MatchVideoEntity> data = result.data['d']
          .map<MatchVideoEntity>((e) => MatchVideoEntity.fromJson(e))
          .toList();
      return data;
    }
    return null;
  }

  ///视频直播源
  ///invite1 邀请好友
  static Future<Response> joinActivity(String activityId,
      {bool needLoading = false}) async {
    final data = {
      'activityId': activityId,
    };
    final result = await DioUtils.post("/user/usr-coupon-do/joinActivity",
        params: data, showLoading: needLoading);

    return result;
  }

  static syncNewsRead() {
    final list = LocalReadHistory.readedNews();
    if (list.isEmpty) {
      return;
    }
    DioUtils.post("/info/info-news-comment-do/news/read",
        params: {"idList": list});
  }
}
