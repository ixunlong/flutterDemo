import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/util/user.dart';
import 'package:sports/util/utils.dart';

import '../../model/expert/expert_detail_entity.dart';
import '../../model/expert/expert_focus_entity.dart';
import '../../model/expert/expert_idea_list_entity.dart';
import '../../model/expert/expert_views_entity.dart';
import '../../res/colours.dart';
import '../../view/expert/expert_load_item.dart';

enum ExpertDetailTabContentType {
  //足球  篮球  专栏
  football,
  basketball,
  ideaColumn
}

class ExpertDetailPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  int _tabIndex = 0;
  final List<String> _recordTypeList = ["当前状态", "近n场回报", "最高连红"];
  late List<Map<String, dynamic>> _tabTexts = []; //足球  篮球  专栏
  late final TabController tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: int.parse(Get.parameters['index']!));
  final List<ExpertLoadItems> _pages =
      List.generate(2, (index) => ExpertLoadItems([], 0, 1, 15));
  final ExpertIdeaPageItems _ideaList = ExpertIdeaPageItems([], 0, 1, 15);
  final EasyRefreshController _easyRefreshController =
      EasyRefreshController(controlFinishLoad: true);
  double _expendedHeight = 0.0;
  double _infoHeight = 0.0;
  double _offset = 0.0;
  bool _isFocus = false;
  bool _isLoading = true;
  bool _isShowIdea = true; //默认显示专栏
  final _num = (-1.0).obs;
  ExpertDetailEntity? _entity;
  List<Record> _record = [Record(), Record()];
  List<List<Rows>?> _newViews = [[], []];

  final List<Color> _colorList = [
    Colours.white,
    Colours.main_color,
    Colours.grey666666,
    Colours.grey_color1,
    Colours.guestColorBlue,
    Colours.orangeFF6E1D,
    Colours.orangeFF6E1D,
    Colours.orangeFF6E1D
  ];
  final List<String> _textList = [
    "未开",
    "红",
    "黑",
    "取消",
    "走",
    "1/2",
    "1/3",
    "2/3"
  ];

  double get num {
    if (_num < 0) {
      return 0.0;
    } else if (_num > 1) {
      return 1.0;
    } else {
      return _num.value;
    }
  }

  List<List<Rows>?> get newViews => _newViews;
  List<Record> get record => _record;
  List<Color> get colorList => _colorList;
  List<String> get textList => _textList;

  bool get isLoading => _isLoading;
  bool get isShowIdea => _isShowIdea;
  List<ExpertLoadItems> get pages => _pages;
  ExpertIdeaPageItems get ideaList => _ideaList;
  double get expendedHeight => _expendedHeight;
  double get infoHeight => _infoHeight;
  EasyRefreshController get easyRefreshController => _easyRefreshController;
  List<String> get recordTypeList => _recordTypeList;
  bool get isFocus => _isFocus;
  ExpertDetailEntity? get entity => _entity;
  ScrollController get scrollController => _scrollController;
  int get tabIndex => _tabIndex;

  set tabIndex(int value) {
    _tabIndex = value;
    update();
  }

  List<Map<String, dynamic>> get tabTexts {
    _tabTexts = [];
    if (_entity?.isShowFb == 1) {
      Map<String, dynamic> tab = {
        'title': '足球方案',
        'type': ExpertDetailTabContentType.football,
      };
      _tabTexts.add(tab);
    }
    if (_entity?.isShowBb == 1) {
      Map<String, dynamic> tab = {
        'title': '篮球方案',
        'type': ExpertDetailTabContentType.basketball,
      };
      _tabTexts.add(tab);
    }
    if (_isShowIdea) {
      Map<String, dynamic> tab = {
        'title': 'Ta的专栏',
        'type': ExpertDetailTabContentType.ideaColumn,
      };
      _tabTexts.add(tab);
    }
    return _tabTexts;
  }

  //是否显示专栏
  set isShowIdea(bool value) {
    _isShowIdea = value;
  }

  @override
  void onInit() {
    _scrollController = ScrollController();
    scrollController.addListener(() {
      setOffset(scrollController.offset);
      getOpacity();
      update();
    });
    super.onInit();
  }

  Future checkFocus() async {
    if (User.auth?.userId != null) {
      ExpertFocusEntity? data = await Api.expertFocusList(1, 100);
      if (data != null) {
        for (var element in data.contents!) {
          if (element.id == _entity?.id) {
            _isFocus = true;
            break;
          } else {
            _isFocus = false;
          }
        }
        update();
      } else {
        _isFocus = false;
      }
    }
  }

  Future setFocus(bool value) async {
    if (entity == null) {
      return;
    }
    if (_isFocus) {
      final result = await Utils.alertQuery('确认不再关注');
      if (result == true) {
        Utils.onEvent('zjzy_gz', params: {'zjzy_gz': '0'});
        await Api.expertUnfocus(_entity!.id!);
        await checkFocus();
      }
    } else {
      Utils.onEvent('zjzy_gz', params: {'zjzy_gz': '1'});
      await Api.expertFocus(_entity!.id!);
      await checkFocus();
    }
    update();
  }

  void setPage(value) {
    value == null
        ? _pages[_tabIndex].page += 1
        : _pages[_tabIndex].page = value;
  }

  bool isIdeaColumn(int index) {
    if (tabTexts.isEmpty) {
      return false;
    }
    if (index >= tabTexts.length) {
      return false;
    }
    Map<String, dynamic> map = tabTexts[index];
    if (map.containsKey("type")) {
      if (map['type'] == ExpertDetailTabContentType.ideaColumn) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future getViews(String id, int index) async {
    if (isIdeaColumn(index)) {
      getExpertIdeaList(id);
    } else {
      ExpertViewsEntity? data;
      data = await Api.getExpertHistoryViews(
          id, _pages[index].page, _pages[index].pageSize, index + 1);
      if (data?.rows != null) {
        _pages[index].total = data!.total!;
        _pages[index].page == 1
            ? _pages[index].items = data.rows!
            : _pages[index].items.addAll(data.rows!);
      }
    }
    update();
  }

  String filterText(String text) {
    String tag = '</br>';
    while (text.contains('</br>')) {
      text = text.replaceAll(tag, '\n\n');
    }
    return text;
  }

  bool isDataOutOfRange(int index) {
    if (isIdeaColumn(index)) {
      return true;
    } else {
      return _pages[index].items.length <
          _pages[index].page * _pages[index].pageSize;
    }
  }

  double textHeight() {
    var text = strReform(entity?.info ?? "该专家还未填写简介");
    TextPainter painter = TextPainter(
        textDirection: TextDirection.ltr,
        locale: const Locale('zh', 'CN'),
        textWidthBasis: TextWidthBasis.longestLine,
        maxLines: 3,
        text: TextSpan(
            text: filterText(text),
            style: const TextStyle(fontSize: 13, color: Colours.white)));
    painter.layout(maxWidth: Get.width - 32);
    return painter.height;
  }

  void setOffset(value) {
    _offset = value;
    update();
  }

  void getOpacity() {
    _infoHeight = (50 + 16 + textHeight() + 20);
    _expendedHeight = kToolbarHeight + _infoHeight;
    _num.value = (_offset - kToolbarHeight) /
        (_expendedHeight - kToolbarHeight * 2 - 20);
    update();
  }

  Future getExpertDetail(id) async {
    _entity = await Api.getExpertDetail(id);
    if (_entity?.fbDetail != null) _record[0] = _entity!.fbDetail!;
    if (_entity?.bbDetail != null) _record[1] = _entity!.bbDetail!;
    _newViews[0] = await Api.getExpertNewViews(id, 1);
    _newViews[1] = await Api.getExpertNewViews(id, 2);
    getExpertIdeaList(id);
    getOpacity();
    await checkFocus();
    for (int i = 0; i < _pages.length; i++) {
      await getViews(id, i);
    }

    if ((_entity?.isShowFb ?? 0) + (_entity?.isShowBb ?? 0) == 1 &&
        _entity?.isShowBb == 1) {
      tabController.animateTo(1);
    }
    _isLoading = false;
    update();
  }

//TODO: 专家方案 默认配置
  Future getExpertIdeaList(id) async {
    // ExpertIdeaListEntity? data = await Api.getExpertIdeaList(id, 1, 15);
    // if (data != null) {
    List<ExpertIdeaListRows> list = [
      ExpertIdeaListRows(
          id: 3,
          img: "sss.cn",
          imgType: 2,
          title: "示例1",
          summary: "示例内容多一些看看折行怎么样示例内容多一些看看折行怎么样示例内容多一些看看折行怎么样",
          uv: 100,
          endTime: "2023-06-16 00:00:00",
          expertId: "23",
          publishTime: "2023-06-01 00:00:00"),
      ExpertIdeaListRows(
          id: 4,
          img: "sss.cn",
          imgType: 1,
          title: "示例2",
          summary: "示例内容多一些看看折行怎么样示例内容多一些看看折行怎么样示例内容多一些看看折行怎么样",
          uv: 10,
          endTime: "2023-06-16 00:00:00",
          expertId: "23",
          publishTime: "2023-06-01 00:00:00"),
      ExpertIdeaListRows(
          id: 5,
          img: "sss.cn",
          imgType: 0,
          title: "示例3",
          summary: "示例内容多一些看看折行怎么样示例内容多一些看看折行怎么样示例内容多一些看看折行怎么样",
          uv: 1320,
          endTime: "2023-06-16 00:00:00",
          expertId: "23",
          publishTime: "2023-06-01 00:00:00"),
    ];
    _ideaList.items?.clear();
    _ideaList.items?.addAll(list);
    // update();
    // }
  }

  String strReform(String str) {
    return utf8.decode(utf8.encode(str), allowMalformed: true);
  }
}
