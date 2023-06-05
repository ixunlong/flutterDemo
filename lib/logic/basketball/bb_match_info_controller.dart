import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/util/utils.dart';

import '../../model/basketball/bb_info_entity.dart';
import '../../view/match_detail/basketball_match_detail/bb_detail_page.dart';

class BbMatchInfoController extends GetxController{
  final BbDetailController detail = Get.find<BbDetailController>(tag: "${Get.arguments}");
  Map<int, List<String>>? _intelligence;
  List<String> homeSuspend = [];
  List<String> guestSuspend = [];
  int _currentIndex = 0;
  int _totalLength = 0;
  BbInfoEntity? _data;
  List<String> typeList = ["有利","中立","不利"];
  int get currentIndex => _currentIndex;
  int get totalLength => _totalLength;
  Map<int, List<String>>? get intelligence => _intelligence;
  BbInfoEntity? get data => _data;

  set data(BbInfoEntity? value) {
    _data = value;
  }

  set intelligence(Map<int, List<String>>? value) {
    _intelligence = value;
    update();
  }

  set totalLength(int value) {
    _totalLength = value;
    update();
  }

  set currentIndex(int value) {
    _currentIndex = value;
    update();
  }

  @override
  void onReady() {
    super.onReady();
    requestData();
  }

  Future requestData() async{
    _data = await Api.getBbInfo(detail.matchId);
    var map = <int, List<String>>{
      0: [],
      1: [],
      2: [],
      3: [],
      4: []
    };
    if(_data?.homeFavourable.isNullOrEmpty == false) {
      _data?.homeFavourable?.split("\n").forEach((element) {
        map[0]?.add(element);
      });
    }
    if(_data?.guestFavourable.isNullOrEmpty == false) {
      _data?.guestFavourable?.split("\n").forEach((element) {
        map[1]?.add(element);
      });
    }
    if(_data?.homeUnFavourable.isNullOrEmpty == false) {
      _data?.homeUnFavourable?.split("\n").forEach((element) {
       map[2]?.add(element);
      });
    }
    if(_data?.guestUnFavourable.isNullOrEmpty == false) {
      _data?.guestUnFavourable?.split("\n").forEach((element) {
        map[3]?.add(element);
     });
    }
    if(_data?.neutrality.isNullOrEmpty == false) {
      _data?.neutrality?.split("\n").forEach((element) {
        map[4]?.add(element);
      });
    }
  homeSuspend = _data?.homeInjury?.split("(- -").join().split(")").join(" ").split(RegExp(r"[\f\r\n\t\v]+")) ?? [];
  guestSuspend = _data?.guestInjury?.split("(- -").join().split(")").join(" ").split(RegExp(r"[\f\r\n\t\v]+")) ?? [];
  _intelligence = map;
  _intelligence?.values.forEach((element) {
  _totalLength += element.length;
  });
    update();
  }

  List<String> formInjury(String text){
    var list1 = text.split("(- - ");
    var list2 = list1[1].split(")");
    var list3 = list2[0].split(" ");
    return [list1[0],list3[0],list3[1],list2[1]];
  }
}