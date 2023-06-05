import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../http/api.dart';
import '../../model/data/data_schedule_entity.dart';
import '../../util/utils.dart';
import '../../widgets/cupertino_picker_widget.dart';
import 'data_season_controller.dart';

class DataScheduleController extends GetxController{
  final String? seasonTag;
  final int? leagueId;
  DataScheduleController(this.leagueId, {this.seasonTag});

  late final season = Get.find<DataSeasonController>(tag: seasonTag);
  List<DataScheduleEntity>? data;
  String _round = "";
  bool visible = false;
  bool isLoading = true;
  final ScrollController scrollController = ScrollController(initialScrollOffset: 45);
  late final ListObserverController observerController;
  int _currentItem = 0;

  int get currentItem => _currentItem;
  String get round => _round;

  @override
  void onInit() async{
    await getData();
    initObserver();
    isLoading = false;
    var currentSeason = season.currentSeason;
    season.addListener(() {
      if(currentSeason != season.currentSeason){
        getData();
        // observerController.innerReset();
        // initObserver();
        currentSeason = season.currentSeason;
      }
    });
    super.onInit();
  }

  Future getData() async{
    data = await Api.dataSchedule(leagueId ?? 0,season.currentSeason);
    var i = 0;
    data?.forEach((element) {
      if(element.isCurrent == 1){
        _round = element.round!;
        _currentItem = i;
      }
      i++;
    });
    if(_currentItem == 0 && data?.length != 0){
      _round = data?[0].round ?? "";
    }
    log("当前轮$_round");
    update();
  }

  void initObserver(){
    if(data?.length != 0) {
      observerController =
      ListObserverController(controller: scrollController)
        ..cacheJumpIndexOffset = true
        ..initialIndexModel =
        ObserverIndexPositionModel(
            index: _currentItem,
            alignment: 1 / (data?[_currentItem].teamList!.length ?? 0 + 1));
    }else if(data?.length == 0) {
      observerController = ListObserverController()..cacheJumpIndexOffset = true;
    }
    update();
  }

  void setRound(value){
    _round = value;
    update();
  }

  void setCurrentItem(value) {
    if(value >= 0 && value < data!.length){
      _currentItem = value;
    }
    update();
  }

  Future showDatePicker() async {
    RegExp regExp = RegExp(r"[0-9]");
    log("${regExp.hasMatch(data![0].round!)}");
    var result = await Get.bottomSheet(
      CupertinoPickerWidget(
        data!.map((e) => e.round!).toList(),
        title: '选择轮次',
        initialIndex: _currentItem,
    ));
    if(result != null){
      Utils.onEvent("sjpd_sc_lcxz",params: {"sjpd_sc_lcxz":1});
      _currentItem = result;
    }else{
      Utils.onEvent("sjpd_sc_lcxz",params: {"sjpd_sc_lcxz":0});
    }
    update();
  }
}