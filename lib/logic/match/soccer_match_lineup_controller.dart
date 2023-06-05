import 'dart:developer';

import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/match/soccer_match_detail_controller.dart';
import 'package:sports/model/match/soccer_lineup_entity.dart';

import '../../model/match/match_event_entity.dart';
import '../../util/utils.dart';

class SoccerMatchLineupController extends GetxController {
  final detail = Get.find<SoccerMatchDetailController>(tag: '${Get.arguments}');

  SoccerLineupEntity? data;
  List<SoccerLineupEntity?>? nowData = [null, null];
  List<bool> _isSelected = [false,false];
  List<Map<String, List<String>>?> nowEvents = [null, null];
  Map<String, List<String>>? _playerEvents;
  Map<String, List<String>>? get playerEvents => _playerEvents;
  List<bool> get isSelected => _isSelected;
  List title = ['进球', '点球', '乌龙', '失点', '红牌', '黄牌', '两黄', '下场', '上场'];
  List icon = [
    'icon_jingqiu.png',
    'icon_dianqiu.png',
    'icon_wulong.png',
    'icon_shidian.png',
    'icon_hongpai.png',
    'icon_huangpai.png',
    'icon_lianghuang.png',
    'icon_huanxia.png',
    'icon_huanshang.png',
  ];

  @override
  void onInit() async{
    super.onInit();
    await getLineup();
  }

  Future getLineup() async {
    nowData = await Api.getMatchLineup(detail.matchId);
    await getEvents(0);
    await getEvents(1);
    //nowData?[1]?.homeSuspend?.insert(0, "");
    if (nowData?[1]?.homeLineup?.length != 0 && nowData?[1]?.homeLineup != null) {
      _isSelected[1] = true;
      data = nowData?[1];
      _playerEvents = nowEvents[1];
    }else if((nowData?[1]?.homeLineup?.length == 0 || nowData?[1]?.homeLineup == null)
        && (nowData?[0]?.homeLineup?.length != 0 && nowData?[0]?.homeLineup != null)) {
      _isSelected[0] = true;
      data = nowData?[0];
      _playerEvents = nowEvents[0];
    }else if((nowData?[1]?.homeLineup?.length == 0 || nowData?[1]?.homeLineup == null)
        && (nowData?[0]?.homeLineup?.length == 0 || nowData?[0]?.homeLineup != null)){
      _isSelected[1] = true;
      data = nowData?[1];
      _playerEvents = nowEvents[1];
    }else{
      _isSelected[1] = true;
      data = nowData?[1];
      _playerEvents = nowEvents[1];
    }
    update();
  }

  Future getEvents(int index) async {
    final events = await Utils.tryOrNullf(() async {
      var response;
      List l;
      if(index == 1){
        response = await Api.getMatchEvent(detail.matchId,index);
        l = (response?.data['d'] as List).map((e) => MatchEventEntity.fromJson(e)).toList();
      } else {
        List v;
        //response = await Api.getMatchEvent(detail.matchId,index);
        v = nowData?[0]?.guestEvents ?? [];
        //response?.data['d']['prevMessage']['homeEvents'] as List
        v.addAll(nowData?[0]?.homeEvents ?? []);
        l = v;
        Future.delayed(Duration(milliseconds: 100));
      }
      var map = <String, List<String>>{};
      for (var element in l) {
        if (!map.containsKey(element.playerId) && element.playerId != null) {
          map[element.playerId!] = ["", "", "", "", ""];
          if (element.playerId2 != null &&
              element.playerId2!.length > 2 &&
              !map.containsKey(element.playerId2)) {
            map[element.playerId2!] = ["", "", "", "", ""];
          }
        }
        switch (element.kind) {
          case 1:
            map[element.playerId]![3] = '进球';
            break;
          case 11:
            map[element.playerId]![0] = '上场';
            map[element.playerId]![1] = element.eventTime.toString();
            map[element.playerId2]![0] = '下场';
            map[element.playerId2]![1] = element.eventTime.toString();
            break;
          case 3:
            map[element.playerId]![2] = '黄牌';
            break;
          case 2:
            map[element.playerId]![2] = '红牌';
            break;
          case 9:
            map[element.playerId]![2] = '两黄';
            break;
          case 7:
            map[element.playerId]![3] = '点球';
            break;
          case 8:
            map[element.playerId]![3] = '乌龙';
            break;
          case 13:
            map[element.playerId]![4] = '失点';
            break;
        }
      }
      return map;
    });
    nowEvents[index] = events;
    update();
  }

  void moveData(id){
    if(data?.homeBackup?.any((element) => element.playerId == id) == true){
      var index = data!.homeBackup!.indexWhere((element) => element.playerId == id);
      data?.homeBackup?.insert(0, data!.homeBackup![index]);
      data?.homeBackup?.removeAt(index);
    }else if(data?.guestBackup?.any((element) => element.playerId == id) == true){
      var index = data!.guestBackup!.indexWhere((element) => element.playerId == id);
      data?.guestBackup?.insert(0, data!.homeBackup![index]);
      data?.guestBackup?.removeAt(index);
    }
  }

  String toArray(String type) {
    String combine = "";
    var flag = 0;
    if (type == "home") {
      if (data?.homeArray != null) {
        for (var element in data!.homeArray!.split('')) {
          if (flag == 0) {
            combine += element;
            flag = 1;
          } else {
            combine += "-$element";
          }
        }
      } else {
        combine = "阵型暂无";
      }
    } else if (type == "guest") {
      if (data?.guestArray != null) {
        for (var element in data!.guestArray!.split('')) {
          if (flag == 0) {
            combine += element;
            flag = 1;
          } else {
            combine += "-$element";
          }
        }
      } else {
        combine = "阵型暂无";
      }
    }
    return combine;
  }

  String cutDot(double num) {
    var s = num.toString().split('.');
    String com;
    if (s.length >= 2) {
      if (s[1].length > 2) {
        com = '${s[0]}.${s[1].substring(0, 2)}';
      } else {
        com = num.toString();
      }
    } else {
      com = num.toString();
    }
    return com;
  }

  void lineupChoice(index){
    if(index == 1){
      _isSelected[1] = true;
      _isSelected[0] = false;
    }else{
      _isSelected[0] = true;
      _isSelected[1] = false;
    }
    data = nowData?[index];
    _playerEvents = nowEvents[index];
    update();
  }
  
  String ageAndWorth(bool isHome){
    String result = "";
    if(isHome){
      if (data?.homeAverageAge == 0 ||
          data?.homeAverageAge == null) {
        if (data!.homeSumWorth == "0" ||
            data!.homeSumWorth == null) {
          result = "";
        }else {
          if (double.parse(data!.homeSumWorth!) >= 10000) {
            result = "${cutDot(
                double.parse(data!.homeSumWorth!) /
                    10000)}亿英镑";
          } else {
            result =
            "${double.parse(data!.homeSumWorth!).toInt()}万英镑";
          }
        }
      } else {
        if (data!.homeSumWorth == "0" ||
            data!.homeSumWorth == null) {
          result = "平均${data?.homeAverageAge}岁";
        }else {
          if (double.parse(data!.homeSumWorth!) >= 10000) {
            result =
            "平均${data?.homeAverageAge}岁 ${cutDot(double.parse(data!.homeSumWorth!) / 10000)}亿英镑";
          } else {
            result = "平均${data?.homeAverageAge}岁 ${double.parse(
                data!.homeSumWorth!).toInt()}万英镑";
          }
        }
      }
    }else{
      if (data?.guestAverageAge == 0 ||
          data?.guestAverageAge == null) {
        if (data!.guestSumWorth == "0" ||
            data!.guestSumWorth == null) {
          result = "";
        }else {
          if (double.parse(data!.guestSumWorth!) >= 10000) {
            result = "${cutDot(
                double.parse(data!.guestSumWorth!) /
                    10000)}亿英镑";
          } else {
            result =
            "${double.parse(data!.guestSumWorth!).toInt()}万英镑";
          }
        }
      } else {
        if (data!.guestSumWorth == "0" ||
            data!.guestSumWorth == null) {
          result = "平均${data?.guestAverageAge}岁";
        }else {
          if (double.parse(data!.guestSumWorth!) >= 10000) {
            result =
            "平均${data?.guestAverageAge}岁 ${
                cutDot(double.parse(data!.guestSumWorth!) / 10000)}亿英镑";
          } else {
            result = "平均${data?.guestAverageAge}岁 ${double.parse(
                data!.guestSumWorth!).toInt()}万英镑";
          }
        }
      }
    }
    return result;
  }

  String lastMatchScore(bool isHome){
    String result = "";
    if(isHome){
      if ((detail.info?.baseInfo?.homeName != null && detail.info?.baseInfo?.homeName != "")
          &&(data?.homeLastMatcher != null && data?.homeLastMatcher != "")
          && (data?.homeLastMatcherScore != null)
          && (data?.homeLastScore != null)) {
        result = "${detail.info!.baseInfo!.homeName!} ${data!.homeLastScore!}:${data!.homeLastMatcherScore!} ${data!.homeLastMatcher!}";
      }
    }else {
      if ((detail.info?.baseInfo?.guestName != null && detail.info?.baseInfo?.guestName != "")
        &&(data?.guestLastMatcher != null && data?.guestLastMatcher != "")
        && (data?.guestLastMatcherScore != null)
        && (data?.guestLastScore != null)) {
        result = "${detail.info!.baseInfo!.guestName!} ${data!.guestLastScore!}:${data!.guestLastMatcherScore!} ${data!.guestLastMatcher!}";
      }
    }
    return result;
  }
}
