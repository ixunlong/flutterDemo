import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/match/match_info_entity.dart';
import 'package:sports/model/match/match_video_entity.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/soccer_match_detail/soccer_match_odds_view.dart';
import 'package:sports/view/match_detail/soccer_match_detail/soccer_suspend_view.dart';

import '../../view/match_detail/soccer_match_detail/soccer_lineup_view.dart';
import '../../view/match_detail/soccer_match_detail/soccer_match_data_view.dart';
import '../../view/match_detail/soccer_match_detail/soccer_match_info_view.dart';
import '../../view/match_detail/soccer_match_detail/soccer_match_outs_view.dart';
import '../../view/match_detail/match_views_page.dart';

class SoccerMatchDetailController extends GetxController
    with GetTickerProviderStateMixin {
  late int matchId;
  // SoccerMatchDetailController();
  bool _loadUrl = true;
  String tabName = '';
  late TabController tabController;
  MatchInfoEntity? info;
  // List<MatchVideoEntity>? videoList;
  List _tabList = [
    // ["盈亏", SoccerMatchBfView()]
  ];

  List get tabList => _tabList;
  bool get loadUrl => _loadUrl;
  @override
  void onInit() async {
    super.onInit();
    matchId = Get.arguments;
    if (Get.parameters.isNotEmpty) {
      tabName = Get.parameters['tabName']!;
    }
    // Future.delayed(Duration.zero).then((value) {
    //   updateTabController();
    // });
    // checkLineup();
    // //checkCommonViews();
    // checkInfo();
    // checkBf();
    tabController = TabController(vsync: this, length: _tabList.length);
  }

  @override
  void onReady() {
    super.onReady();
    // Api.getVideoList(matchId, 1).then((value) {
    //   if (value != null && value.isNotEmpty) {
    //     videoList = value;
    //     update();
    //   }
    // });
  }

  @override
  InternalFinalCallback<void> get onDelete =>
      InternalFinalCallback(callback: () {
        tabController.dispose();
      });

  void setLoad(value) {
    _loadUrl = value;
    update();
  }

  updateTabController() {
    if (info == null) {
      return;
    }
    _tabList = [];
    // if (info?.live == true) {
    //   _tabList.add([
    //     Constant.saikuang,
    //     SoccerMatchOutsView(info: info, matchId: matchId)
    //   ]);
    // }
    // if (info?.lineup == true) {
    //   _tabList.add([Constant.zhenrong, const SoccerLineupView()]);
    // }
    // if (info?.injure == true) {
    //   _tabList.add([Constant.shangjin, const SoccerSuspendView()]);
    // }
    if (info?.data == true) {
      _tabList.add([Constant.shuju, const SoccerMatchDataView()]);
    }
    if (info?.plan == true) {
      _tabList.add([Constant.guandian, const MatchViewsPage()]);
    }
    // if (info?.info == true) {
    //   _tabList.add([Constant.qingbao, SoccerMatchInfoView()]);
    // }
    if (info?.odds == true) {
      _tabList.add([Constant.zhishu, SoccerMatchOddsView()]);
    }
    tabController.dispose();
    int index = 0;
    if (tabName.isEmpty) {
      if (info?.state == MatchState.notStart) {
        if (info?.planCnt != 0 && info?.planCnt != null) {
          index =
              tabList.indexWhere((element) => element[0] == Constant.guandian);
        } else {
          index = tabList.indexWhere((element) => element[0] == Constant.shuju);
        }
      }
    } else {
      index = tabList.indexWhere((element) => element[0] == tabName);
      if (index < 0 || index >= tabList.length) {
        index = 0;
      }
    }
    tabController =
        TabController(initialIndex: index, length: tabList.length, vsync: this);
    tabController.addListener(() {
      tabName = tabList[tabController.index][0];
    });
    // update();
  }

  // Future _getMatchInfo() async {
  //   final data = await Utils.tryOrNullf(() async {
  //     final result = await Api.getMatchInfo(matchId);
  //     final data = MatchInfoEntity.fromJson(result.data['d']);
  //     return data;
  //   });
  //   log("get match info : ${data?.toJson()}");
  //   info = data;
  //   update();
  // }
}
