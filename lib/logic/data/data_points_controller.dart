import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/data/data_season_controller.dart';
import 'package:sports/model/data/data_cup_points_entity.dart';
import 'package:sports/model/data/data_points_entity.dart';

class DataPointsController extends GetxController{
  final String? seasonTag;
  final int? leagueId;
  DataPointsController(this.leagueId, {this.seasonTag});
  
  late final season = Get.find<DataSeasonController>(tag: seasonTag);
  DataCupPointsEntity? entity;
  List<PointsList>? pointsData;
  List<MatchList>? matchList;
  int qualifyIndex = 0;
  bool visible = false;
  bool isLoading = true;
  EasyRefreshController refreshController = EasyRefreshController();

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
    entity = await Api.getCupPoints(leagueId ?? 0, season.currentSeason);
    matchList = entity?.matchList;
    isLoading = false;
    update();
  }

  String formIntroduce(data){
    var regC = RegExp(r"[\u4e00-\u9fa5]");
    String append = '';
    data.split("").forEach((element) {
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