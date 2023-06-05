import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/data/basketball/bb_data_season_controller.dart';

import '../../../model/data/basket/basket_points_entity.dart';

class BbDataPointsController extends GetxController{
  final String? seasonTag;
  final int? leagueId;
  BbDataPointsController(this.leagueId, {this.seasonTag});
  
  late final season = Get.find<BbDataSeasonController>(tag: seasonTag);
  BasketPointsEntity? entity;
  List<Points>? pointsData;
  List<MatchList>? matchList;
  int qualifyIndex = 0;
  bool visible = false;
  bool isLoading = true;
  int _currentTab = 0;
  EasyRefreshController refreshController = EasyRefreshController();

  int get currentTab => _currentTab;

  set currentTab(int value) {
    _currentTab = value;
    update();
  }

  @override
  void onInit() async{
    await requestData();
    var currentSeason = season.currentSeason;
    season.addListener(() {
      if(currentSeason != season.currentSeason){
        requestData();
        currentSeason = season.currentSeason;
      }
    });
    super.onInit();
  }

  Future requestData() async{
    entity = await Api.getBasketPoints(leagueId ?? 0, season.currentSeason);
    matchList = entity?.matchList;
    isLoading = false;
    update();
  }

  String formIntroduce(String data){
    var regC = RegExp(r"[\u4e00-\u9fa5]");
    var regShift = RegExp(r"[\f\r\n\t\v]+");
    var regEmpty = RegExp(r"<p></p>");
    String append = '';
    data.split(regEmpty).join().split(regShift).join().split("").forEach((element) {
      if(regC.hasMatch(element)){
        append += "$element\u200A";
      }else{
        append += element;
      }
    });
    return append;
  }

  List formQualify(List<Qualifying> list){
    for(var i = 0;i < list.length; i++){
      for(var j = i+1;j<list.length;j++){
        if(list[i].beginRank == list[j].beginRank){
          list.removeAt(i);
        }
      }
    }
    return list;
  }

  @override
  void dispose() {
    season.removeListener(() {});
    super.dispose();
  }
}