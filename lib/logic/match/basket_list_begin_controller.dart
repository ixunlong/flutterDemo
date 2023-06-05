import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/home/navigation_controller.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/model/match/basket_list_entity.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/constant.dart';
import 'package:sports/util/utils.dart';

class BasketListBeginController extends GetxController
    implements MatchListProvider {
  final refreshController = EasyRefreshController();
  final filter =
      Get.find<BasketMatchFilterController>(tag: Constant.matchFilterTagBegin);
  List<BasketListEntity> originalData = [];
  List<DateTime>? dateList;
  List<List<BasketListEntity>>? groupMatchList;
  bool hideBottom = false;
  int hideMatch = 0;
  //012 全部 一级 竞足
  @override
  QuickFilter quickFilter = QuickFilter.all;
  @override
  bool firstLoad = true;

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
    List<BasketListEntity>? matchList = await Api.getBasketMatchBeginList();

    if (matchList != null) {
      originalData = matchList;
      if (firstLoad) {
        filter.initLeague(MatchType.begin);
        quickFilter = filter.quickFilter;
      }
      filterMatch(filter.getHideLeagueIdList());
      firstLoad = false;
    }

    // Future.delayed(
    //     Duration(seconds: 1), Get.find<NavigationController>().stopVGA);
  }

  void handleData(List<BasketListEntity> matchList) async {
    List<DateTime> dateListTemp = [];
    List<List<BasketListEntity>> groupMatchListTemp = [];
    List<BasketListEntity> sameDayMatchList = [];
    for (BasketListEntity match in matchList) {
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
    filter.updateLeague();
    filterMatch([]);
  }

  void onHideBottom() {
    hideBottom = true;
    update();
  }

  // String getMatchTypeImage() {
  //   String matchTypeImage = 'match_all.png';
  //   if (quickFilter == 1) {
  //     matchTypeImage = 'match_yiji.png';
  //   } else if (quickFilter == 2) {
  //     matchTypeImage = 'match_jingzu.png';
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

  @override
  onSelectMatchType(QuickFilter index) {
    // TODO: implement onSelectMatchType
    throw UnimplementedError();
  }

  // @override
  // bool stopRefresh() {
  //   var time = refreshController.controlFinishRefresh;
  //   update();
  //   return time;
  // }
}
