import 'dart:developer';

import 'package:get/get.dart';
import 'package:sports/logic/match/basket_list_all_controller.dart';
import 'package:sports/logic/match/basket_list_begin_controller.dart';
import 'package:sports/logic/match/basket_list_endview_controller.dart';
import 'package:sports/logic/match/basket_list_schedule_controller.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/logic/service/config_service.dart';
import 'package:sports/res/constant.dart';

class BasketListEndController extends GetxController {
  final filter =
      Get.find<BasketMatchFilterController>(tag: Constant.matchFilterTagResult);
  //012 全部 一级 竞足
  QuickFilter quickFilter = QuickFilter.all;
  int index = 6;
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
          Get.find<BasketListEndViewController>(tag: '$newIndex');
      filter.clear();
      filter.initLeague(MatchType.end);
      scheduleListController.filterMatch(filter.getHideLeagueIdList());
    } catch (e) {}
    // filter.updateLeague();
    // //切换页面后原页面重置
    // Future.delayed(Duration(seconds: 1)).then((value) {
    //   // scheduleListController.resetPage();

    //   final scheduleListController =
    //       Get.find<BasketListEndViewController>(tag: '$oldIndex');
    //   scheduleListController.filterMatch(filter.hideLeagueId);
    // });
  }

  onSelectMatchType(QuickFilter type, {bool fromFilterPage = false}) {
    quickFilter = type;
    if (Get.find<ConfigService>().basketConfig.basketInAppAlert4 == 1) {
      try {
        Get.find<BasketListScheduleController>().filterOnMatchType(type);
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
    // filter.initLeague(MatchType.end);
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
    try {
      final listController =
          Get.find<BasketListEndViewController>(tag: '$index');
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
    final listController = Get.find<BasketListEndViewController>(tag: '$index');
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
