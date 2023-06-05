import 'dart:developer';

import 'package:get/get.dart';
import 'package:sports/logic/match/basket_list_all_controller.dart';
import 'package:sports/logic/match/basket_list_begin_controller.dart';
import 'package:sports/logic/match/basket_list_end_controller.dart';
import 'package:sports/logic/match/basket_list_scheduleview_controller.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/constant.dart';

class BasketListScheduleController extends GetxController {
  BasketMatchFilterController filter = Get.find<BasketMatchFilterController>(
      tag: Constant.matchFilterTagSchedule);
  int index = 0;
  //012 全部 一级 竞足
  QuickFilter quickFilter = QuickFilter.all;
  bool hideBottom = false;
  int hideMatch = 0;

  @override
  void onInit() {
    super.onInit();
    if (Get.find<ConfigService>().basketConfig.basketInAppAlert4 == 1) {
      quickFilter = Get.find<BasketListAllController>().quickFilter;
    }
  }

  void changeIndex(newIndex) {
    index = newIndex;

    try {
      final scheduleListController =
          Get.find<BasketListScheduleViewController>(tag: '$newIndex');
      filter.clear();
      filter.initLeague(MatchType.schedule);
      scheduleListController.filterMatch(filter.getHideLeagueIdList());
    } catch (e) {}

    // filter.updateLeague();

    // matchType = 0;
    // update();
  }

  onSelectMatchType(QuickFilter type, {bool fromFilterPage = false}) {
    quickFilter = type;
    if (Get.find<ConfigService>().basketConfig.basketInAppAlert4 == 1) {
      try {
        Get.find<BasketListEndController>().filterOnMatchType(type);
      } catch (e) {
        log(e.toString());
      }
      try {
        Get.find<BasketListAllController>().filterOnMatchType(type);
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

  filterOnMatchType(QuickFilter type) {
    quickFilter = type;
    // filter.initLeague(MatchType.schedule);
    if (quickFilter == QuickFilter.all) {
      onSelectDefault();
    } else if (quickFilter == QuickFilter.yiji) {
      //一级
      filter.leagueType = LeagueType.all;
      filter.selectOneLevel();
    } else if (quickFilter == QuickFilter.jingcai) {
      //竞足
      filter.onSelectLeagueType(LeagueType.jc);
    } else if (quickFilter == QuickFilter.guandian) {
      onSelectDefault(type: quickFilter);
    } else if (quickFilter == QuickFilter.qingbao) {
      onSelectDefault(type: quickFilter);
    }
    // update();
    try {
      final listController =
          Get.find<BasketListScheduleViewController>(tag: '$index');
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
    final listController =
        Get.find<BasketListScheduleViewController>(tag: '$index');
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
