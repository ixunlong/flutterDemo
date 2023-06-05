import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/match/basket_match_filter_controller.dart';
import 'package:sports/logic/match/match_page_controller.dart';
import 'package:sports/model/match/basket_list_entity.dart';
import 'package:sports/model/match/match_entity.dart';
import 'package:sports/res/routes.dart';
import 'package:sports/util/sp_utils.dart';
import 'package:sports/widgets/common_dialog.dart';

import '../../res/constant.dart';
import '../../util/date_utils_extension.dart';
import '../../util/user.dart';

class BasketListFocusController extends GetxController
    implements MatchListProvider {
  final EasyRefreshController refreshController = EasyRefreshController();
  final filter =
      Get.find<BasketMatchFilterController>(tag: Constant.matchFilterTagFocus);
  final autoScrollController =
      AutoScrollController(axis: Axis.vertical, suggestedRowHeight: 105);
  List<BasketListEntity> _originalData = [];
  List<DateTime>? _dateList;
  List _groupListData = [];
  bool hideBottom = false;
  bool _visible = false;
  bool _checkLogin = false;
  @override
  QuickFilter quickFilter = QuickFilter.all;
  @override
  bool firstLoad = true;

  bool get checkLogin => _checkLogin;
  bool get visible => _visible;
  List<BasketListEntity> get originalData => _originalData;
  List<DateTime>? get dateList => _dateList;
  List get groupListData => _groupListData;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  updateView() {
    update();
  }

  @override
  void onReady() async {
    super.onReady();
    getMatch(firstGet: true);
    // if (User.isLogin) {
    //   var showFocusTeam = SpUtils.showFocusTeam;
    //   if (showFocusTeam != true) {
    //     // showFocusTeam = true;
    //     SpUtils.showFocusTeam = true;
    //     final result = await Get.dialog(CommonDialog.alert(
    //       '关注喜欢的球队',
    //       content: '已关注球队的近期比赛，会自动添加至关注频道。',
    //       confirmText: '去关注',
    //       cancelText: '我知道了',
    //     ));
    //     if (result == true) {
    //       Get.toNamed(Routes.selectFocusTeam);
    //       // getNew();
    //     }
    //   }
    // }

    // User.needLogin(() => getMatch());
  }

  @override
  Future getMatch({bool firstGet = false}) async {
    if (!User.isLogin) {
      return;
    }
    List<BasketListEntity>? matchList = await Api.getBasketMatchFocus();
    firstLoad = false;
    if (matchList != null) {
      _originalData = matchList;
      filterMatch(filter.getHideLeagueIdList());
    }
    // Future.delayed(
    //     Duration(seconds: 1), Get.find<NavigationController>().stopVGA);
    update();
    if (firstGet) {
      Future.delayed(const Duration(seconds: 1)).then((value) =>
          autoScrollController.scrollToIndex(getLeastAnchor(),
              preferPosition: AutoScrollPosition.begin));
    }
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
    groupMatchListTemp.add(sameDayMatchList);

    _dateList = dateListTemp;
    // _groupMatchList = groupMatchListTemp;

    List groupListDataTemp = [];
    for (int i = 0; i < dateListTemp.length; i++) {
      for (var match in groupMatchListTemp[i]) {
        String time;
        if (DateUtils.isSameDay(dateListTemp[i], DateTime.now())) {
          time = '今天 ${DateFormat.E('zh_cn').format(dateListTemp[i])}';
        } else {
          time =
              '${DateUtilsExtension.formatDateTime(dateListTemp[i], 'MM/dd')} ${DateFormat.E('zh_cn').format(dateListTemp[i])}';
        }
        groupListDataTemp.add({'match': match, 'group': time});
      }
    }
    _groupListData = groupListDataTemp;
    update();
  }

  void filterMatch(List<int> hideLeagueId) {
    List<BasketListEntity> matchList = [];
    for (var match in _originalData) {
      // if (quickFilter == QuickFilter.guandian && match.planCnt == 0) {
      //   continue;
      // } else
      if (quickFilter == QuickFilter.qingbao && match.intelligence == 0) {
        continue;
      }
      if (!hideLeagueId.contains(match.leagueId)) {
        if (filter.leagueType == LeagueType.jc && match.jcNo != null) {
          matchList.add(match);
        } else if (filter.leagueType == LeagueType.all ||
            filter.leagueType == LeagueType.rm) {
          matchList.add(match);
        }
      }
    }
    handleData(matchList);
  }

  // @override
  // onSelectMatchType() {
  //   filter.initLeague(MatchType.focus);
  //   if (matchType == 0) {
  //     //一级
  //     matchType = 1;
  //     filter.leagueType = LeagueType.all;
  //     filter.selectOneLevel();
  //     filterMatch(filter.hideLeagueId);
  //     // update();
  //   } else if (matchType == 1) {
  //     //竞足
  //     matchType = 2;
  //     // filter.leagueType = LeagueType.jz;
  //     // filter.updateLeague();
  //     filter.onSelectLeagueType(LeagueType.jc);
  //     filterMatch(filter.getHideLeagueIdList());
  //   } else {
  //     onSelectDefault();
  //   }
  // }

  void onSelectDefault() {
    quickFilter = QuickFilter.all;
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

  //找距离两小时前最近的比赛
  int getLeastAnchor() {
    var index = -1;
    final date = DateTime.now().subtract(Duration(hours: 2));
    int interval = -1;
    for (int i = 0; i < originalData.length; i++) {
      BasketListEntity match = originalData[i];
      final matchDate = DateTime.parse(match.matchTime!);
      if (interval == -1) {
        interval = date.difference(matchDate).inMinutes.abs();
      } else if (date.difference(matchDate).inMinutes.abs() < interval) {
        interval = date.difference(matchDate).inMinutes.abs();
        index = i;
      }
    }
    // int index = groupListData.lastIndexWhere((element) {
    //   BasketListEntity match = element['match'];
    //   return match.anchors == 1;
    // });
    return index == -1 ? 0 : index;
  }

  @override
  Future doRefresh() async {
    refreshController.callRefresh();
  }

  // @override
  // String getTicketName(BasketListEntity match) {
  //   String name = '';
  //   if (filter.leagueType == LeagueType.jc) {
  //     name = match.jcMatchNo ?? '';
  //   }
  //   return name;
  // }

  void setVisible(info) {
    _visible = info;
    update();
  }

  bool isLogin() {
    if (visible) {
      _checkLogin = User.isLogin;
    }
    update();
    return _checkLogin;
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
