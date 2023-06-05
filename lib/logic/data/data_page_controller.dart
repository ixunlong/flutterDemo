import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/util/user.dart';
import 'package:sports/view/data/basketball/bb_season_page.dart';
import 'package:sports/view/data/data_rank_page.dart';
import 'package:sports/view/data/season_page.dart';

import '../../model/data/league_channel_entity.dart';

class DataPageController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  late TabController headTabController =
      TabController(length: 2, vsync: this, initialIndex: 1);
  List<LeagueChannelEntity>? _data;
  // List<Widget> tabs = [Text("FIFA俱乐部"),Text("FIFA国家队"),Text("FIBA国家队"),Text("NBA"),Text("CBA")];
  List<Widget> tabs = [];
  List tabId = [1, 3];
  bool isLoading = true;
  int currentHeadIndex = 1;
  bool login = User.isLogin;
  int? result;
  List<Widget> seasonPage = [];
  List<LeagueChannelEntity>? old;
  List<LeagueChannelEntity>? get data => _data;

  @override
  void onInit() async {
    await requestData();
    old = _data;
    tabs.addAll(_data?.map((e) => Text(e.leagueName ?? "")).toList() ?? []);
    seasonPage.addAll(List.generate(tabs.length, (index) {
      // if (index ==0) {
      //   return DataRankPage(tag: "俱乐部");
      // } else if(index == 1){
      //   return DataRankPage(tag: "国家队");
      // } else if(index == 2){
      //   return DataRankPage(tag: "篮球");
      // } else if(index >= 3 && index < 5){
      //   return BbSeasonPage(id: tabId[index - 3]);
      // }
      // else {
      // return SeasonPage(data: _data?[index - 5]);
      // }
      return SeasonPage(data: _data?[index]);
    }));
    tabController =
        TabController(length: tabs.length, vsync: this, initialIndex: 0);
    isLoading = false;
    tabController.addListener(() {
      // if (tabController.index < 5) {
      //   headTabController.animateTo(0,duration: const Duration(microseconds: 0));
      //   currentHeadIndex = 0;
      //   update();
      // } else {
      headTabController.animateTo(1, duration: const Duration(microseconds: 0));
      currentHeadIndex = 1;
      update();
      // }
    });
    update();
    super.onInit();
  }

  Future requestData() async {
    _data = await Api.myLeagueChannels();
    update();
  }

  Future updateTab() async {
    if (!listEquals(_data?.map((e) => e.leagueId).toList(),
        old?.map((e) => e.leagueId).toList())) {
      log(listEquals(_data, old).toString());
      tabs.clear();
      seasonPage = [];
      tabs = [];
      // tabs = [Text("FIFA俱乐部"),Text("FIFA国家队"),Text("FIBA国家队"),Text("NBA"),Text("CBA")];

      tabs.addAll(_data?.map((e) => Text(e.leagueName ?? "")).toList() ?? []);
      var oldIndex = tabController.index;
      tabController.dispose();
      if (tabs.length - 1 < oldIndex) {
        oldIndex = tabs.length - 1;
      }
      tabController = TabController(
          length: tabs.length, vsync: this, initialIndex: oldIndex);
      seasonPage.addAll(List.generate(tabs.length, (index) {
        // if (index ==0) {
        //   return DataRankPage(tag: "俱乐部");
        // } else if(index == 1){
        //   return DataRankPage(tag: "国家队");
        // } else if(index == 2){
        //   return DataRankPage(tag: "篮球");
        // } else if(index >= 3 && index < 5){
        //   return BbSeasonPage(id: tabId[index - 3]);
        // }
        // else {
        // return SeasonPage(data: _data?[index - 5]);
        // }
        return SeasonPage(data: _data?[index]);
      }));
      old = _data;
      update();
    }
  }
}
