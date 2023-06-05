import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/data/league_list_entity.dart';
import 'package:sports/util/sp_utils.dart';

class MatchService extends GetxService {
  //一级 热门
  LeagueListEntity? oneLevelData;
  LeagueListEntity? basketOneLevelData;

  Future<MatchService> init() async {
    getOneLevelLeague();
    getBasketOneLevelLeague();
    return this;
  }

  getOneLevelLeague() async {
    if (SpUtils.matchOneLevelKey != null) {
      oneLevelData = LeagueListEntity.fromJson(SpUtils.matchOneLevelKey!);
    }
    final result = await Api.getLeagueList();
    if (result != null) {
      oneLevelData = result;
      SpUtils.matchOneLevelKey = result.toJson();
    }
  }

  getBasketOneLevelLeague() async {
    if (SpUtils.basketOneLevelKey != null) {
      basketOneLevelData =
          LeagueListEntity.fromJson(SpUtils.basketOneLevelKey!);
    }
    final result = await Api.getBasketLeagueList();
    if (result != null) {
      basketOneLevelData = result;
      SpUtils.basketOneLevelKey = result.toJson();
    }
  }
}
