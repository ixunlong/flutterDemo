import 'dart:async';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/basket_list_begin_controller.dart';
import 'package:sports/logic/match/basket_list_end_controller.dart';
import 'package:sports/logic/match/basket_list_schedule_controller.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/match_result_controller.dart';
import 'package:sports/logic/match/match_schedule_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/match/basket_list_entity.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/date_utils_extension.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';

class BasketListAllController extends GetxController
    implements MatchListProvider {
  final refreshController = EasyRefreshController();

  final filter =
      Get.find<BasketMatchFilterController>(tag: Constant.matchFilterTagAll);
  //所有比赛
  List<BasketListEntity> originalData = [];
  //筛选比赛
  // List<MatchEntity> filterData = [];
  List<DateTime>? dateList;
  List<List<BasketListEntity>>? groupMatchList;
  List groupListData = [];

  bool hideBottom = false;
  int hideMatch = 0;

  @override
  bool firstLoad = true;

  @override
  QuickFilter quickFilter = QuickFilter.all;

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
    List<BasketListEntity>? matchList = await Api.getBasketMatchAllList();
    if (matchList != null) {
      originalData = matchList;
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

  void handleData(List<BasketListEntity> matchList) {
    List<DateTime> dateListTemp = [];
    List<List<BasketListEntity>> groupMatchListTemp = [];
    //同一天比赛
    List<BasketListEntity> sameDayMatchList = [];
    for (int i = 0; i < matchList.length; i++) {
      BasketListEntity match = matchList[i];
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
    List<BasketListEntity> matchList = [];
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
        if (filter.leagueType == LeagueType.jc && match.jcNo.valuable == true) {
          matchList.add(match);
        } else if (filter.leagueType == LeagueType.all ||
            filter.leagueType == LeagueType.rm) {
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
    if (Get.find<ConfigService>().basketConfig.basketInAppAlert4 == 1) {
      try {
        Get.find<BasketListScheduleController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
      try {
        Get.find<BasketListEndController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
      try {
        Get.find<BasketListBeginController>().filterOnMatchType(type);
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

      filter.onSelectLeagueType(LeagueType.jc);
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
    // filter.updateLeague();
    filterMatch([]);
    filter.savaFilter();
  }

  void onHideBottom() {
    hideBottom = true;
    update();
  }

  // String getMatchTypeImage() {
  //   String matchTypeImage = 'quanbu_select.png';
  //   if (matchType == 1) {
  //     matchTypeImage = 'yiji_select.png';
  //   } else if (matchType == 2) {
  //     matchTypeImage = 'jingzu_select.png';
  //   }
  //   return matchTypeImage;
  // }

  @override
  Future doRefresh() async {
    refreshController.callRefresh();
    // update();
  }

  @override
  String getTicketName(MatchEntity match) {
    // TODO: implement getTicketName
    throw UnimplementedError();
  }

  // @override
  // String getTicketName(BasketListEntity match) {
  //   String name = '';
  //   if (filter.leagueType == LeagueType.jc) {
  //     name = match.jcMatchNo ?? '';
  //   }
  //   return name;
  // }

  // @override
  // bool stopRefresh() {
  //   var time = refreshController.controlFinishRefresh;
  //   update();
  //   return time;
  // }
}
