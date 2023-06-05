import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_detail_controller.dart';
import 'package:sports/model/match/soccer_odds_entity.dart';
import 'package:sports/util/utils.dart';

import '../../http/api.dart';
import '../../res/colours.dart';

class SoccerMatchOddsController extends GetxController{
  final detail = Get.find<SoccerMatchDetailController>(tag: '${Get.arguments}');
  List<String> typeList = ["欧指","亚指","让球","大小球"];
  final List<int> _numList = [1001,1006,1002,1007];
  List<String> headTypeList = ["胜","平","负"];
  int _typeIndex = 0;
  List<SoccerOddsEntity>? _data;
  List<SoccerOddsEntity> get data => _data ?? [];
  int get typeIndex => _typeIndex;

  set typeIndex(int value) {
    _typeIndex = value;
    switch(_typeIndex){
      case 0:case 2:
        headTypeList = ["胜","平","负"];
        break;
      case 1:
        headTypeList = ["主","盘","客"];
        break;
      case 3:
        headTypeList = ["大","盘","小"];
        break;
    }
    update();
  }

  @override
  void onReady() {
    requestData();
  }

  Future requestData() async{
    _data = await Api.getMatchOdds(_numList[_typeIndex], detail.matchId);
    update();
  }

  List<Widget> formSingleLine(List<OddsData> dataList){
    TextStyle style = const TextStyle(fontSize: 12,color: Colours.text_color);
    List<Widget> list = [Container(),Container(),Container(),Container()];
    List<String> karry = ["","",""];
    for (var element in dataList) {
      switch(element.i){
        case "d":case "s":case "z":
          list.replaceRange(0, 1, [formValue(element.o, element.st)]);
          karry[0] = remain2(element.kl);
          break;
        case "x":case "k":case "f":
          list.replaceRange(2, 3, [formValue(element.o, element.st)]);
          karry[1] = element.kl.isNullOrEmpty?"":"/${remain2(element.kl)}";
          break;
        case "p":
          list.replaceRange(1, 2, [formValue(element.o, element.st)]);
          karry[2] = element.kl.isNullOrEmpty?"":"/${remain2(element.kl)}";
          break;
      }
    }
    list.replaceRange(3, 4, [Text(karry.join(),style: style)]);
    return list;
  }

  String remain2(String? data){
    return data.isNullOrEmpty?"":double.parse(data!).toStringAsFixed(2);
  }

  Widget formValue(data,status){
    String text = "";
    Widget asset = Image.asset(color: Colours.transparent,Utils.getImgPath("up_arrow_red.png"));
    Color color = Colours.text_color;
    if(status == 0){
      text = "${remain2(data)}";
    }else if(status == 1){
      text = "${remain2(data)}";
      color = Colours.main;
      asset = Image.asset(Utils.getImgPath("up_arrow_red.png"));
    }else if(status == 2){
      text = "${remain2(data)}";
      color = Colours.green;
      asset = Image.asset(Utils.getImgPath("down_arrow_green.png"));
    }else{
      text = remain2(data);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: TextStyle(fontSize: 12,color: color)),
        asset
      ],
    );
  }
}