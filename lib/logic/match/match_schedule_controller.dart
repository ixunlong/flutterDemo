import 'dart:developer';

import 'package:get/get.dart';
import 'package:sports/logic/match/match_all_controller.dart';
import 'package:sports/logic/match/match_begin_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/match_result_controller.dart';
import 'package:sports/logic/match/match_schedule_list_controller.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/constant.dart';

class MatchScheduleController extends GetxController
    implements MatchListProvider {
  SoccerMatchFilterController filter = Get.find<SoccerMatchFilterController>(
      tag: Constant.matchFilterTagSchedule);
  int index = 0;
  QuickFilter quickFilter = QuickFilter.all;
  bool hideBottom = false;
  int hideMatch = 0;
  @override
  void onInit() {
    super.onInit();
    if (Get.find<ConfigService>().soccerConfig.soccerInAppAlert7 == 1) {
      quickFilter = Get.find<MatchAllController>().quickFilter;
    }
  }

  void changeIndex(newIndex) {
    index = newIndex;

    try {
      //可能未初始化找不到controller
      final scheduleListController =
          Get.find<MatchScheduleListController>(tag: '$newIndex');
      filter.clear();
      filter.initLeague(MatchType.schedule);
      scheduleListController.filterMatch(filter.getHideLeagueIdList());
    } catch (e) {}
  }

  @override
  onSelectMatchType(QuickFilter type, {bool fromFilterPage = false}) {
    quickFilter = type;
    if (Get.find<ConfigService>().soccerConfig.soccerInAppAlert7 == 1) {
      try {
        Get.find<MatchBeginController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
      try {
        Get.find<MatchResultController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
      try {
        Get.find<MatchAllController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
    }
    if (!fromFilterPage) {
      filterOnMatchType(type);
    }
  }

  filterOnMatchType(QuickFilter type) {
    quickFilter = type;
    // filter.initLeague(MatchType.schedule);
    if (quickFilter == QuickFilter.all) {
      onSelectDefault();
    } else if (quickFilter == QuickFilter.yiji) {
      //一级
      filter.leagueType = LeagueType.all;
      filter.selectOneLevel();
      // listController.filterMatch(filter.hideLeagueId);
      // update();
    } else if (quickFilter == QuickFilter.jingcai) {
      //竞足
      // filter.updateLeague();
      filter.onSelectLeagueType(LeagueType.jz);
      // listController.filterMatch(filter.getHideLeagueIdList());
    } else if (quickFilter == QuickFilter.guandian) {
      onSelectDefault(type: quickFilter);
    } else if (quickFilter == QuickFilter.qingbao) {
      onSelectDefault(type: quickFilter);
    }
    // update();
    try {
      final listController =
          Get.find<MatchScheduleListController>(tag: '$index');
      if (quickFilter == QuickFilter.all) {
        listController.filterMatch(filter.hideLeagueId);
      } else {
        listController.filterMatch(filter.getHideLeagueIdList());
      }
    } catch (e) {
      log('$e');
    }
    update();
  }

  void onSelectDefault({QuickFilter type = QuickFilter.all}) {
    final listController = Get.find<MatchScheduleListController>(tag: '$index');
    quickFilter = type;
    filter.leagueType = LeagueType.all;
    filter.selectAll();
    filter.updateLeague();
    listController.filterMatch([]);
    update();
  }

  void onHideBottom() {
    hideBottom = true;
    update();
  }

  void onShowBottom() {
    hideBottom = false;
    update();
  }

  // String getMatchTypeImage() {
  //   String matchTypeImage = 'match_all.png';
  //   if (matchType == 1) {
  //     matchTypeImage = 'match_yiji.png';
  //   } else if (matchType == 2) {
  //     matchTypeImage = 'match_jingzu.png';
  //   }
  //   return matchTypeImage;
  // }

  @override
  bool firstLoad = false;

  @override
  Future doRefresh() {
    // TODO: implement doRefresh
    throw UnimplementedError();
  }

  @override
  Future getMatch() {
    // TODO: implement getMatch
    throw UnimplementedError();
  }

  @override
  String getTicketName(MatchEntity match) {
    // TODO: implement getTicketName
    throw UnimplementedError();
  }

  @override
  updateView() {
    // TODO: implement updateView
    throw UnimplementedError();
  }
}
