import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_detail_controller.dart';
import 'package:sports/model/match/soccer_odds_entity.dart';
import 'package:sports/util/utils.dart';

import '../../http/api.dart';
import '../../res/colours.dart';

class SoccerMatchOddsDetailController extends GetxController with GetSingleTickerProviderStateMixin{
  late final detail = Get.find<SoccerMatchDetailController>(tag: '${Get.arguments[1]}');
  List<String> typeList = ["欧指","亚指","让球","大小球"];
  late final TabController tabController = TabController(length: typeList.length, vsync: this);
  final List<int> _numList = [1001,1006,1002,1007];
  List<List<String>> headTypeList = [["胜","平","负"],["主","盘","客"],["胜","平","负"],["大","盘","小"]];
  int _typeIndex = 0;
  late List<int> _selectIndex = List.generate(_numList.length, (index) => 0);
  bool isLoading = true;
  late List<List<SoccerOddsCompanyEntity>> _companies = List.generate(_numList.length, (index) => []);
  late List<List<SoccerOddsDetailEntity>> _data = List.generate(_numList.length, (index) => []);

  List<List<SoccerOddsDetailEntity>> get data => _data;

  List<List<SoccerOddsCompanyEntity>> get companies => _companies;
  List<int> get numList => _numList;
  int get typeIndex => _typeIndex;
  List<int> get selectIndex => _selectIndex;

  @override
  void onInit() {
    tabController.addListener(() {
      typeIndex = tabController.index;
    });
    super.onInit();
  }

  void setSelectIndex(int index,int value) {
    if(value < 0){
      _selectIndex[index] = 0;
    }else{
      _selectIndex[index] = value;
    }
    update();
  }

  set typeIndex(int value) {
    _typeIndex = value;
    update();
  }

  @override
  void onReady() async{
    typeIndex = Get.arguments[2];
    await requestCompany();
    for(var i=0;i<_numList.length;i++) {
      await requestData(_selectIndex[i],index: i);
    }
    isLoading = false;
    update();
  }

  Future requestData(int i,{int? index}) async{
    try {
      _data[index ?? _typeIndex] = await Api.getMatchOddsDetail(
        detail.matchId,
        _companies[index ?? _typeIndex][i].id==-1||_companies[index ?? _typeIndex][i].id==null?
          0:_companies[index ?? _typeIndex][i].id!,
        _numList[index ?? _typeIndex],
          _companies[index ?? _typeIndex][i].line ?? "") ?? [];
    }catch(e){
      _data[_typeIndex] = [];
    }
    update();
  }

  Future requestCompany() async{
    for(var i=0;i<_numList.length;i++) {
      _companies[i] =
        await Api.getMatchOddsCompany(
          detail.matchId, _numList[_typeIndex]) ?? [];
      setSelectIndex(i, _companies[i].indexWhere((element) => element.id == Get.arguments[0]));
    }
    update();
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


}