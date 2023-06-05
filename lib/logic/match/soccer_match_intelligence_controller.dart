import 'package:get/get.dart';
import 'package:sports/logic/match/soccer_match_detail_controller.dart';
import 'package:sports/model/match/match_info_entity.dart';

import '../../http/api.dart';
import '../../model/match/match_intelligence_entity.dart';
import '../../util/utils.dart';

class SoccerMatchIntelligenceController extends GetxController {
  final _detailController =
      Get.find<SoccerMatchDetailController>(tag: '${Get.arguments}');

  Map<int, List<String>>? _intelligence;
  List<bool> _isSelected = [true,false];
  List<String> typeList = ["有利","不利"];
  int _currentIndex = 0;
  int _totalLength = 0;
  List<String> homeSuspend = [];
  List<String> guestSuspend = [];
  MatchIntelligenceEntity? _data;

  MatchInfoEntity? get detailInfo => _detailController.info;
  MatchIntelligenceEntity? get data => _data;
  int get totalLength => _totalLength;
  int get currentIndex => _currentIndex;
  List<bool> get isSelected => _isSelected;
  BaseInfo? get detail => _detailController.info?.baseInfo;
  Map<int, List<String>>? get intelligence => _intelligence;

  @override
  void onReady() async{
    await getMatchIntelligence();
    super.onReady();
  }

  Future getMatchIntelligence() async {
    final model = await Utils.tryOrNullf(() async {
      final result = await Api.getMatchIntelligence(_detailController.matchId);
      _data = result;
      var map = <int, List<String>>{
        0: [],
        1: [],
        2: [],
        3: []
      };
      var reg = RegExp(r"\d、");
      result?.homeFavourable?.split("\n").join().split(reg).forEach((element) {
        map[0]?.add(element);
      });
      result?.guestFavourable?.split("\n").join().split(reg).forEach((element) {
        map[1]?.add(element);
      });
      result?.homeUnFavourable?.split("\n").join().split(reg).forEach((element) {
        map[2]?.add(element);
      });
      result?.guestUnFavourable?.split("\n").join().split(reg).forEach((element) {
        map[3]?.add(element);
      });
      return map;
    });
    homeSuspend = _data?.homeInjury?.split(',').join().split("(").join().split(")").join().split(RegExp(r"[\f\r\n\t\v]+")) ?? [];
    guestSuspend = _data?.guestInjury?.split(',').join().split("(").join().split(")").join().split(RegExp(r"[\f\r\n\t\v]+")) ?? [];
    _intelligence = model;
    _intelligence?.values.forEach((element) {
      _totalLength += element.length;
    });
    update();
  }

  void changeChoice(int index){

    if(index == 1){
      _currentIndex = 2;
      _isSelected[1] = true;
      _isSelected[0] = false;
    }else{
      _currentIndex = 0;
      _isSelected[0] = true;
      _isSelected[1] = false;
    }
    update();
  }
}
