import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/constant.dart';

class MatchBeginController extends GetxController implements MatchListProvider {
  final refreshController = EasyRefreshController();
  final filter =
      Get.find<SoccerMatchFilterController>(tag: Constant.matchFilterTagBegin);
  List<MatchEntity> originalData = [];
  List<DateTime>? dateList;
  List<List<MatchEntity>>? groupMatchList;
  //012 全部 一级 竞足
  @override
  QuickFilter quickFilter = QuickFilter.all;
  bool hideBottom = false;
  @override
  bool firstLoad = true;
  int hideMatch = 0;

  @override
  void onInit() {
    super.onInit();
    getMatch();
  }

  @override
  updateView() {
    update();
  }

  @override
  Future getMatch() async {
    List<MatchEntity>? matchList = await Api.getMatchBeginList();
    if (matchList != null) {
      originalData = matchList;
      if (firstLoad) {
        filter.initLeague(MatchType.begin);
        quickFilter = filter.quickFilter;
      }
      filterMatch(filter.getHideLeagueIdList());
      firstLoad = false;
      // handleData(originalData);
    }
    // Future.delayed(
    //     Duration(seconds: 1), Get.find<NavigationController>().stopVGA);
  }

  void handleData(List<MatchEntity> matchList) async {
    List<DateTime> dateListTemp = [];
    List<List<MatchEntity>> groupMatchListTemp = [];
    List<MatchEntity> sameDayMatchList = [];
    for (MatchEntity match in matchList) {
      final dateTime = DateTime.parse(match.matchTime!);
      if (dateListTemp.isEmpty) {
        dateListTemp.add(dateTime);
        sameDayMatchList.add(match);
      } else if (DateUtils.isSameDay(dateListTemp.last, dateTime)) {
        sameDayMatchList.add(match);
      } else {
        groupMatchListTemp.add(sameDayMatchList);
        dateListTemp.add(dateTime);
        sameDayMatchList = [match];
      }
    }
    //加上最后一天比赛
    if (sameDayMatchList.isNotEmpty) {
      groupMatchListTemp.add(sameDayMatchList);
    }

    dateList = dateListTemp;
    groupMatchList = groupMatchListTemp;

    update();
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
  onSelectMatchType(QuickFilter index) {
    // quickFilter = index;
    // filter.initLeague(MatchType.begin);
    // if (quickFilter == 0) {
    //   //一级
    //   quickFilter = 1;
    //   filter.leagueType = LeagueType.all;
    //   filter.selectOneLevel();
    //   filterMatch(filter.hideLeagueId);
    //   // update();
    // } else if (quickFilter == 1) {
    //   //竞足
    //   quickFilter = 2;
    //   // filter.leagueType = LeagueType.jz;
    //   // filter.updateLeague();
    //   filter.onSelectLeagueType(LeagueType.jz);
    //   filterMatch(filter.getHideLeagueIdList());
    // } else {
    //   onSelectDefault();
    // }
  }

  void onSelectDefault({QuickFilter type = QuickFilter.all}) {
    quickFilter = type;
    filter.leagueType = LeagueType.all;
    filter.selectAll();
    filter.updateLeague();
    filterMatch([]);
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
