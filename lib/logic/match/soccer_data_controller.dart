import 'dart:developer';
import 'dart:ffi';

import 'package:get/get.dart';

import '../../http/api.dart';
import '../../model/match/soccer_data_entity.dart';

class SoccerDataController extends GetxController{
  SoccerDataEntity? _data;
  bool isLoading = true;
  String _soccerInfo = "";
  Map<String,Map<String,String>> _soccerData = {};

  String get soccerInfo => _soccerInfo;
  Map<String,Map<String,String>> get soccerData => _soccerData;
  SoccerDataEntity? get data => _data;

  @override
  void onInit() async{
    super.onInit();
    await requestData();
    update();
  }

  Future requestData() async{
    try {
      _data = await Api.getSoccerData(Get.arguments[0], Get.arguments[1]);
      
      if (_data?.positionCn != null && _data?.positionCn != "") {
        _soccerInfo += _data!.positionCn!;
      }
      if (_data?.number != null && _data?.number != "" && _data?.age != "0") {
        _soccerInfo += "/${_data!.number!}号";
      }
      if (_data?.age != null && _data?.age != "" && _data?.age != "0") {
        _soccerInfo += "/${_data!.age!}岁";
      }
      if (_data?.height != null && _data?.height != "" && _data?.age != "0") {
        _soccerInfo += "/${_data!.height!}cm";
      }
      if (_data?.weight != null && _data?.weight != "" && _data?.age != "0") {
        _soccerInfo += "/${_data!.weight!}kg";
      }
      
      _soccerData = {
        "": {
          "进球(点球)": "${_data?.goalsPenalty}",
          "助攻": _data?.assist ?? "-",
          "首发/替补": _data?.isFirstTeam == true ? "首发" : "替补",
          "上场时间": _data?.playingTime == null || _data?.playingTime == '-'? "-" : "${_data?.playingTime}'"},
        "门将": {
          "扑点": "${_data?.penaltySave ?? "-"}"},
        "进攻": {
          "射门(射正)": "${_data?.shots ?? "-"}(${_data?.shotsTarget ?? "-"})",
          "击中门框": "${_data?.shotOnPost ?? "-"}",
          "被犯规": "${_data?.wasFouled ?? "-"}",
          "越位": "${_data?.offsides ?? "-"}"},
        "传球": {
          "传球(成功)": "${_data?.totalPass ?? "-"}(${_data?.accuratePass ?? "-"})",
          "传球成功率": _data?.passRate != null ? "${(_data!.passRate! * 100).toInt()}%" : "-",
          "关键传球": "${_data?.keyPass ?? "-"}",
          "横传(精确)": "${_data?.crossNum ?? "-"}(${_data?.crossWon ?? "-"})",
          "长传(精确)": "${_data?.longBall ?? "-"}(${_data?.longBallWon ?? "-"})",
          "直塞(精确)": "${_data?.throughBall ?? "-"}(${_data?.throughBallWon ?? "-"})"
        },
        "防守": {
          "抢断": "${_data?.tackles ?? "-"}",
          "解围(有效)": "${_data?.clearances ?? "-"}(${_data?.clearanceWon ?? "-"})",
          "拦截": "${_data?.interception ?? "-"}",
          "封堵": "${_data?.shotsBlocked ?? "-"}",
          "造成越位": "${_data?.offsides ?? "-"}"
        },
        "纪律": {
          "犯规": "${_data?.fouls ?? "-"}",
          "黄牌": "${_data?.yellow ?? "-"}",
          "红牌": "${_data?.red ?? "-"}"
        },
        "其他": {
          "争顶成功": "${_data?.aerialWon ?? "-"}",
          "带球摆脱": "${_data?.dribblesWon ?? "-"}",
          "失去球权": "${_data?.dispossessed ?? "-"}",
          "身体接触": "${_data?.touches ?? "-"}",
          "失误":"${_data?.turnover ?? "-"}",
          "失误丢球":"${_data?.errorLeadToGoal ?? "-"}"
        }
      };
    }catch(error){
      log("$error");
      isLoading = false;
    }
    isLoading = false;
    update();
  }
}