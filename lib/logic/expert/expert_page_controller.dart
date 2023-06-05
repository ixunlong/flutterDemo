import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/expert/expert_views_entity.dart';
import 'package:sports/model/home/lbt_entiry.dart';

import '../../model/expert/expert_idea_entity.dart';
import '../../model/expert/expert_top_entity.dart';
import '../../util/user.dart';
import '../../view/expert/expert_load_item.dart';

class ExpertPageController extends GetxController
    with GetTickerProviderStateMixin {
  int _mainIndex = 1; //专栏  方案
  int _viewIndex = 1;
  int _hotIndex = 0;

  bool _checkLogin = true;
  bool _visible = false;
  bool _columnVisible = false;
  bool _isLoading = true;
  bool _isTopLoading = true;
  bool _isColumnLoading = true;
  bool showBorder = false;
  List<LbtEntity>? _lbt;
  List<List<ExpertTopEntity>?> _expertTop = [[], []];
  List<ExpertIdeaEntity>? _columnData;
  ExpertViewsEntity? _focusList;
  // final List<String> _tabs = ['关注', '足球', '篮球', "免费", '命中', '盈利', '连红'];
  // final List<int> _tabId = [0, 1, 6, 5, 2, 3, 4];
  final List<String> _mainTabs = ['专栏', '方案'];
  final List<String> _columnTabs = ['全部专家', '已订阅'];
  final List<String> _tabs = ['关注', "免费", '命中', '盈利', '连红'];
  final List<int> _tabId = [0, 5, 2, 3, 4];
  late TabController _mainController;
  late TabController _viewController;
  late final TabController _hotController =
      TabController(length: 2, vsync: this);
  late ScrollController scrollController;
  late ScrollController columnScrollController;
  final EasyRefreshController _easyRefreshController =
      EasyRefreshController(controlFinishLoad: true);
  final EasyRefreshController _columnERController =
      EasyRefreshController(controlFinishLoad: true);
  final List<ExpertLoadItems> _pages =
      List.generate(5, (index) => ExpertLoadItems([], 0, 1, 15));
  final ExpertColumnPageItems _columnRows = ExpertColumnPageItems([], 0, 1, 15);

  bool get visible => _visible;
  bool get columnVisible => _columnVisible;
  bool get checkLogin => _checkLogin;
  bool get isLoading => _isLoading;
  bool get isTopLoading => _isTopLoading;
  bool get isColumnLoading => _isColumnLoading;
  int get viewIndex => _viewIndex;
  List<String> get mainTabs => _mainTabs;
  List<String> get tabs => _tabs;
  ExpertViewsEntity? get focusList => _focusList;
  List<ExpertLoadItems> get pages => _pages;
  List<ExpertIdeaEntity>? get columnData => _columnData;
  ExpertColumnPageItems get columnRows => _columnRows;
  TabController get mainController => _mainController;
  TabController get viewController => _viewController;
  TabController get hotController => _hotController;
  EasyRefreshController get easyRefreshController => _easyRefreshController;
  EasyRefreshController get columnERController => _columnERController;
  List<LbtEntity>? get lbt => _lbt;
  List<List<ExpertTopEntity>?> get expertTop => _expertTop;

  int get mainIndex => _mainIndex;

  set mainIndex(int value) {
    _mainIndex = value;
    update();
  }

  int get hotIndex => _hotIndex;

  set hotIndex(int value) {
    _hotIndex = value;
    update();
  }

  set viewIndex(int value) {
    _viewIndex = value;
    update();
  }

  set visible(info) {
    _visible = info;
    update();
  }

  set columnVisible(info) {
    _columnVisible = info;
    update();
  }

  @override
  void onInit() {
    _mainController =
        TabController(length: mainTabs.length, vsync: this, initialIndex: 1);
    _viewController =
        TabController(length: tabs.length, vsync: this, initialIndex: 1);
    _hotController.addListener(() {
      hotIndex = _hotController.index;
    });
    _viewController.addListener(() {
      viewIndex = _viewController.index;
    });
    _mainController.addListener(() {
      mainIndex = _mainController.index;
    });
    super.onInit();
  }

  void setPage(int index, value) {
    value == null ? _pages[index].page += 1 : _pages[index].page = value;
    update();
  }

  Future getViews(int index) async {
    List<Rows>? data;
    if (index == 0) {
      _focusList = await Api.getExpertFocusViews();
    } else {
      data = await Api.getExpertHotViews(
          _pages[index].page, _pages[index].pageSize, _tabId[index]);
      log(index.toString());
      if (data != null) {
        _pages[index].page == 1
            ? _pages[index].items = data
            : _pages[index].items.addAll(data);
      }
    }
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      _isLoading = false;
      update();
    });
    update();
  }

  Future getExpertTop() async {
    _expertTop[0] = await Api.getExpertTop(1);
    _expertTop[1] = await Api.getExpertTop(2);
    _isTopLoading = false;
    update();
  }

  Future getLbt() async {
    _lbt = await Api.getAppList("app_plan_lbt");
    update();
  }

  void setColumnPage(value) {
    value == null ? _columnRows.page += 1 : _columnRows.page = value;
    update();
  }

  Future getColumnData() async {
    List<ExpertIdeaEntity>? data =
        await Api.getIdeaExpertList(_columnRows.page, _columnRows.pageSize);
    if (data != null) {
      _columnRows.page == 1
          ? _columnRows.items = data
          : _columnRows.items.addAll(data);
      _columnData = _columnRows.items;
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        _isColumnLoading = false;
        update();
      });
      // update();
    }
  }

  Future doRefresh() async {
    _easyRefreshController.callRefresh(scrollController: scrollController);
    _columnERController.callRefresh(scrollController: columnScrollController);
    update();
  }

  Future isColumnLogin() async {
    if (_columnVisible) {
      _isColumnLoading = true;
      getColumnData();
    }
    update();
  }

  Future isLogin() async {
    if (_visible) {
      _checkLogin = User.isLogin;
      if (_checkLogin) {
        getViews(0);
      }
    }
  }

  List<List<Rows>> formFocus() {
    List<List<Rows>> list = [];
    if (_focusList?.rows?.length == 0 || _focusList?.rows?.length == null)
      return list;
    List<int> spot = [];
    var sportsId = _focusList!.rows![0].sportsId;
    var expertId = _focusList!.rows![0].expertId;
    for (var i = 0; i < _focusList!.rows!.length; i++) {
      if (_focusList!.rows![i].sportsId != sportsId ||
          _focusList!.rows![i].expertId != expertId) {
        spot.add(i);
        sportsId = _focusList!.rows![i].sportsId;
        expertId = _focusList!.rows![i].expertId;
      }
      ;
    }
    if (spot.length > 1) {
      list.add(_focusList!.rows!.sublist(0, spot[0]));
      list.addAll(List.generate(spot.length, (index) {
        if (index == spot.length - 1)
          return _focusList!.rows!.sublist(spot.last, _focusList!.rows!.length);
        return _focusList!.rows!.sublist(spot[index], spot[index + 1]);
      }));
    } else if (spot.length == 1) {
      list.add(_focusList!.rows!.sublist(0, spot[0]));
      list.add(_focusList!.rows!.sublist(spot[0], _focusList!.rows!.length));
    } else {
      list.add(_focusList!.rows!);
    }
    return list;
  }
}
