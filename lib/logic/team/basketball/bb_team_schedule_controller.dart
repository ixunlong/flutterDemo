import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:sports/util/utils.dart';

import '../../../http/api.dart';
import '../../../model/team/bb_team/bb_team_schedule_entity.dart';
import '../../../widgets/cupertino_picker_widget.dart';
import 'basket_team_detail_controller.dart';


class BbTeamScheduleController extends GetxController{
  BasketTeamDetailController detail = Get.find(tag: "${Get.arguments}");
  int _yearIndex = 0;
  int _typeIndex = 0;
  List<LeagueArray>? typeList;
  List<BbTeamScheduleYearEntity> _years = [];
  BbTeamScheduleEntity? _data;
  ScrollController scrollController = ScrollController();
  late ListObserverController observerController;
  List<MatchGroup>? _matchGroup = [];
  bool _isLoading = true;
  bool _toNull = false;

  bool get toNull => _toNull;
  int get typeIndex => _typeIndex;
  int get yearIndex => _yearIndex;
  bool get isLoading => _isLoading;
  BbTeamScheduleEntity? get data => _data;
  List<MatchGroup>? get matchGroup => _matchGroup;
  List<BbTeamScheduleYearEntity> get years => _years;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }
  set toNull(bool value) {
    _toNull = value;
    update();
  }
  set typeIndex(int value) {
    _typeIndex = value;
    update();
  }


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
      BbTeamScheduleEntity d = BbTeamScheduleEntity.fromJson(_data?.toJson() ?? {});
      if (detail.data?.national == 1) {
        d.matchGroup?.removeWhere(
                (element) => element.matchArray?.every(
                    (e) => e.leagueId != _data?.leagueArray?[_typeIndex].leagueId) ?? true);
        d.matchGroup?.forEach((element) {
          element.matchArray?.removeWhere((e) => e.leagueId != _data?.leagueArray?[_typeIndex].leagueId);
        });
      } else {
        d.matchGroup?.removeWhere(
                (element) => element.matchArray?.every(
                    (e) => e.kind != _data?.leagueArray?[_typeIndex].leagueId) ?? true);
        d.matchGroup?.forEach((element) {
          element.matchArray?.removeWhere((e) => e.kind != _data?.leagueArray?[_typeIndex].leagueId);
        });
      }
      _matchGroup = List.from(d.matchGroup ?? []);
    }else{
      _matchGroup = List.from(_data?.matchGroup ?? []);
    }
    update();
  }

  Future requestYears() async{
    _years = await Api.getBbTeamScheduleYear(detail.teamId);
    update();
  }

  Future requestData() async{
    if(_years.isNotEmpty) {
      if (detail.data?.national == 1) {
        _data = await Api.getBbTeamSchedule(
            detail.teamId,
            _years[_yearIndex].year.toString(),
            leagueId: typeList != null ? typeList![_typeIndex].leagueId : null);
      } else {
        _data = await Api.getBbTeamSchedule(
            detail.teamId,
            _years[_yearIndex].year.toString(),
            kind: typeList != null ? typeList![_typeIndex].leagueId : null);
      }
      typeList = _data?.leagueArray;
      _matchGroup = List.from(_data?.matchGroup ?? []);
      update();
    }
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
    switch(entity?.statusId){
      case 10:
        if(entity?.guestPoints != null && entity?.homePoints != null) {
          return "${entity!.guestPoints!}-${entity.homePoints!}";
        }else{
          return "vs";
        }
      case 12:
        return "取消";
      case 11:
        return "中断";
      case 14:
        return "腰斩";
      case 13:
        return "延期";
      case 15:
        return "待定";
      default:
        return "vs";

    }
  }
}