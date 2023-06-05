import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/model/data/league_channel_entity.dart';

import '../../view/data/data_player_page.dart';
import '../../view/data/data_points_page.dart';
import '../../view/data/data_schedule_page.dart';
import '../../view/data/data_team_page.dart';
import '../../view/data/data_transfer_page.dart';
import '../../widgets/cupertino_picker_widget.dart';

class DataSeasonController extends GetxController {
  // List typeList = ["积分", "赛程", "球员", "球队", "转会"];
  // List<String> umengList = ["赛季选择","积分", "赛程", "球员", "球队", "转会"];
  List typeList = ["积分", "赛程", "球员", "球队"];
  List<String> umengList = ["赛季选择", "积分", "赛程", "球员", "球队"];
  PageController pageController = PageController();
  late LeagueChannelEntity? data;
  String currentSeason = "";
  int currentLeagueId = 0;
  int _seasonIndex = 0;
  int _typeIndex = 0;
  bool isLoading = true;
  late List<Widget> page;
  int get seasonIndex => _seasonIndex;
  int get typeIndex => _typeIndex;

  void setIndex(value) {
    _typeIndex = value;
    update();
  }

  Future getData(LeagueChannelEntity? value, String tag) async {
    page = [];
    _typeIndex = 0;
    data = value;
    currentSeason = data?.seasonList?[_seasonIndex] ?? "";
    currentLeagueId = data?.leagueId ?? 0;
    if (data?.transfer == 1) {
      page = [
        DataPointsPage(leagueId: currentLeagueId, tag: tag),
        DataSchedulePage(leagueId: currentLeagueId, tag: tag),
        DataPlayerPage(currentLeagueId, tag: tag),
        DataTeamPage(currentLeagueId, tag: tag),
      ];
      typeList = ["积分", "赛程", "球员", "球队"];
    } else {
      page = [
        DataPointsPage(leagueId: currentLeagueId, tag: tag),
        DataSchedulePage(leagueId: currentLeagueId, tag: tag),
        DataPlayerPage(currentLeagueId, tag: tag),
        DataTeamPage(currentLeagueId, tag: tag)
      ];
      typeList = ["积分", "赛程", "球员", "球队"];
    }
    // await initPageController();
    isLoading = false;
    update();
  }

  Future showDatePicker() async {
    _seasonIndex = await Get.bottomSheet(CupertinoPickerWidget(
      data?.seasonList
              ?.map((e) => e.length > 4
                  ? ("${e.substring(2, 4)}/${e.substring(7, 9)}")
                  : e)
              .toList() ??
          [],
      title: '选择赛季',
      initialIndex: _seasonIndex,
    ));
    currentSeason = data?.seasonList?[_seasonIndex] ?? "";
    update();
  }
}
