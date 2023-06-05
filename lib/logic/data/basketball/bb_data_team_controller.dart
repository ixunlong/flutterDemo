import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/data/data_team_entity.dart';
import 'package:sports/model/data/data_type_entity.dart';

import 'bb_data_season_controller.dart';

class BbDataTeamController extends GetxController {
  final String? seasonTag;
  BbDataTeamController(this.leagueId, this.seasonTag);
  bool visible = false;
  List<DataTypeEntity>? struct;
  List<String>? header;
  List<DataTeamEntity>? teamAll;
  List<DataTeamEntity>? teamHome;
  List<DataTeamEntity>? teamGuest;
  int structIndex = 0;

  late BbDataSeasonController seasonC;
  late int leagueId;

  @override
  void onInit() {
    super.onInit();
    seasonC = Get.find<BbDataSeasonController>(tag: seasonTag);
    var currentSeason = seasonC.currentSeason;
    seasonC.addListener(() {
      if (currentSeason != seasonC.currentSeason) {
        getStruct();
        currentSeason = seasonC.currentSeason;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    getStruct();
  }

  void getStruct() async {
    List<DataTypeEntity>? data =
        await Api.getBbTeamStruct(seasonC.currentSeason, leagueId);
    if (data != null) {
      struct = data;
      update();
      getTeam();
    }
  }

  void getTeam({bool needLoading = true}) async {
    if (struct!.length == 0) {
      teamAll = [];
      return;
    }
    final result = await Api.getBbTeamData(
        seasonC.currentSeason, leagueId, struct![structIndex].key!,
        needLoading: needLoading);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      header = result.data['d']['header'].cast<String>();
      List<DataTeamEntity> all = result.data['d']['data']['all']
          .map<DataTeamEntity>((e) => DataTeamEntity.fromJson(e))
          .toList();
      teamAll = all;
      // List<DataTeamEntity> home = result.data['d']['data']['home']
      //     .map<DataTeamEntity>((e) => DataTeamEntity.fromJson(e))
      //     .toList();
      // teamHome = home;
      // List<DataTeamEntity> guest = result.data['d']['data']['guest']
      //     .map<DataTeamEntity>((e) => DataTeamEntity.fromJson(e))
      //     .toList();
      // teamGuest = guest;
      update();
    }
  }

  onSelectStruct(int index) {
    structIndex = index;
    update();
    getTeam();
  }
}
