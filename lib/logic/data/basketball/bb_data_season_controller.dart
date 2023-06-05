import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/data/basket/basket_season_entity.dart';
import 'package:sports/view/data/basketball/bb_data_points_page.dart';
import 'package:sports/view/data/basketball/bb_data_schedule_page.dart';

import '../../../view/data/basketball/bb_data_player_page.dart';
import '../../../view/data/basketball/bb_data_team_page.dart';
import '../../../widgets/cupertino_picker_widget.dart';

class BbDataSeasonController extends GetxController {
  List typeList = ["积分", "赛程", "球员", "球队"];
  List<String> umengList = ["赛季选择", "积分", "赛程", "球员", "球队"];
  //   List typeList = ["积分", "赛程", "球员", "球队", "转会"];
  // List<String> umengList = ["赛季选择","积分", "赛程", "球员", "球队", "转会"];
  PageController pageController = PageController();
  int currentSeason = 0;
  String season = '';
  List<BasketSeasonEntity> seasonList = [];
  int currentLeagueId = 0;
  int _seasonIndex = 0;
  int _typeIndex = 0;
  bool isLoading = true;
  List<Widget> page = [];
  int get seasonIndex => _seasonIndex;
  int get typeIndex => _typeIndex;

  void setIndex(value) {
    _typeIndex = value;
    update();
  }

  Future request(int? id, String tag) async {
    seasonList = await Api.getBasketSeason(id!) ?? [];
    if (seasonList.isNotEmpty) await getData(id, tag);
    isLoading = false;
    update();
  }

  Future getData(int? id, String tag) async {
    _typeIndex = 0;
    currentSeason = seasonList[_seasonIndex].seasonId ?? 0;
    season = seasonList[_seasonIndex].seasonYear ?? "";
    currentLeagueId = id ?? 0;
    page = [
      BbDataPointsPage(leagueId: currentLeagueId, tag: tag),
      BbDataSchedulePage(leagueId: currentLeagueId, tag: tag),
      BbDataPlayerPage(currentLeagueId, tag: tag),
      BbDataTeamPage(currentLeagueId, tag: tag),
    ];
    typeList = ["积分", "赛程", "球员", "球队"];
    update();
  }

  Future showDatePicker() async {
    _seasonIndex = await Get.bottomSheet(CupertinoPickerWidget(
      seasonList
          .map((e) => season.length > 4
              ? ("${season.substring(2, 4)}/${season.substring(7, 9)}")
              : season)
          .toList(),
      title: '选择赛季',
      initialIndex: _seasonIndex,
    ));
    season = seasonList[_seasonIndex].seasonYear.toString();
    update();
  }
}
