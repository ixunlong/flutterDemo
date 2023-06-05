import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/team/basketball/basket_team_detail_controller.dart';
import 'package:sports/model/team/bb_team/bb_team_data_year_entity.dart';
import 'package:sports/model/team/bb_team/bb_team_player_entity.dart';

class BbTeamLineupController extends GetxController {
  List<BbTeamPlayerEntity>? list;
  List<BbTeamDataYearEntity>? yearData;

  int teamId = Get.arguments;
  //常规赛 季前赛
  int scopeIndex = 0;
  int yearIndex = 0;
  int leagueIndex = 0;
  int nation = 0;

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    final controller = Get.find<BasketTeamDetailController>(tag: '$teamId');
    nation = controller.data?.national ?? 0;
    await getTeamYear();
    getData();
  }

  Future getTeamYear() async {
    final result = await Api.getBasketTeamLineupYear(teamId);
    if (result != null) {
      yearData = result;
      // update();
    }
  }

  getData() async {
    if (yearData == null || yearData!.isEmpty) {
      update();
      return;
    }
    final league = yearData![yearIndex].leagueInfo;
    final data = await Api.getBasketTeamLineup(
        teamId,
        yearData![yearIndex].seasonId,
        league![leagueIndex].leagueId,
        league[leagueIndex].scope![scopeIndex].scopeId);
    if (data != null) {
      list = data;
      update();
    }
  }

  void changeLeague(int index) {
    if (leagueIndex != index) {
      leagueIndex = index;
      getData();
    }
  }

  void changeYear(int index) {
    if (yearIndex != index) {
      yearIndex = index;
      getData();
    }
  }

  void changeScope(int index) {
    if (scopeIndex != index) {
      scopeIndex = index;
      getData();
    }
  }
}
