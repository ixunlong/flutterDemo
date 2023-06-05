import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/model/basketball/bb_match_detail_entity.dart';
import 'package:sports/model/match/basket_match_data_entity.dart';
import 'package:sports/model/match/basket_match_data_team_entity.dart';
import 'package:sports/model/match/basket_match_data_temavg_entity.dart';
import 'package:sports/model/match/bb_match_data_compare_entity.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/utils.dart';
import 'package:sports/view/match_detail/basketball_match_detail/bb_detail_page.dart';

class BasketMatchDataController extends GetxController {
  int matchId = Get.arguments;
  bool firstInit = true;
  // BbMatchDetailEntity? detail = Get.find<BbDetailController>().detial;
  BasketMatchDataTeamEntity? teamData;
  BasketMatchDataTeamAvgEntity? avgData;
  BasketMatchDataEntity? data;
  int currentTab = 0;
  // int homeId = 0;
  // int guestId = 0;
  // int leagueId = 1;

  //大小球 1大 2小 3走
  //让分 11赢 12输 13平

  //交锋数据
  List<VsList>? vsList;
  //主队近期战绩
  List<VsList>? homeRecentVs;
  //客队近期战绩
  List<VsList>? guestRecentVs;
  //两队交锋同主客 同赛事
  bool _jiaofengSameHomeVs = false;
  bool _jiaofengsSameLeagueVs = false;
  //主队近期战绩 同主客 同赛事
  bool _homeSameHomeRecent = false;
  bool _homeSameLeagueRecent = false;
  //客队近期战绩 同主客 同赛事
  bool _guestSameHomeRecent = false;
  bool _guestSameLeagueRecent = false;

  //type1 0初指 1终指
  //type2 0 6场 1 10场 2 20场
  // int vsType1 = 0;
  int vsType2 = 1;
  // int homeRecentType1 = 0;
  int homeRecentType2 = 1;
  // int guestRecentType1 = 0;
  int guestRecentType2 = 1;

  @override
  void onReady() {
    super.onReady();
    getTeamCompare();
    // getTeamAvg();
    getTeamMatch();
  }

  // void getTeamAvg() async {
  //   BasketMatchDataTeamAvgEntity? result = await Api.getTeamAvg(matchId);
  //   if (result != null) {
  //     avgData = result;
  //     configData();
  //     update();
  //   }
  // }

  void getTeamCompare() async {
    BbMatchDataCompareEntity? result = await Api.getTeamCompare(matchId);
    if (result != null) {
      firstInit = false;
      avgData = result.appBbMatchAvgData;
      teamData = result.appTeamSimple;
      configData();
      update();
    }
  }

  // void getTeamInfo() async {
  //   BasketMatchDataTeamEntity? result = await Api.getTeamSimple(matchId);
  //   if (result != null) {
  //     teamData = result;
  //     configData();
  //     update();
  //   }
  // }

  void getTeamMatch() async {
    BasketMatchDataEntity? result = await Api.getTeamMatchData(matchId);
    if (result != null) {
      firstInit = false;
      data = result;
      getVsList();
      getHomeRecentVsList();
      getGuestRecentVsList();
      update();
    }
  }

  void configData() {
    if (avgData != null && teamData != null) {
      if (teamInfoEmpty() && !teamAvgEmpty()) {
        currentTab = 1;
      }
    }
  }

  bool isEmpty() {
    if (data == null) {
      //未请求到数据
      return true;
    }
    if (teamInfoEmpty() &&
        teamAvgEmpty() &&
        data?.homeHistory.hasValue == false &&
        data?.homeFuture.hasValue == false &&
        data?.awayHistory.hasValue == false &&
        data?.awayFuture.hasValue == false &&
        data?.vsHistory.hasValue == false) {
      return true;
    }

    return false;
  }

  bool teamInfoEmpty({bool includeRecent = true}) {
    bool homeEmpty = teamData?.homeInfo?.record == null &&
        teamData?.homeInfo?.wonRate == null &&
        teamData?.homeInfo?.gameBack == null &&
        (includeRecent ? teamData?.homeInfo?.recentRecord == null : true) &&
        teamData?.homeInfo?.pointsLostAvg == null &&
        teamData?.homeInfo?.avgScore == null &&
        teamData?.homeInfo?.tenRecord == null &&
        teamData?.homeInfo?.homeRecord == null &&
        teamData?.homeInfo?.awayRecord == null;
    bool awayEmpty = teamData?.awayInfo?.record == null &&
        teamData?.awayInfo?.wonRate == null &&
        teamData?.awayInfo?.gameBack == null &&
        (includeRecent ? teamData?.homeInfo?.recentRecord == null : true) &&
        teamData?.awayInfo?.pointsLostAvg == null &&
        teamData?.awayInfo?.avgScore == null &&
        teamData?.awayInfo?.tenRecord == null &&
        teamData?.awayInfo?.homeRecord == null &&
        teamData?.awayInfo?.awayRecord == null;
    return homeEmpty && awayEmpty;
  }

  bool teamAvgEmpty() {
    return avgData?.home == null && avgData?.away == null;
  }

  List<List> getTeamInfoData() {
    // int num = 0;
    List<List> data = [];
    if (teamData?.awayInfo?.avgScore != null ||
        teamData?.homeInfo?.avgScore != null) {
      data.add([
        "场均得分",
        teamData?.awayInfo?.avgScore ?? '0',
        teamData?.homeInfo?.avgScore ?? '0'
      ]);
    }
    if (teamData?.awayInfo?.pointsLostAvg != null ||
        teamData?.homeInfo?.pointsLostAvg != null) {
      data.add([
        "场均失分",
        teamData?.awayInfo?.pointsLostAvg ?? '0',
        teamData?.homeInfo?.pointsLostAvg ?? '0'
      ]);
    }
    if (teamData?.awayInfo?.wonRate != null ||
        teamData?.homeInfo?.wonRate != null) {
      data.add([
        "胜率",
        teamData?.awayInfo?.wonRate ?? '0',
        teamData?.homeInfo?.wonRate ?? '0'
      ]);
    }
    if (teamData?.awayInfo?.tenRecord != null ||
        teamData?.homeInfo?.tenRecord != null) {
      data.add([
        "近10场",
        teamData?.awayInfo?.tenRecord ?? '0',
        teamData?.homeInfo?.tenRecord ?? '0'
      ]);
    }
    if (teamData?.awayInfo?.homeRecord != null ||
        teamData?.homeInfo?.homeRecord != null) {
      data.add([
        "主场",
        teamData?.awayInfo?.homeRecord ?? '0',
        teamData?.homeInfo?.homeRecord ?? '0'
      ]);
    }
    if (teamData?.awayInfo?.awayRecord != null ||
        teamData?.homeInfo?.awayRecord != null) {
      data.add([
        "客场",
        teamData?.awayInfo?.awayRecord ?? '0',
        teamData?.homeInfo?.awayRecord ?? '0'
      ]);
    }
    if (teamData?.awayInfo?.gameBack != null ||
        teamData?.homeInfo?.gameBack != null) {
      data.add([
        "胜差",
        teamData?.awayInfo?.gameBack ?? '0',
        teamData?.homeInfo?.gameBack ?? '0'
      ]);
    }

    return data;
  }

  // bool hasAvgData() {
  //   if (avgData?.away?.points != null || avgData?.home?.points != null) {
  //     return true;
  //   }
  //   if (avgData?.away?.rebounds != null || avgData?.home?.rebounds != null) {
  //     return true;
  //   }
  //   if (avgData?.away?.assists != null || avgData?.home?.assists != null) {
  //     return true;
  //   }
  //   if (avgData?.away?.blocks != null || avgData?.home?.blocks != null) {
  //     return true;
  //   }
  //   if (avgData?.away?.steals != null || avgData?.home?.steals != null) {
  //     return true;
  //   }
  //   if (avgData?.away?.turnovers != null || avgData?.home?.turnovers != null) {
  //     return true;
  //   }
  //   if (avgData?.away?.threePointsTotal != null ||
  //       avgData?.home?.threePointsTotal != null) {
  //     return true;
  //   }
  //   if (avgData?.away?.twoPointsTotal != null ||
  //       avgData?.home?.twoPointsTotal != null) {
  //     return true;
  //   }
  //   if (avgData?.away?.freeThrowsTotal != null ||
  //       avgData?.home?.freeThrowsTotal != null) {
  //     return true;
  //   }
  //   if (avgData?.away?.fieldGoalsScored != null ||
  //       avgData?.home?.fieldGoalsScored != null) {
  //     return true;
  //   }
  //   return false;
  // }

  List<List> getTeamAvgData() {
    // int num = '0';
    List<List> list = [];
    if (avgData?.away?.points != null || avgData?.home?.points != null) {
      list.add(
          ["得分", avgData?.away?.points ?? '0', avgData?.home?.points ?? '0']);
    }
    if (avgData?.away?.rebounds != null || avgData?.home?.rebounds != null) {
      list.add([
        "篮板",
        avgData?.away?.rebounds ?? '0',
        avgData?.home?.rebounds ?? '0'
      ]);
    }
    if (avgData?.away?.assists != null || avgData?.home?.assists != null) {
      list.add(
          ["助攻", avgData?.away?.assists ?? '0', avgData?.home?.assists ?? '0']);
    }
    if (avgData?.away?.blocks != null || avgData?.home?.blocks != null) {
      list.add(
          ["盖帽", avgData?.away?.blocks ?? '0', avgData?.home?.blocks ?? '0']);
    }
    if (avgData?.away?.steals != null || avgData?.home?.steals != null) {
      list.add(
          ["抢断", avgData?.away?.steals ?? '0', avgData?.home?.steals ?? '0']);
    }
    if (avgData?.away?.turnovers != null || avgData?.home?.turnovers != null) {
      list.add([
        "失误",
        avgData?.away?.turnovers ?? '0',
        avgData?.home?.turnovers ?? '0'
      ]);
    }
    if (avgData?.away?.threePointsTotal != null ||
        avgData?.home?.threePointsTotal != null) {
      list.add([
        "三分命中率",
        avgData?.away?.threePointsTotal ?? '0',
        avgData?.home?.threePointsTotal ?? '0'
      ]);
    }
    if (avgData?.away?.twoPointsTotal != null ||
        avgData?.home?.twoPointsTotal != null) {
      list.add([
        "两分命中率",
        avgData?.away?.twoPointsTotal ?? '0',
        avgData?.home?.twoPointsTotal ?? '0'
      ]);
    }
    if (avgData?.away?.freeThrowsTotal != null ||
        avgData?.home?.freeThrowsTotal != null) {
      list.add([
        "罚球命中数",
        avgData?.away?.freeThrowsTotal ?? '0',
        avgData?.home?.freeThrowsTotal ?? '0'
      ]);
    }
    if (avgData?.away?.fieldGoalsScored != null ||
        avgData?.home?.fieldGoalsScored != null) {
      list.add([
        "投篮命中率",
        avgData?.away?.fieldGoalsScored ?? '0',
        avgData?.home?.fieldGoalsScored ?? '0'
      ]);
    }

    return list;
  }

  getVsList() {
    // int? homeId = data?.homeId;
    // int? guestId = data?.guestId;
    List<VsList> vsListTemp = [];
    if (data!.vsHistory != null) {
      for (var vs in data!.vsHistory!) {
        bool canAdd = true;
        if (_jiaofengSameHomeVs) {
          if (vs.homeQxbId != data?.currentMatchInfo?.homeQxbTeamId ||
              vs.awayQxbId != data?.currentMatchInfo?.awayQxbTeamId) {
            canAdd = false;
          }
        }
        if (_jiaofengsSameLeagueVs) {
          if (vs.leagueQxbId != data?.currentMatchInfo?.leagueQxbId) {
            canAdd = false;
          }
        }
        if (canAdd) {
          vsListTemp.add(vs);
        }
        if (vsType2 == 0 && vsListTemp.length >= 6) {
          break;
        } else if (vsType2 == 1 && vsListTemp.length >= 10) {
          break;
        } else if (vsListTemp.length >= 20) {
          break;
        }
      }
    }

    vsList = vsListTemp;
  }

  getHomeRecentVsList() {
    if (data!.homeFuture == null) {
      return;
    }
    // int? homeId = homeId;
    // int? guestId = data?.guestId;
    List<VsList> vsListTemp = [];
    for (var vs in data!.homeHistory!) {
      bool canAdd = true;
      if (_homeSameHomeRecent) {
        if (vs.homeQxbId != data?.currentMatchInfo?.homeQxbTeamId) {
          canAdd = false;
        }
      }
      if (_homeSameLeagueRecent) {
        if (vs.leagueQxbId != data?.currentMatchInfo?.leagueQxbId) {
          canAdd = false;
        }
      }
      if (canAdd) {
        vsListTemp.add(vs);
      }

      if (homeRecentType2 == 0 && vsListTemp.length >= 6) {
        break;
      } else if (homeRecentType2 == 1 && vsListTemp.length >= 10) {
        break;
      } else if (vsListTemp.length >= 20) {
        break;
      }
    }
    homeRecentVs = vsListTemp;
  }

  getGuestRecentVsList() {
    if (data!.awayHistory == null) {
      return;
    }
    // int? homeId = data?.homeId;
    // int? guestId = data?.guestId;
    List<VsList> vsListTemp = [];
    for (var vs in data!.awayHistory!) {
      bool canAdd = true;
      if (_guestSameHomeRecent) {
        if (vs.awayQxbId != data?.currentMatchInfo?.awayQxbTeamId) {
          canAdd = false;
        }
      }
      if (_guestSameLeagueRecent) {
        if (vs.leagueQxbId != data?.currentMatchInfo?.leagueQxbId) {
          canAdd = false;
        }
      }
      if (canAdd) {
        vsListTemp.add(vs);
      }

      if (guestRecentType2 == 0 && vsListTemp.length >= 6) {
        break;
      } else if (guestRecentType2 == 1 && vsListTemp.length >= 10) {
        break;
      } else if (vsListTemp.length >= 20) {
        break;
      }
    }
    guestRecentVs = vsListTemp;
  }

  //胜率
  List getOddsWinPercentage(int type) {
    int win = 0;
    int lose = 0;
    List<VsList>? list;
    if (type == 0) {
      list = vsList;
    } else if (type == 1) {
      list = homeRecentVs;
    } else {
      list = guestRecentVs;
    }
    for (VsList vs in (list ?? [])) {
      if (vs.homeWin == 1) {
        win++;
      } else {
        lose++;
      }
    }
    double percentage = (win + lose) == 0 ? 0 : win / (win + lose) * 100;
    return [percentage.round(), win, lose];
  }

  //赢率
  List getAhWinPercentage(int type) {
    int win = 0;
    int equal = 0;
    int lose = 0;
    List<VsList>? list;
    if (type == 0) {
      list = vsList;
    } else if (type == 1) {
      list = homeRecentVs;
    } else {
      list = guestRecentVs;
    }
    for (VsList vs in (list ?? [])) {
      if (vs.ypStatus == 11) {
        win++;
      } else if (vs.ypStatus == 13) {
        equal++;
      } else if (vs.ypStatus == 12) {
        lose++;
      }
    }
    double percentage =
        (win + equal + lose) == 0 ? 0 : win / (win + equal + lose) * 100;
    return [percentage.round(), win, equal, lose];
  }

  //大小球率
  List getSbWinPercentage(int type) {
    int da = 0;
    int equal = 0;
    int xiao = 0;
    List<VsList>? list;
    if (type == 0) {
      list = vsList;
    } else if (type == 1) {
      list = homeRecentVs;
    } else {
      list = guestRecentVs;
    }
    for (VsList vs in (list ?? [])) {
      if (vs.dxStatus == 1) {
        da++;
      } else if (vs.dxStatus == 3) {
        equal++;
      } else if (vs.dxStatus == 2) {
        xiao++;
      }
    }
    double percentage =
        (da + equal + xiao) == 0 ? 0 : da / (da + equal + xiao) * 100;
    return [percentage.round(), da, equal, xiao];
  }

  //单率
  List getDlPercentage(int type) {
    int dan = 0;
    int shuang = 0;
    List<VsList>? list;
    if (type == 0) {
      list = vsList;
    } else if (type == 1) {
      list = homeRecentVs;
    } else {
      list = guestRecentVs;
    }
    for (VsList vs in (list ?? [])) {
      int score = vs.homeScore.toInt()! + vs.awayScore.toInt()!;
      if (score % 2 == 1) {
        dan++;
      } else {
        shuang++;
      }
    }
    double percentage = (dan + shuang) == 0 ? 0 : dan / (dan + shuang) * 100;
    return [percentage.round(), dan, shuang];
  }

  //亚赔 让球
  String getAhWin(VsList vs, int type) {
    // String str = '-';
    // if (vs.ypStatus == 11) {
    //   str = '${vs.ypLine!}\n赢';
    // } else if (vs.ypStatus == 13) {
    //   str = '${vs.ypLine!}\n走';
    // } else if (vs.ypStatus == 12) {
    //   str = '${vs.ypLine!}\n输';
    // }
    if (vs.ypLine == null && vs.ypStatusCn == null) {
      return '-';
    }

    return '${vs.ypLine ?? '-'}\n${vs.ypStatusCn ?? '-'}';
  }

  //大小球
  String getSbWin(VsList vs, int type) {
    if (vs.dxLine == null && vs.dxStatusCn == null) {
      return '-';
    }
    return '${vs.dxLine ?? '-'}\n${vs.dxStatusCn ?? '-'}';
    // String str = '-';
    // if (vs.dxStatus == 1) {
    //   str = '${vs.dxLine!}\n大';
    // } else if (vs.dxStatus == 3) {
    //   str = '${vs.dxLine!}\n走';
    // } else if (vs.dxLine == 2) {
    //   str = '${vs.dxStatus!}\n小';
    // }
  }

  //选择场数 type 0交锋 1主队近期战绩 2客队近期战绩
  void selectMatchNumType(int type, int numType) {
    if (type == 0) {
      vsType2 = numType;
      getVsList();
    } else if (type == 1) {
      homeRecentType2 = numType;
      getHomeRecentVsList();
    } else {
      guestRecentType2 = numType;
      getGuestRecentVsList();
    }
    update();
  }

  //310 胜平负
  Color getColor(int? win) {
    Color color = Colours.text_color1;
    if (win == 1) {
      color = Colours.main_color;
    } else {
      color = Colours.green;
    }
    return color;
  }

  Color getYpColor(int? status) {
    Color color = Colours.text_color1;
    if (status == 11) {
      color = Colours.main_color;
    } else if (status == 12) {
      color = Colours.green;
    } else {
      color = Colours.guestColorBlue;
    }
    return color;
  }

  Color getDxColor(int? status) {
    Color color = Colours.text_color1;
    if (status == 1) {
      color = Colours.main_color;
    } else if (status == 2) {
      color = Colours.green;
    } else {
      color = Colours.guestColorBlue;
    }
    return color;
  }

  set jiaofengSameHomeVs(bool jiaofengSameHomeVs) {
    _jiaofengSameHomeVs = jiaofengSameHomeVs;
    getVsList();
    update();
  }

  bool get jiaofengSameHomeVs => _jiaofengSameHomeVs;

  set jiaofengsSameLeagueVs(bool jiaofengsSameLeagueVs) {
    _jiaofengsSameLeagueVs = jiaofengsSameLeagueVs;
    getVsList();
    update();
  }

  bool get jiaofengsSameLeagueVs => _jiaofengsSameLeagueVs;

  set homeSameHomeRecent(bool homeSameHomeRecent) {
    _homeSameHomeRecent = homeSameHomeRecent;
    getHomeRecentVsList();
    update();
  }

  bool get homeSameHomeRecent => _homeSameHomeRecent;

  set homeSameLeagueRecent(bool homeSameLeagueRecent) {
    _homeSameLeagueRecent = homeSameLeagueRecent;
    getHomeRecentVsList();
    update();
  }

  bool get homeSameLeagueRecent => _homeSameLeagueRecent;

  set guestSameHomeRecent(bool guestSameHomeRecent) {
    _guestSameHomeRecent = guestSameHomeRecent;
    getGuestRecentVsList();
    update();
  }

  bool get guestSameHomeRecent => _guestSameHomeRecent;

  set guestSameLeagueRecent(bool guestSameLeagueRecent) {
    _guestSameLeagueRecent = guestSameLeagueRecent;
    getGuestRecentVsList();
    update();
  }

  bool get guestSameLeagueRecent => _guestSameLeagueRecent;
}
