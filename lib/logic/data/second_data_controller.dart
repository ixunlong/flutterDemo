import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/data/league_channel_entity.dart';

import '../../widgets/cupertino_picker_widget.dart';

class SecondDataController extends GetxController {
  final ScrollController _scrollController = ScrollController();
  List typeList = ["积分", "赛程", "球员", "球队"];
  // List typeList = ["积分", "赛程", "球员", "球队", "转会"];

  LeagueChannelEntity? _entity;
  final double _expendedHeight = kToolbarHeight + 80 + 16 * 2 + 4 + 10;
  double _offset = 0.0;
  bool isLoading = true;
  int random = Random().nextInt(10000000);
  final _num = (-1.0).obs;
  PageController pageController = PageController();
  String currentSeason = "";
  int currentLeagueId = 0;
  int _seasonIndex = 0;
  int _typeIndex = 0;
  late List<Widget> page;

  int get seasonIndex => _seasonIndex;
  int get typeIndex => _typeIndex;
  double get num {
    if (_num < 0) {
      return 0.0;
    } else if (_num > 1) {
      return 1.0;
    } else {
      return _num.value;
    }
  }

  String get progress {
    if (_entity?.progress != null) {
      if (_entity!.progress! > 100) {
        return "赛季已结束\u2000";
      } else if (_entity!.progress! <= 0) {
        return "赛季未开始\u2000";
      } else {
        return "${_entity!.progress}%";
      }
    }
    return "";
  }

  double get expendedHeight => _expendedHeight;
  LeagueChannelEntity? get entity => _entity;
  ScrollController get scrollController => _scrollController;

  @override
  void onInit() async {
    await requestData();
    _scrollController.addListener(() {
      setOffset(scrollController.offset);
      getOpacity();
      update();
    });
    super.onInit();
  }

  void setOffset(value) {
    _offset = value;
    update();
  }

  void getOpacity() {
    _num.value = (_offset - kToolbarHeight) /
        (_expendedHeight - kToolbarHeight * 2 - 20);
    update();
  }

  Future requestData() async {
    _entity = await Api.getLeague(Get.arguments);
    _typeIndex = 0;
    currentSeason = _entity?.seasonList?[_seasonIndex] ?? "";
    currentLeagueId = _entity?.leagueId ?? 0;
    isLoading = false;
    update();
  }

  void setIndex(value) {
    _typeIndex = value;
    update();
  }

  Future showDatePicker() async {
    _seasonIndex = await Get.bottomSheet(CupertinoPickerWidget(
      _entity?.seasonList
              ?.map((e) => e.length > 4
                  ? ("${e.substring(2, 4)}/${e.substring(7, 9)}")
                  : e)
              .toList() ??
          [],
      title: '选择赛季',
      initialIndex: _seasonIndex,
    ));
    currentSeason = _entity?.seasonList?[_seasonIndex] ?? "";
    update();
  }
}
