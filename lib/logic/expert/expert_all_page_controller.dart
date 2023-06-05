import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../http/api.dart';
import '../../model/expert/expert_focus_entity.dart';
import '../../model/expert/expert_views_entity.dart';
import '../../util/user.dart';
import '../../util/utils.dart';
import '../../view/expert/expert_load_item.dart';

class ExpertAllPageController extends GetxController with GetSingleTickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  final List<ExpertLoadItems> _pages = List.generate(2, (index) => ExpertLoadItems([],0,1,15));
  late final tabController = TabController(length: 2, vsync: this,initialIndex: Get.arguments ?? 0);
  int _tabIndex = 0;
  final EasyRefreshController _easyRefreshController = EasyRefreshController(controlFinishLoad: true);
  bool _isLoading = true;
  ExpertFocusEntity? _focusList;
  List<List<bool>> _isFocus = [[],[]];

  bool get isLoading => _isLoading;
  List<List<bool>> get isFocus => _isFocus;
  List<ExpertLoadItems> get pages => _pages;
  EasyRefreshController get easyRefreshController => _easyRefreshController;
  ExpertFocusEntity? get focusList => _focusList;
  ScrollController get scrollController => _scrollController;
  int get tabIndex => _tabIndex;

  set tabIndex(int value) {
    _tabIndex = value;
    update();
  }

  @override
  void onInit() {
    tabController.addListener(() { 
      _tabIndex = tabController.index;
    });
    super.onInit();
  }

  @override
  void onReady() async{
    for(var i=0;i<_pages.length;i++){
      await getViews(i);
    }
    _isLoading = false;
  }

  Future checkFocus(int index) async{
    _isFocus[index] = List.filled(_pages[index].items.length, false);
    if(User.auth?.userId != null) {
      _focusList = await Api.expertFocusList(1, 100);
      if (_focusList != null) {
        for (var i = 0; i < _pages[index].items.length; i++) {
          for (var element in _focusList!.contents!) {
            if (element.id == _pages[index].items[i].expertId) {
              _isFocus[index][i] = true;
            }
          }
        }
      }
    }
    update();
  }

  Future setFocus(String? expertId,int index,int childIndex) async {
    if (expertId == null) {
      return;
    }
    if (_isFocus[index][childIndex]) {
      final result = await Utils.alertQuery('确认不再关注');
      if (result == true) {
        await Api.expertUnfocus(expertId);
        await checkFocus(_tabIndex);
      }
    } else {
      await Api.expertFocus(expertId);
      await checkFocus(_tabIndex);
    }
    update();
  }

  void setPage(value){
    value == null? _pages[_tabIndex].page += 1 : _pages[_tabIndex].page = value;
  }

  Future getViews(int index) async{
    ExpertViewsEntity? data;
    data = await Api.getExpertAll(_pages[index].page, _pages[index].pageSize, index+1);
    if(data?.rows != null){
      _pages[index].total = data!.total!;
      _pages[index].page == 1?
      _pages[index].items = data.rows!:
      _pages[index].items.addAll(data.rows!);
    }
    await checkFocus(index);
    _isLoading = false;
    update();
  }

}