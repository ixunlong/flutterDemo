import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/data/data_rank_entity.dart';

import '../../widgets/cupertino_picker_widget.dart';

class DataRankController extends GetxController{

  String tag = "";
  int _sexIndex = 0;
  int _typeIndex = 0;
  int _dateIndex = 0;
  List<String> sexList = ["男足","女足"];
  List<String> sexBbList = ["男篮", "女篮"];
  List<String> typeList = ["世界","亚洲","欧洲","南美洲","中北美洲","大洋洲","非洲"];
  List<String> typeBbList = ["世界","亚洲","欧洲","美洲","非洲"];
  List<int> type = [0,4,2,3,6];
  var _months = [];
  var _data = [];


  bool isLoading = true;
  int get sexIndex => _sexIndex;
  int get dateIndex => _dateIndex;
  int get typeIndex => _typeIndex;
  get data => _data;
  get months => _months;

  Future showTypePicker() async {
    _sexIndex = await Get.bottomSheet(CupertinoPickerWidget(
      tag!="篮球"?sexList:sexBbList,
      title: '选择类型',
      initialIndex: _sexIndex,
    ));
    await requestData();
    update();
  }

  Future requestData() async{
    if(tag != "篮球") {
      _months = await Api.getDataRankMonth(tag == "俱乐部"?3:sexIndex +1);
      _data = await Api.getDataRank(
        type: tag == "俱乐部"?3:sexIndex+1,
        area: tag == "俱乐部" || _typeIndex == 0?"":typeList[_typeIndex],
        month: _months[_dateIndex].rankMonth);
    }else {
      _months = await Api.getDataBbRankMonth(sexIndex +1);
      _data = await Api.getDataBbRank(
          type: sexIndex+1,
          area: type[_typeIndex],
          month: _months[_dateIndex].rankMonth);
    }
    isLoading = false;
    update();
  }

  Future showDatePicker() async {
    _dateIndex = await Get.bottomSheet(CupertinoPickerWidget(
      _months.map((e) => e.rankMonth! as String).toList(),
      title: '选择月份',
      initialIndex: _dateIndex,
    ));
    await requestData();
    update();
  }

  void getType(index){
    _typeIndex = index;
    requestData();
    update();
  }

}