import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_detail_controller.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_detail_page.dart';

import '../../http/api.dart';
import '../../model/expert/expert_views_entity.dart';
import '../../util/user.dart';
import '../../view/expert/expert_load_item.dart';

class MatchViewsController extends GetxController {
  late final detail;
  late int sportsId;
  List<String> tabs = ["关注", "热门", "免费", "回报", "连红"];
  int _currentIndex = 1;
  bool _checkLogin = true;
  bool _visible = false;
  bool _isLoading = true;
  final List<ExpertLoadItems> _pages =
      List.generate(5, (index) => ExpertLoadItems([], 0, 1, 15));
  late TabController _tabController;
  final EasyRefreshController _easyRefreshController =
      EasyRefreshController(controlFinishLoad: true);

  bool get visible => _visible;
  bool get checkLogin => _checkLogin;
  bool get isLoading => _isLoading;
  EasyRefreshController get easyRefreshController => _easyRefreshController;
  List<ExpertLoadItems> get pages => _pages;
  TabController get tabController => _tabController;
  int get currentIndex => _currentIndex;

  @override
  void onInit() {
    try{
      detail = Get.find<SoccerMatchDetailController>(tag: '${Get.arguments}');
      sportsId = 1;
    }catch(e){
      detail = Get.find<BbDetailController>(tag: '${Get.arguments}');
      sportsId = 2;
    }
    update();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getViews(currentIndex);
  }

  void changeIndex(value) {
    _currentIndex = value;
    update();
  }

  void setTabController(value) {
    _tabController = value;
    update();
  }

  void setPage(int index, value) {
    value == null
        ? _pages[index].page += 1
        : _pages[index].page = value;
  }

  Future getViews(int index) async {
    ExpertViewsEntity? data;
    data = await Api.getMatchViews(detail.matchId.toString(),
      _pages[index].page, _pages[index].pageSize, index, sportsId);
    if (data?.rows != null) {
      _pages[index].total = data!.total!;
      _pages[index].page == 1
          ? _pages[index].items = data.rows!
          : _pages[index].items.addAll(data.rows!);
    }
    _isLoading = false;
    update();
  }

  Future isLogin() async {
    if (_visible) {
      if (_currentIndex == 0) {
        _checkLogin = User.isLogin;
      } else {
        _checkLogin = true;
      }
    }
    update();
  }

  void setVisible(info) {
    _visible = info;
    update();
  }
}
