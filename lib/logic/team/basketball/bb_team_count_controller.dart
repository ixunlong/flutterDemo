import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/team/basketball/basket_team_detail_controller.dart';
import 'package:sports/model/team/bb_team/bb_team_count_entity.dart';
import 'package:sports/model/team/bb_team/bb_team_data_year_entity.dart';

class BbTeamCountController extends GetxController {
  TeamRank? teamRank;
  TeamData? teamData;
  // BbTeamCountEntity? list;
  List<BbTeamDataYearEntity>? yearData;
  int teamId = Get.arguments;

  //联赛队
  int scopeIndex1 = 0;
  int yearIndex1 = 0;
  int leagueIndex1 = 0;
  int scopeIndex2 = 0;
  int yearIndex2 = 0;
  int leagueIndex2 = 0;

  // //国家队
  int yearIndex3 = 0;
  int leagueIndex3 = 0;
  // int scopeIndex3 = 0;
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
    final result = await Api.getBasketTeamDataYear(teamId);
    if (result != null) {
      yearData = result;
      // update();
    }
  }

  //1排名 2数据
  getData({int? type}) async {
    if (yearData == null || yearData!.isEmpty) {
      update();
      return;
    }
    int yearIndex = 0;
    // int scopeIndex = 0;
    int scopeIndex = 0;
    int leagueIndex = 0;
    if (nation == 0) {
      yearIndex = yearIndex3;
      leagueIndex = leagueIndex3;
      if (type == 1) {
        scopeIndex = scopeIndex1;
      }
      if (type == 2) {
        scopeIndex = scopeIndex2;
      }
    } else {
      if (type == 1) {
        yearIndex = yearIndex1;
        leagueIndex = leagueIndex1;
        scopeIndex = scopeIndex1;
      }
      if (type == 2) {
        yearIndex = yearIndex2;
        leagueIndex = leagueIndex2;
        scopeIndex = scopeIndex2;
      }
    }
    final id = yearData![yearIndex].seasonId ?? 0;
    final leagueId = yearData![yearIndex].leagueInfo![leagueIndex].leagueId;
    final scopeList = type == 1
        ? getQiuduiScope()
        : yearData![yearIndex].leagueInfo![leagueIndex].scope!;
    final scopeId = scopeList[scopeIndex].scopeId;
    final stageId = scopeList[scopeIndex].stageId;
    final data = await Api.getBasketTeamStatistics(
        teamId, id, leagueId, scopeId, stageId);
    if (data != null) {
      if (type == 1) {
        teamRank = data.teamRank;
      } else if (type == 2) {
        teamData = data.teamData;
      } else {
        teamRank = data.teamRank;
        teamData = data.teamData;
      }

      // list = data;
      update();
    }
  }

  List getQiuduiScope() {
    final scopeList =
        List.from(yearData![yearIndex1].leagueInfo![leagueIndex1].scope!);
    scopeList
        .removeWhere((element) => element.scopeId == 6 || element.scopeId == 7);
    return scopeList;
  }

  void changeYear1(int index) {
    if (yearIndex1 != index) {
      yearIndex1 = index;
      getData(type: 1);
    }
  }

  void changeYear2(int index) {
    if (yearIndex2 != index) {
      yearIndex2 = index;
      getData(type: 2);
    }
  }

  // void changeSeason1(int index) {
  //   if (seasonIndex1 != index) {
  //     seasonIndex1 = index;
  //     getData(type: 1);
  //   }
  // }

  void changeScope1(int index) {
    if (scopeIndex1 != index) {
      scopeIndex1 = index;
      getData(type: 1);
    }
  }

  void changeScope2(int index) {
    if (scopeIndex2 != index) {
      scopeIndex2 = index;
      getData(type: 2);
    }
  }

  // void changeSeason2(int index) {
  //   if (seasonIndex2 != index) {
  //     seasonIndex2 = index;
  //     getData(type: 2);
  //   }
  // }
}
