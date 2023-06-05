import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/team/basket_team_detail_entity.dart';
import 'package:sports/model/team/bb_team/bb_team_data_year_entity.dart';
import 'package:sports/view/team/basketball/basket_team_count_view.dart';
import 'package:sports/view/team/basketball/basket_team_info_view.dart';
import 'package:sports/view/team/basketball/basket_team_lineup_view.dart';
import 'package:sports/view/team/basketball/basket_team_schedule_view.dart';

class BasketTeamDetailController extends GetxController
    with GetTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  final _num = (-1.0).obs;
  int teamId = Get.arguments;
  double offset = 0.0;
  BasketTeamDetailEntity? data;
  List<BbTeamDataYearEntity>? year;
  List<String> tabs = [];
  List pages = [];
  late TabController tabController;
  final GlobalKey<ExtendedNestedScrollViewState> key =
  GlobalKey<ExtendedNestedScrollViewState>();

  double get num {
    if (_num < 0) {
      return 0.0;
    } else if (_num > 1) {
      return 1.0;
    } else {
      return _num.value;
    }
  }

  @override
  void onInit() async {
    await requestData();
    // getTeamYear();
    scrollController.addListener(() {
      setOffset(scrollController.offset);
      getOpacity();
    });
    super.onInit();
  }

  void getOpacity() {
    // log(offset.toString());
    _num.value = (offset - 50) / (108 - kToolbarHeight);
  }

  void setOffset(value) {
    offset = value;
    update();
  }

  Future requestData() async {
    final result = await Api.getBasketTeamDetail(teamId);
    if (result != null) {
      data = result;
      if (data?.national == 1) {
        tabs = ['资料', '赛程', '阵容'];
        pages = [
          BasketTeamInfoView(),
          BasketTeamScheduleView(),
          BasketTeamLineupView(),
        ];
      } else {
        tabs = ['资料', '赛程', '统计', '阵容'];
        pages = [
          BasketTeamInfoView(),
          BasketTeamScheduleView(),
          BasketTeamCountView(),
          BasketTeamLineupView(),
        ];
      }
      tabController =
          TabController(length: tabs.length, vsync: this, initialIndex: 1);
      update();
    }
  }

  // Future getTeamYear() async {
  //   final result = await Api.getBasketTeamDataYear(teamId);
  //   if (result != null) {
  //     year = result;
  //     // update();
  //   }
  // }

  // String? getRecentStatus() {
  //   return _data?.matchResult == null
  //       ? null
  //       : _data!.matchResult!
  //           .map((e) {
  //             if (e.resultStatus == 3) {
  //               return '胜';
  //             }
  //             if (e.resultStatus == 1) {
  //               return '平';
  //             }
  //             if (e.resultStatus == 0) {
  //               return '负';
  //             }
  //           })
  //           .toList()
  //           .join(' ');
  // }
}
