import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../http/api.dart';
import '../../model/expert/expert_focus_entity.dart';
import '../../model/expert/expert_search_entity.dart';
import '../../util/user.dart';
import '../../util/utils.dart';
import '../../view/expert/expert_load_item.dart';

class ExpertSearchPageController extends GetxController{
  final ScrollController _scrollController = ScrollController();
  final ExpertLoadItems _pages = ExpertLoadItems([],0,1,10000);
  Rx<String> _str = "".obs;

  String get str => _str.value;

  set str(String value) {
    _str.value = value;
  }

  bool _isLoading = true;
  bool firstInput = true;
  List<ExpertSearchEntity> _findList = [];
  List<bool> _isFocus = [];
  final textController = TextEditingController();
  late FocusNode focus;

  bool get isLoading => _isLoading;
  List<bool> get isFocus => _isFocus;
  List<ExpertSearchEntity> get findList => _findList;
  ExpertLoadItems get pages => _pages;
  ScrollController get scrollController => _scrollController;

  @override
  void onInit() {
    interval(_str,(callback) async {
      _findList = await Api.getExpert(_str.value) ?? [];
      update();
    },time: const Duration(milliseconds: 500));
    super.onInit();
  }

  Future setFocus(String? expertId,int index) async {
    if (expertId == null) {
      return;
    }
    if (_findList[index].isFocus!=0 && _findList[index].isFocus!=null) {
      final result = await Utils.alertQuery('确认不再关注');
      if (result == true) {
        await Api.expertUnfocus(expertId);
        _findList = await Api.getExpert(_str.value) ?? [];
      }
    } else {
      await Api.expertFocus(expertId);
      _findList = await Api.getExpert(_str.value) ?? [];
    }
    update();
  }
}