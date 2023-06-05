import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/data/basketball/bb_data_season_controller.dart';
import 'package:sports/logic/data/data_season_controller.dart';
import 'package:sports/model/data/basket/bb_data_player_entity.dart';
import 'package:sports/model/data/data_player_entity.dart';
import 'package:sports/model/data/data_type_entity.dart';
import 'bb_data_season_controller.dart';

class BbDataPlayerController extends GetxController {
  final String? seasonTag;
  BbDataPlayerController(this.leagueId, this.seasonTag);

  List<DataTypeEntity>? struct;
  List<String>? header;
  List<BbDataPlayerEntity>? playerAll;
  List<BbDataPlayerEntity>? playerHome;
  List<BbDataPlayerEntity>? playerGuest;
  int structIndex = 0;
  //0 1 2 全部 主场 客场
  int dataType = 0;
  int leagueId;
  bool visible = false;

  late BbDataSeasonController seasonC;

  // late final season =
  //     Get.find<DataTabPageController>(tag: league.currentLeagueId.toString());

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
        await Api.getBasketPlayerStruct(seasonC.currentSeason, leagueId);
    if (data != null) {
      struct = data;
      update();
      if (struct!.isNotEmpty) {
        getPlayer();
      }
    }
  }

  void getPlayer({bool needLoading = true}) async {
    final result = await Api.getBasketPlayerData(
        seasonC.currentSeason, leagueId, struct![structIndex].key!,
        needLoading: needLoading);
    if (result.statusCode == 200 && result.data['c'] == 200) {
      header = result.data['d']['header'].cast<String>();
      List<BbDataPlayerEntity> all = result.data['d']['data']['all']
          .map<BbDataPlayerEntity>((e) => BbDataPlayerEntity.fromJson(e))
          .toList();
      playerAll = all;
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

  List<BbDataPlayerEntity> getPlayerData() {
    List<BbDataPlayerEntity> data;
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
