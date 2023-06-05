import 'dart:async';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/match_begin_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/match_result_controller.dart';
import 'package:sports/logic/match/match_schedule_controller.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/user.dart';

class MatchAllController extends GetxController implements MatchListProvider {
  final refreshController = EasyRefreshController();

  final filter =
      Get.find<SoccerMatchFilterController>(tag: Constant.matchFilterTagAll);
  //所有比赛
  List<MatchEntity> originalData = [];
  //筛选比赛
  // List<MatchEntity> filterData = [];
  List<DateTime>? dateList;
  List<List<MatchEntity>>? groupMatchList;
  List groupListData = [];
  bool firstLoad = true;
  //01234 全部 一级 竞足 观点 情报
  QuickFilter quickFilter = QuickFilter.all;
  bool hideBottom = false;
  // var showTop = false.obs;
  int hideMatch = 0;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getMatch();
  // }

  @override
  updateView() {
    update();
  }

  @override
  void onReady() {
    super.onReady();
    getMatch();
  }

  @override
  Future getMatch() async {
    List<MatchEntity>? matchList = await Api.getMatchAllList();
    if (matchList != null) {
      originalData = matchList;
      final filter = Get.find<SoccerMatchFilterController>(
          tag: Constant.matchFilterTagAll);
      if (firstLoad) {
        filter.initLeague(MatchType.all);
        quickFilter = filter.quickFilter;
      }
      filterMatch(filter.getHideLeagueIdList());
      // handleData(matchList);
      firstLoad = false;
    }
    // Future.delayed(
    //     Duration(seconds: 1), Get.find<NavigationController>().stopVGA);
  }

  void handleData(List<MatchEntity> matchList) {
    List<DateTime> dateListTemp = [];
    List<List<MatchEntity>> groupMatchListTemp = [];
    //同一天比赛
    List<MatchEntity> sameDayMatchList = [];
    for (int i = 0; i < matchList.length; i++) {
      MatchEntity match = matchList[i];
      final dateTime = DateTime.parse(match.matchTime!);
      if (dateListTemp.isEmpty) {
        dateListTemp.add(dateTime);
        sameDayMatchList.add(match);
      } else if (DateUtils.isSameDay(dateListTemp.last, dateTime)) {
        sameDayMatchList.add(match);
      } else {
        groupMatchListTemp.add(sameDayMatchList);
        matchList[i - 1].lastMatchInDay = true;
        dateListTemp.add(dateTime);
        sameDayMatchList = [match];
      }
    }
    //加上最后一天比赛
    if (sameDayMatchList.length > 0) {
      groupMatchListTemp.add(sameDayMatchList);
    }

    dateList = dateListTemp;
    groupMatchList = groupMatchListTemp;

    // List groupListDataTemp = [];
    // for (int i = 0; i < dateListTemp.length; i++) {
    //   for (var match in groupMatchListTemp[i]) {
    //     String time;
    //     if (DateUtils.isSameDay(dateListTemp[i], DateTime.now())) {
    //       time = '今天 ${DateFormat.E('zh_cn').format(dateListTemp[i])}';
    //     } else {
    //       time =
    //           '${DateUtilsExtension.formatDateTime(dateListTemp[i], 'MM/dd')} ${DateFormat.E('zh_cn').format(dateListTemp[i])}';
    //     }
    //     groupListDataTemp.add({'match': match, 'group': time});
    //   }
    // }
    // groupListData = groupListDataTemp;
    update();
  }

  void filterMatch(List<int> hideLeagueId) {
    hideBottom = false;
    List<MatchEntity> matchList = [];
    hideMatch = 0;
    for (var match in originalData) {
      if (quickFilter == QuickFilter.guandian && match.planCnt == 0) {
        hideMatch++;
        continue;
      } else if (quickFilter == QuickFilter.qingbao &&
          match.intelligence == 0) {
        hideMatch++;
        continue;
      }
      if (!hideLeagueId.contains(match.leagueId)) {
        if (filter.leagueType == LeagueType.jz && match.jcMatchNo != null) {
          matchList.add(match);
        } else if (filter.leagueType == LeagueType.dc &&
            match.dcMatchNo != null) {
          matchList.add(match);
        } else if (filter.leagueType == LeagueType.ssc &&
            match.sfcMatchNo != null) {
          matchList.add(match);
        } else if (filter.leagueType == LeagueType.all) {
          matchList.add(match);
        }
      }
    }
    if (quickFilter == QuickFilter.yiji ||
        quickFilter == QuickFilter.jingcai ||
        quickFilter == QuickFilter.all) {
      hideMatch = filter.hideMatch;
    }
    handleData(matchList);
  }

  @override
  onSelectMatchType(QuickFilter type, {bool fromFilterPage = false}) {
    quickFilter = type;
    if (Get.find<ConfigService>().soccerConfig.soccerInAppAlert7 == 1) {
      try {
        Get.find<MatchScheduleController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
      try {
        Get.find<MatchResultController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
      try {
        Get.find<MatchBeginController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
    }

    if (!fromFilterPage) {
      filterOnMatchType(type);
    }
  }

  filterOnMatchType(QuickFilter index) {
    // filter.initLeague(MatchType.all);
    quickFilter = index;
    if (quickFilter == QuickFilter.all) {
      onSelectDefault();
    } else if (quickFilter == QuickFilter.yiji) {
      filter.leagueType = LeagueType.all;
      filter.selectOneLevel();
      filterMatch(filter.hideLeagueId);
    } else if (quickFilter == QuickFilter.jingcai) {
      // quickFilter = 2;

      filter.onSelectLeagueType(LeagueType.jz);
      filterMatch(filter.getHideLeagueIdList());
    } else if (quickFilter == QuickFilter.guandian) {
      onSelectDefault(type: quickFilter);
    } else if (quickFilter == QuickFilter.qingbao) {
      onSelectDefault(type: quickFilter);
    }
    filter.savaFilter();
  }

  void onSelectDefault({QuickFilter type = QuickFilter.all}) {
    quickFilter = type;

    filter.leagueType = LeagueType.all;
    filter.selectAll();
    filter.updateLeague();
    filterMatch([]);
    filter.savaFilter();
  }

  void onHideBottom() {
    hideBottom = true;
    update();
  }

  @override
  Future doRefresh() async {
    refreshController.callRefresh();
    // update();
  }

  @override
  String getTicketName(MatchEntity match) {
    String name = '';
    if (filter.leagueType == LeagueType.jz) {
      name = match.jcMatchNo ?? '';
    } else if (filter.leagueType == LeagueType.dc) {
      name = match.dcMatchNo ?? '';
    } else if (filter.leagueType == LeagueType.ssc) {
      name = match.sfcMatchNo ?? '';
    } else {
      name = ((match.jcMatchNo ?? match.dcMatchNo) ?? match.sfcMatchNo) ?? '';
    }
    return name;
  }

  // @override
  // bool stopRefresh() {
  //   var time = refreshController.controlFinishRefresh;
  //   update();
  //   return time;
  // }
}
