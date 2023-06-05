import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports/http/api.dart';
import 'package:sports/logic/match/soccer_match_detail_controller.dart';
import 'package:sports/model/match/match_data_entity.dart';
import 'package:sports/model/match/match_point_entity.dart';
import 'package:sports/res/colours.dart';

// 初指 胜负
// odds1Win
// 0 odds1L 绿
// 1  odds1D 蓝
// 3 odds1W 红

// 让球 ah1
// 进球 sb1

class SoccerMatchDataController extends GetxController {
  bool firstInit = true;
  MatchDataEntity? data;
  MatchPointEntity? pointData;
  ShootTimeList? homeShootTime;
  ShootTimeList? guestShootTime;
  //积分排名类型 0杯赛 1联赛
  int pointType = 0;
  //联赛积分
  List<StandingPointList>? standingList1;
  List<StandingPointList>? standingHomeList1;
  List<StandingPointList>? standingGuestList1;
  List<StandingPointList>? standingList2;
  List<StandingPointList>? standingHomeList2;
  List<StandingPointList>? standingGuestList2;
  //联赛积分主客场 0全部 1主场 2客场
  int leagueHomeType = 0;
  int leagueGuestType = 0;
  //杯赛积分
  List<StandingPointList>? standingCupList1;
  List<StandingPointList>? standingCupList2;
  //交锋数据
  List<VsList>? vsList;
  //主队近期战绩
  List<VsList>? homeRecentVs;
  //客队近期战绩
  List<VsList>? guestRecentVs;
  //近期比赛
  // List<MatchList>? homeSchedule;
  // List<MatchList>? guestSchedule;
  //两队交锋同主客 同赛事
  bool _jiaofengSameHomeVs = false;
  bool _jiaofengsSameLeagueVs = false;
  //主队近期战绩 同主客 同赛事
  bool _homeSameHomeRecent = false;
  bool _homeSameLeagueRecent = false;
  //客队近期战绩 同主客 同赛事
  bool _guestSameHomeRecent = false;
  bool _guestSameLeagueRecent = false;
  //场次类型 1总场次 2主场场次 3客场场次
  int _shootTimeType1 = 1;
  //进球类型 1总进球 2第一个进球
  int _shootTimeType2 = 1;

  //type1 0初指 1终指
  //type2 0 6场 1 10场 2 20场
  int vsType1 = 0;
  int vsType2 = 1;
  int homeRecentType1 = 0;
  int homeRecentType2 = 1;
  int guestRecentType1 = 0;
  int guestRecentType2 = 1;

  SoccerMatchDataController();

  @override
  void onInit() {
    super.onInit();
    getMatchData();
  }

  void getMatchData() async {
    Api.getMatchData(int.parse('${Get.arguments}')).then((result) {
      firstInit = false;
      if (result != null) {
        data = result;
        getShootTime();
        // getLeagueList();
        getVsList();
        getHomeRecentVsList();
        getGuestRecentVsList();
      } else {
        data = MatchDataEntity();
      }
      update();
    });
    Api.getMatchPoint(int.parse('${Get.arguments}')).then((result) {
      firstInit = false;
      if (result != null) {
        pointData = result;
        // getShootTime();
        getLeagueList();
        // getVsList();
        // getHomeRecentVsList();
        // getGuestRecentVsList();
      } else {
        data = MatchDataEntity();
      }
      update();
    });
  }

  ///teamType 球队类型 1主队 2客队
  ///type1 场次类型 1总场次 2主场场次 3客场场次
  ///type2 进球类型 1总进球 2第一个进球
  void getShootTime() {
    if (data!.shootTimeList != null) {
      for (var shootTime in data!.shootTimeList!) {
        if (shootTime.teamType == 1 &&
            shootTime.type1 == _shootTimeType1 &&
            shootTime.type2 == _shootTimeType2) {
          homeShootTime = shootTime;
        } else if (shootTime.teamType == 2 &&
            shootTime.type1 == _shootTimeType1 &&
            shootTime.type2 == _shootTimeType2) {
          guestShootTime = shootTime;
        }
      }
    }
  }

  List<int> goalList(bool isHome) {
    if (homeShootTime == null || guestShootTime == null) {
      return [];
    }
    List<int> goal = [];
    if (isHome) {
      goal = [
        homeShootTime!.time1!,
        homeShootTime!.time2!,
        homeShootTime!.time3!,
        homeShootTime!.time4!,
        homeShootTime!.time5! + homeShootTime!.time6!,
        homeShootTime!.time7!,
        homeShootTime!.time8!,
        homeShootTime!.time9!,
        homeShootTime!.time10!
      ];
    } else {
      goal = [
        guestShootTime!.time1!,
        guestShootTime!.time2!,
        guestShootTime!.time3!,
        guestShootTime!.time4!,
        guestShootTime!.time5! + guestShootTime!.time6!,
        guestShootTime!.time7!,
        guestShootTime!.time8!,
        guestShootTime!.time9!,
        guestShootTime!.time10!
      ];
    }
    return goal;
  }

  getLeagueList() {
    standingList1 = pointData?.standingList1;
    standingList2 = pointData?.standingList2;
    standingCupList1 = pointData?.standingCupList1;
    standingCupList2 = pointData?.standingCupList2;
    if (pointData?.standingList1 != null) {
      List<StandingPointList> allList = [];
      List<StandingPointList> homeList = [];
      List<StandingPointList> guestList = [];
      pointData?.standingList1!.forEach((element) {
        if (element.type == 1) {
          allList.add(element);
        } else if (element.type == 3) {
          homeList.add(element);
        } else if (element.type == 4) {
          guestList.add(element);
        }
      });
      standingList1 = allList;
      standingHomeList1 = homeList;
      standingHomeList2 = guestList;
    }
    if (pointData?.standingList2 != null) {
      List<StandingPointList> allList = [];
      List<StandingPointList> homeList = [];
      List<StandingPointList> guestList = [];
      pointData?.standingList2!.forEach((element) {
        if (element.type == 1) {
          allList.add(element);
        } else if (element.type == 3) {
          homeList.add(element);
        } else if (element.type == 4) {
          guestList.add(element);
        }
      });
      standingList2 = allList;
      standingGuestList1 = homeList;
      standingGuestList2 = guestList;
    }
    if ((standingCupList1 != null &&
            standingCupList1!.first.sourceleagueId == data!.leagueId) ||
        (standingCupList2 != null &&
            standingCupList2!.first.sourceleagueId == data!.leagueId)) {
      pointType = 0;
      return;
    }
    //所在联赛id可能和比赛的联赛id不一样
    if ((standingList1 != null) || (standingList2 != null)) {
      pointType = 1;
      return;
    }

    // standingList = list;
  }

  //切换联赛杯赛
  changePointType(int type) {
    pointType = type;
    update();
  }

  //切换主客场
  changeLeagueType(int type, bool isHome) {
    if (isHome) {
      leagueHomeType = type;
    } else {
      leagueGuestType = type;
    }
    update();
  }

  getVsList() {
    int? homeId = data?.homeId;
    int? guestId = data?.guestId;
    List<VsList> vsListTemp = [];
    if (data!.vsList != null) {
      for (var vs in data!.vsList!) {
        bool canAdd = true;
        if (_jiaofengSameHomeVs) {
          if (vs.homeId != homeId || vs.guestId != guestId) {
            canAdd = false;
          }
        }
        if (_jiaofengsSameLeagueVs) {
          if (vs.leagueId != data?.leagueId) {
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

  ///进球失球
  ///0交锋1主队2客队
  List getGoalAndLost(int type) {
    int goal = 0;
    int lost = 0;
    List<VsList>? list;
    if (type == 0) {
      list = vsList;
    } else if (type == 1) {
      list = homeRecentVs;
    } else {
      list = guestRecentVs;
    }
    for (VsList vs in (list ?? [])) {
      if (type == 0 || type == 1) {
        if (vs.homeId == data?.homeId) {
          goal += vs.homeScore ?? 0;
          lost += vs.guestScore ?? 0;
        } else {
          goal += vs.guestScore ?? 0;
          lost += vs.homeScore ?? 0;
        }
      } else {
        if (vs.homeId == data?.guestId) {
          goal += vs.homeScore ?? 0;
          lost += vs.guestScore ?? 0;
        } else {
          goal += vs.guestScore ?? 0;
          lost += vs.homeScore ?? 0;
        }
      }
    }
    return [goal, lost];
  }

  //胜率
  List getOddsWinPercentage(int type) {
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
      if (vs.win == 3) {
        win++;
      } else if (vs.win == 1) {
        equal++;
      } else {
        lose++;
      }
    }
    double percentage =
        (win + equal + lose) == 0 ? 0 : win / (win + equal + lose) * 100;
    return [percentage.round(), win, equal, lose];
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
      if (vs.ah1Win == 3) {
        win++;
      } else if (vs.ah1Win == 1) {
        equal++;
      } else if (vs.ah1Win == 0) {
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
      if (vs.sb1Win == 3) {
        da++;
      } else if (vs.sb1Win == 1) {
        equal++;
      } else if (vs.sb1Win == 0) {
        xiao++;
      }
    }
    double percentage =
        (da + equal + xiao) == 0 ? 0 : da / (da + equal + xiao) * 100;
    return [percentage.round(), da, equal, xiao];
  }

  getHomeRecentVsList() {
    if (data!.homeVsList == null) {
      return;
    }
    int? homeId = data?.homeId;
    // int? guestId = data?.guestId;
    List<VsList> vsListTemp = [];
    for (var vs in data!.homeVsList!) {
      bool canAdd = true;
      if (_homeSameHomeRecent) {
        if (vs.homeId != homeId) {
          canAdd = false;
        }
      }
      if (_homeSameLeagueRecent) {
        if (vs.leagueId != data?.leagueId) {
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
    if (data!.guestVsList == null) {
      return;
    }
    // int? homeId = data?.homeId;
    int? guestId = data?.guestId;
    List<VsList> vsListTemp = [];
    for (var vs in data!.guestVsList!) {
      bool canAdd = true;
      if (_guestSameHomeRecent) {
        if (vs.guestId != guestId) {
          canAdd = false;
        }
      }
      if (_guestSameLeagueRecent) {
        if (vs.leagueId != data?.leagueId) {
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

  //选择场次 0全部 1主场 2客场
  // void selectChangci(int type) {
  //   leagueType = type;
  //   getLeagueList();
  //   update();
  // }

  //选择初指终指 type 0交锋 1主队近期战绩 2客队近期战绩
  void selectZhishu(int type, int zhishu) {
    if (type == 0) {
      vsType1 = zhishu;
      getVsList();
    } else if (type == 1) {
      homeRecentType1 = zhishu;
      getHomeRecentVsList();
    } else {
      guestRecentType1 = zhishu;
      getGuestRecentVsList();
    }
    update();
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
    if (win == 3) {
      color = Colours.main_color;
    } else if (win == 0) {
      color = Colours.green;
    } else if (win == 1) {
      color = Colours.guestColorBlue;
    }
    return color;
  }

  //欧赔 胜负
  ///0 交锋
  ///1 主队战绩
  ///2 客队战绩
  String getOddsWin(VsList vs, int type) {
    String str = '-';
    bool chuzhi = true;
    if (((type == 0 && vsType1 == 0) ||
        (type == 1 && homeRecentType1 == 0) ||
        (type == 2 && guestRecentType1 == 0))) {
      chuzhi = true;
    } else {
      chuzhi = false;
    }

    if (vs.odds1Win == null) {
      // str = '';
    } else {
      if (type == 2) {
        //客队近期战绩
        if (vs.win == 1) {
          str = chuzhi ? '${vs.odds1D!}' : '${vs.odds2D!}';
        } else if (vs.win == 3) {
          if (vs.homeId == data?.guestId) {
            str = chuzhi ? '${vs.odds1W!}' : '${vs.odds2W!}';
          } else {
            str = chuzhi ? '${vs.odds1L!}' : '${vs.odds2L!}';
          }
          // str = '${vs.odds1W!}';
        } else if (vs.win == 0) {
          if (vs.homeId == data?.guestId) {
            str = chuzhi ? '${vs.odds1L!}' : '${vs.odds2L!}';
          } else {
            str = chuzhi ? '${vs.odds1W!}' : '${vs.odds2W!}';
          }
        }
      } else {
        //交锋 主队近期
        if (vs.win == 1) {
          str = chuzhi ? '${vs.odds1D!}' : '${vs.odds2D!}';
        } else if (vs.win == 3) {
          if (vs.homeId == data?.homeId) {
            str = chuzhi ? '${vs.odds1W!}' : '${vs.odds2W!}';
          } else {
            str = chuzhi ? '${vs.odds1L!}' : '${vs.odds2L!}';
          }
          // str = '${vs.odds1W!}';
        } else if (vs.win == 0) {
          if (vs.homeId == data?.homeId) {
            str = chuzhi ? '${vs.odds1L!}' : '${vs.odds2L!}';
          } else {
            str = chuzhi ? '${vs.odds1W!}' : '${vs.odds2W!}';
          }
        }
      }
    }
    if (vs.win == 3) {
      str += '\n胜';
    } else if (vs.win == 1) {
      str += '\n平';
    } else {
      str += '\n负';
    }

    return str;
  }

  bool isEmpty() {
    if (data == null && pointData == null) {
      //未请求到数据
      return true;
    }
    if ((data?.shootTimeList == null || data!.shootTimeList!.length == 0) &&
        (pointData?.standingList1 == null ||
            pointData!.standingList1!.length == 0) &&
        (pointData?.standingList2 == null ||
            pointData!.standingList2!.length == 0) &&
        (pointData?.standingCupList1 == null ||
            pointData!.standingCupList1!.length == 0) &&
        (pointData?.standingCupList2 == null ||
            pointData!.standingCupList2!.length == 0) &&
        (data?.vsList == null || data!.vsList!.length == 0) &&
        (data?.homeVsList == null || data!.homeVsList!.length == 0) &&
        (data?.guestVsList == null || data!.guestVsList!.length == 0) &&
        (data?.homeMatchList == null || data!.homeMatchList!.length == 0) &&
        (data?.guestMatchList == null || data!.guestMatchList!.length == 0)) {
      return true;
    }

    return false;
  }

  //亚赔 让球
  String getAhWin(VsList vs, int type) {
    String str = '-';
    if (((type == 0 && vsType1 == 0) ||
        (type == 1 && homeRecentType1 == 0) ||
        (type == 2 && guestRecentType1 == 0))) {
      if (vs.ah1Win == 3) {
        str = '${vs.ah1!}\n赢';
      } else if (vs.ah1Win == 1) {
        str = '${vs.ah1!}\n走';
      } else if (vs.ah1Win == 0) {
        str = '${vs.ah1!}\n输';
      }
    } else {
      if (vs.ah2Win == 3) {
        str = '${vs.ah2!}\n赢';
      } else if (vs.ah2Win == 1) {
        str = '${vs.ah2!}\n走';
      } else if (vs.ah2Win == 0) {
        str = '${vs.ah2!}\n输';
      }
    }

    return str;
  }

  //大小球
  String getSbWin(VsList vs, int type) {
    String str = '-';
    if (((type == 0 && vsType1 == 0) ||
        (type == 1 && homeRecentType1 == 0) ||
        (type == 2 && guestRecentType1 == 0))) {
      if (vs.sb1Win == 3) {
        str = '${vs.sb1!}\n大';
      } else if (vs.sb1Win == 1) {
        str = '${vs.sb1!}\n走';
      } else if (vs.sb1Win == 0) {
        str = '${vs.sb1!}\n小';
      }
    } else {
      if (vs.sb2Win == 3) {
        str = '${vs.sb2!}\n大';
      } else if (vs.sb2Win == 1) {
        str = '${vs.sb2!}\n走';
      } else if (vs.sb2Win == 0) {
        str = '${vs.sb2!}\n小';
      }
    }

    return str;
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

  set shootTimeType1(int shootTimeType1) {
    _shootTimeType1 = shootTimeType1;
    getShootTime();
    update();
  }

  int get shootTimeType1 => _shootTimeType1;

  set shootTimeType2(int shootTimeType2) {
    _shootTimeType2 = shootTimeType2;
    getShootTime();
    update();
  }

  int get shootTimeType2 => _shootTimeType2;
}
