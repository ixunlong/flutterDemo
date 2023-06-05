import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/basketball/bb_lineup_entity.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_detail_page.dart';

import '../../http/apis/basketball.dart';
import '../../model/basketball/bb_match_detail_entity.dart';

class BbLineupController extends GetxController with GetSingleTickerProviderStateMixin{
  final BbDetailController detail = Get.find<BbDetailController>(tag: "${Get.arguments}");
  late final TabController tabController = TabController(length: 2, vsync: this);
  int _currentTab = 0;
  List<String> dataType = ['时间','得分','篮板','助攻','投篮','三分','罚球','前板','后板','抢断','盖帽','失误','犯规','+/-'];
  BbLineupKeyDataEntity? _key;
  int _periodNum = 0;
  List<List<BbLineupDataEntity>> _data = [[],[]];
  List<List<TeamInfo>> _suspend = [];
  BbMatchDetailEntity? _trends;
  bool _showMore = false;
  bool isLoading = true;

  BbLineupKeyDataEntity? get key => _key;
  List<List<BbLineupDataEntity>> get data => _data;
  List<List<TeamInfo>> get suspend => _suspend;
  int get currentTab => _currentTab;
  BbMatchDetailEntity? get trends => _trends;
  int get periodNum => _periodNum;
  bool get showMore => _showMore;

  set showMore(bool value) {
    _showMore = value;
    update();
  }
  set periodNum(int value) {
    _periodNum = value;
    update();
  }
  set trends(BbMatchDetailEntity? value) {
    _trends = value;
    update();
  }
  set currentTab(int value) {
    _currentTab = value;
    update();
  }
@override
  void onReady() {
    getMatchDetail();
    requestData();
  }

  Future getMatchDetail() async {
    final response = await BasketballApi.matchDetail(Get.arguments);
    try {
      trends = BbMatchDetailEntity.fromJson(response.data['d']);
      if ((trends?.appMatchTlives?.length ?? 0) > 0) {
        periodNum = trends?.appMatchTlives?.length ?? 0;
      }
    } catch (err) {
      log("篮球获取比赛详情出错");
      log("$err");
    }
  }

  Future requestData() async{
    _key = await Api.getBbLineupKeyData(detail.matchId);
    _data[1] = await Api.getBbLineupData(detail.matchId, 1) ?? [];
    _data[0] = await Api.getBbLineupData(detail.matchId, 2) ?? [];
    var data = await Api.getBbLineupSuspendData(detail.matchId);
    _suspend = [data?.awayTeamInfo ?? [],data?.homeTeamInfo ?? []];
    isLoading = false;
    update();
  }

  List<KeyDataInfo?> keyData(int index){
    switch(index){
      case 0:
        return [_key?.awayPlayerInfo?.points,_key?.homePlayerInfo?.points];
      case 1:
        return [_key?.awayPlayerInfo?.rebounds,_key?.homePlayerInfo?.rebounds];
      case 2:
        return [_key?.awayPlayerInfo?.assists,_key?.homePlayerInfo?.assists];
    }
    return [];
  }

  List<int> keyScore(int index){
    switch(index){
      case 0:
        return [_key?.awayPlayerInfo?.points?.points ?? 0,_key?.homePlayerInfo?.points?.points ?? 0];
      case 1:
        return [_key?.awayPlayerInfo?.rebounds?.rebounds ?? 0,_key?.homePlayerInfo?.rebounds?.rebounds ?? 0];
      case 2:
        return [_key?.awayPlayerInfo?.assists?.assists ?? 0,_key?.homePlayerInfo?.assists?.assists ?? 0];
    }
    return [];
  }

  String keyDataType(int index){
    switch(index){
      case 0:
        return "得分";
      case 1:
        return "篮板";
      case 2:
        return "助攻";
    }
    return "";
  }

  List<String> lineupData(BbLineupDataEntity entity){
    return [
      "${entity.minutesPlayed}${entity.minutesPlayed.isNullOrEmpty?"":"'"}",
      "${entity.points}", "${entity.rebounds}", "${entity.assists}",
      '${entity.fieldGoalsScored}${entity.fieldGoalsTotal != null && entity.fieldGoalsScored != null?"/":""}${entity.fieldGoalsTotal}',
      '${entity.threePointsScored}${entity.threePointsScored != null && entity.threePointsTotal != null?"/":""}${entity.threePointsTotal}',
      '${entity.freeThrowsScored}${entity.freeThrowsScored != null && entity.freeThrowsTotal != null?"/":""}${entity.freeThrowsTotal}',
      '${entity.offensiveRebounds}','${entity.defensiveRebounds}','${entity.steals}',
      '${entity.blocks}','${entity.turnovers}','${entity.personalFouls}',"${entity.bpm}"
    ];
  }

  void checkBool(){
    var keyBool = List.generate(3, (index) => keyScore(index)).every((element) => element.every((element) => element == 0))?1:0;
    var lineupBool = data.every((element) => element.every((element) => element.toJson().isEmpty))?1:0;
    var suspendBool = suspend.every((element) => element.isEmpty)?1:0;
    int count = keyBool+lineupBool+suspendBool;
  }
}