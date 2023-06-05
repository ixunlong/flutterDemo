import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/team/team_detail_entity.dart';

class SoccerTeamDetailController extends GetxController {
  ScrollController scrollController = ScrollController();
  final _num = (-1.0).obs;
  int teamId = Get.arguments;
  double offset = 0.0;
  TeamDetailEntity? _data;
  final GlobalKey<ExtendedNestedScrollViewState> key =
  GlobalKey<ExtendedNestedScrollViewState>();

  TeamDetailEntity? get data => _data;
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
    final data = await Api.getTeamDetail(teamId);
    if (data != null) {
      _data = data;
      update();
    }
  }

  String? getRecentStatus() {
    return _data?.matchResult == null
        ? null
        : _data!.matchResult!
            .map((e) {
              if (e.resultStatus == 3) {
                return '胜';
              }
              if (e.resultStatus == 1) {
                return '平';
              }
              if (e.resultStatus == 0) {
                return '负';
              }
            })
            .toList()
            .join(' ');
  }
}
