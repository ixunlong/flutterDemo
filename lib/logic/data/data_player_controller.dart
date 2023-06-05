import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/data/data_season_controller.dart';

import '../../model/data/data_player_entity.dart';
import '../../model/data/data_type_entity.dart';

class DataPlayerController extends GetxController {
  final String? seasonTag;
  DataPlayerController(this.leagueId, this.seasonTag);

  List<DataTypeEntity>? struct;
  List<String>? header;
  List<DataPlayerEntity>? playerAll;
  List<DataPlayerEntity>? playerHome;
  List<DataPlayerEntity>? playerGuest;
  int structIndex = 0;
  //0 1 2 全部 主场 客场
  int dataType = 0;
  int leagueId;
  bool visible = false;

  late DataSeasonController seasonC;

  // late final season =
  //     Get.find<DataTabPageController>(tag: league.currentLeagueId.toString());

  @override
  void onInit() {
    super.onInit();
    seasonC = Get.find<DataSeasonController>(tag: seasonTag);
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
        await Api.getPlayerStruct(seasonC.currentSeason, leagueId);
    if (data != null) {
      struct = data;
      update();
      if (struct!.isNotEmpty) {
        try {
          getPlayer();
        } catch (e) {}
      }
    }
  }

  void getPlayer({bool needLoading = true}) async {
    final result = await Api.getPlayerData(
        seasonC.currentSeason, leagueId, struct![structIndex].key!,
        needLoading: needLoading);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      header = result.data['d']['header'].cast<String>();
      List<DataPlayerEntity> all = result.data['d']['data']['all']
          .map<DataPlayerEntity>((e) => DataPlayerEntity.fromJson(e))
          .toList();
      playerAll = all;
      List<DataPlayerEntity> home = result.data['d']['data']['home']
          .map<DataPlayerEntity>((e) => DataPlayerEntity.fromJson(e))
          .toList();
      playerHome = home;
      List<DataPlayerEntity> guest = result.data['d']['data']['guest']
          .map<DataPlayerEntity>((e) => DataPlayerEntity.fromJson(e))
          .toList();
      playerGuest = guest;
      update();
    }
  }

  onSelectStruct(int index) {
    structIndex = index;
    update();
    getPlayer();
  }

  onSelectType(int type) {
    dataType = type;
    update();
  }

  List<DataPlayerEntity> getPlayerData() {
    List<DataPlayerEntity> data;
    if (dataType == 0) {
      data = playerAll ?? [];
    } else if (dataType == 1) {
      data = playerHome ?? [];
    } else {
      data = playerGuest ?? [];
    }
    return data;
  }
}
