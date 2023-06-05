import 'dart:developer';

import 'package:get/get.dart';
import 'package:sports/logic/match/match_all_controller.dart';
import 'package:sports/logic/match/match_begin_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/match/match_result_list_controller.dart';
import 'package:sports/logic/match/match_schedule_controller.dart';
import 'package:sports/logic/match/soccer_match_filter_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/constant.dart';

class MatchResultController extends GetxController {
  final filter =
      Get.find<SoccerMatchFilterController>(tag: Constant.matchFilterTagResult);
  QuickFilter quickFilter = QuickFilter.all;
  int index = 6;
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
    // final filter = Get.find<SoccerMatchFilterController>(
    //     tag: Constant.matchFilterTagResult);

    try {
      //可能未初始化找不到controller
      final scheduleListController =
          Get.find<MatchResultListController>(tag: '$newIndex');
      filter.clear();
      filter.initLeague(MatchType.end);
      scheduleListController.filterMatch(filter.getHideLeagueIdList());
    } catch (e) {}

    // filter.clear();
    // filter.updateLeague();
    // filterOnMatchType(matchType);
    // //切换页面后原页面重置
    // Future.delayed(Duration(seconds: 1)).then((value) {
    //   // scheduleListController.resetPage();

    //   final scheduleListController =
    //       Get.find<MatchResultListController>(tag: '$oldIndex');
    //   scheduleListController.filterMatch(filter.hideLeagueId);
    // });
  }

  onSelectMatchType(QuickFilter type, {bool fromFilterPage = false}) {
    quickFilter = type;
    if (Get.find<ConfigService>().soccerConfig.soccerInAppAlert7 == 1) {
      try {
        Get.find<MatchScheduleController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
      try {
        Get.find<MatchBeginController>().filterOnMatchType(type);
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
    // filter.initLeague(MatchType.end);
    if (quickFilter == QuickFilter.all) {
      onSelectDefault();
    } else if (quickFilter == QuickFilter.yiji) {
      //一级
      filter.leagueType = LeagueType.all;
      filter.selectOneLevel();
    } else if (quickFilter == QuickFilter.jingcai) {
      //竞足
      filter.onSelectLeagueType(LeagueType.jz);
    } else if (quickFilter == QuickFilter.guandian) {
      onSelectDefault(type: quickFilter);
    } else if (quickFilter == QuickFilter.qingbao) {
      onSelectDefault(type: quickFilter);
    }
    try {
      final listController = Get.find<MatchResultListController>(tag: '$index');
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
    final listController = Get.find<MatchResultListController>(tag: '$index');
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
}
