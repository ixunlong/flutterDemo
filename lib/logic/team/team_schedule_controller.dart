import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:sports/logic/team/soccer_team_detail_controller.dart';
import 'package:sports/util/utils.dart';

import '../../http/api.dart';
import '../../model/team/team_schedule_entity.dart';
import '../../widgets/cupertino_picker_widget.dart';

class TeamScheduleController extends GetxController{
  SoccerTeamDetailController detail = Get.find(tag: "${Get.arguments}");
  int _yearIndex = 0;
  int _typeIndex = 0;
  List<TeamScheduleYearEntity> _years = [];
  TeamScheduleEntity? _data;
  ScrollController scrollController = ScrollController();
  late ListObserverController observerController;
  List<MatchGroup>? _matchGroup = [];
  List<String> typeList = ["世界","亚洲","欧洲","南美洲","中北美洲"];
  bool isLoading = true;

  int get typeIndex => _typeIndex;
  int get yearIndex => _yearIndex;
  TeamScheduleEntity? get data => _data;
  List<MatchGroup>? get matchGroup => _matchGroup;
  List<TeamScheduleYearEntity> get years => _years;

  Future showDatePicker() async {
    _yearIndex = await Get.bottomSheet(CupertinoPickerWidget(
      _years.map((e) => e.year!.toString()).toList(),
      title: '选择年份',
      initialIndex: _yearIndex,
    ));
    update();
  }

  void getType(index){
    _typeIndex = index;
    if(_typeIndex != 0) {
      TeamScheduleEntity d = TeamScheduleEntity.fromJson(_data?.toJson() ?? {});
      d.matchGroup?.removeWhere(
        (element) => element.matchArray?.every(
          (e) => e.leagueId != _data?.leagueArray?[_typeIndex].leagueId) ?? true);
      d.matchGroup?.forEach((element) {
        element.matchArray?.removeWhere((e) => e.leagueId != _data?.leagueArray?[_typeIndex].leagueId);
      });
      _matchGroup = List.from(d.matchGroup ?? []);
    }else{
      _matchGroup = List.from(_data?.matchGroup ?? []);
    }
    update();
  }

  Future requestYears(int id) async{
    _years = await Api.getTeamScheduleYear(id);
    update();
  }

  Future requestData(int id) async{
    _data = await Api.getTeamSchedule(id,_years[_yearIndex].year.toString());
    _matchGroup = List.from(_data?.matchGroup ?? []);
    update();
  }

  void initObserver(){
    double offset = 0;
    var length = 0;
    int index = _data?.matchGroup?.indexWhere(
            (element) => element.title == DateTime.now().formatedString('yyyy-MM'))?? 0;
    if(index != 0){
      for(var i=0;i<index;i++){
        length = length+(_data?.matchGroup?[i].matchArray?.length ?? 0);
      }
      offset = 56.0*index+50*length;
    };
    detail.key.currentState?.innerController.jumpTo(offset);
  }

  String formScore(int type,MatchArray? entity){
    if(type == 1){
      switch(entity?.status){
        case 5:case 6:case 7:
          if(entity?.homeScore90 != null && entity?.guestScore90 != null) {
            return "${entity!.homeScore90!}-${entity.guestScore90!}";
          }else{
            return "vs";
          }
        case 8:
          return "取消";
        case 9:
          return "中断";
        case 10:
          return "腰斩";
        case 11:
          return "延期";
        case 12:
          return "待定";
        default:
          return "vs";

      }
    }else{
      if(entity?.homeScorePk != null && entity?.guestScorePk != null) {
        return "点球 ${entity!.homeScorePk!}-${entity.guestScorePk!}";
      }else{
        if(entity?.homeScoreOt != null && entity?.guestScoreOt != null) {
          return "加时 ${entity!.homeScoreOt!}-${entity.guestScoreOt!}";
        }else{
          return "";
        }
      }
    }
  }
}