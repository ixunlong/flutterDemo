import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/basket_list_all_controller.dart';
import 'package:sports/logic/match/basket_list_begin_controller.dart';
import 'package:sports/logic/match/basket_list_end_controller.dart';
import 'package:sports/logic/match/basket_list_endview_controller.dart';
import 'package:sports/logic/match/basket_list_focus_controller.dart';
import 'package:sports/logic/match/basket_list_schedule_controller.dart';
import 'package:sports/logic/match/basket_list_scheduleview_controller.dart';
import 'package:sports/logic/match/match_all_controller.dart';
import 'package:sports/logic/match/match_begin_controller.dart';
import 'package:sports/logic/match/match_interest_controller.dart';
import 'package:sports/logic/match/match_result_controller.dart';
import 'package:sports/logic/match/match_result_list_controller.dart';
import 'package:sports/logic/match/match_schedule_controller.dart';
import 'package:sports/logic/match/match_schedule_list_controller.dart';
import 'package:sports/model/match/match_entity.dart';

enum QuickFilter { all, yiji, jingcai, guandian, qingbao }

//全部  赛中， 赛程， 赛果， 关注
enum MatchTabPageStatus { all, live, schedule, result, follow }

extension QuickFilterExtension on QuickFilter {
  String convertString(int type) {
    if (this == QuickFilter.yiji) {
      return "一级";
    } else if (this == QuickFilter.jingcai) {
      return type == 0 ? '竞足' : '竞篮';
    } else if (this == QuickFilter.guandian) {
      return "观点";
    } else if (this == QuickFilter.qingbao) {
      return "情报";
    }
    return "全部";
  }
}

abstract class MatchListProvider {
  // List<MatchEntity> originalData;
  bool firstLoad = true;
  //012 全部 一级 竞足 观点 情报
  QuickFilter quickFilter = QuickFilter.all;

  Future getMatch();
  Future doRefresh();
  // bool stopRefresh();
  updateView();
  String getTicketName(MatchEntity match);
  onSelectMatchType(QuickFilter index);
  // String getBasketTicketName(BasketListEntity match);
}

// abstract class BasketMatchListProvider {
//   // List<MatchEntity> originalData;
//   Future getMatch();
//   Future doRefresh();
//   // bool stopRefresh();
//   updateView();
//   String getTicketName(BasketListEntity match);
// }

class MatchPageController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController footballController;
  late TabController basketballController;
  final List<String> tabs = [
    '全部',
    '赛中',
    '赛程',
    '赛果',
    '关注',
  ];
  int headIndex = 0;
  int soccerIndex = MatchTabPageStatus.all.index;
  int basketIndex = MatchTabPageStatus.all.index;
  MatchPageController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    footballController = TabController(
        length: tabs.length,
        vsync: this,
        initialIndex: MatchTabPageStatus.all.index);
    basketballController = TabController(
        length: tabs.length,
        vsync: this,
        initialIndex: MatchTabPageStatus.all.index);
  }

  changeIndex(int index) {
    if (headIndex == 0) {
      soccerIndex = index;
    } else {
      basketIndex = index;
    }
  }

  changeMatchIndex(int index) {
    if (headIndex == 0) {
      footballController.animateTo(index);
    } else {
      basketballController.animateTo(index);
    }
    changeIndex(index);
  }

  MatchListProvider getMatchController() {
    MatchListProvider? controller;
    if (headIndex == 0) {
      if (soccerIndex == MatchTabPageStatus.follow.index) {
        controller = Get.find<MatchInterestController>();
      } else if (soccerIndex == MatchTabPageStatus.all.index) {
        controller = Get.find<MatchAllController>();
      } else if (soccerIndex == MatchTabPageStatus.live.index) {
        controller = Get.find<MatchBeginController>();
      } else if (soccerIndex == MatchTabPageStatus.schedule.index) {
        final index = Get.find<MatchScheduleController>().index;
        controller = Get.find<MatchScheduleListController>(tag: '$index');
      } else if (soccerIndex == MatchTabPageStatus.result.index) {
        final index = Get.find<MatchResultController>().index;
        controller = Get.find<MatchResultListController>(tag: '$index');
      }
    } else {
      if (basketIndex == MatchTabPageStatus.follow.index) {
        controller = Get.find<BasketListFocusController>();
      } else if (basketIndex == MatchTabPageStatus.all.index) {
        controller = Get.find<BasketListAllController>();
      } else if (basketIndex == MatchTabPageStatus.live.index) {
        controller = Get.find<BasketListBeginController>();
      } else if (basketIndex == MatchTabPageStatus.schedule.index) {
        final index = Get.find<BasketListScheduleController>().index;
        controller = Get.find<BasketListScheduleViewController>(tag: '$index');
      } else if (basketIndex == MatchTabPageStatus.result.index) {
        final index = Get.find<BasketListEndController>().index;
        controller = Get.find<BasketListEndViewController>(tag: '$index');
      }
    }

    return controller!;
  }
}
