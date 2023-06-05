//     TYPE_0(0, "比赛异常"),
//     TYPE_1(1, "未开赛"),
//     TYPE_2(2, "第一节"),
//     TYPE_3(3, "第一节完"),
//     TYPE_4(4, "第二节"),
//     TYPE_5(5, "第二节完"),
//     TYPE_6(6, "第三节"),
//     TYPE_7(7, "第三节完"),
//     TYPE_8(8, "第四节"),
//     TYPE_9(9, "加时"),
//     TYPE_10(10, "完场"),
//     TYPE_11(11, "中断"),
//     TYPE_12(12, "取消"),
//     TYPE_13(13, "延期"),
//     TYPE_14(14, "腰斩"),
//     TYPE_15(15, "待定"),
import 'package:sports/model/match/match_entity.dart';

class BasketListEntity with BbMix {
  AppMatchScore? appMatchScore;
  int? id;
  int? leagueId;
  String? leagueName;
  String? leagueColor;
  String? jcNo;
  String? matchHour;
  String? matchWeek;
  String? matchTime;
  String? show;
  String? color;
  int? statusId;
  String? matchPursueScore;
  String? matchScore;
  String? homeScore;
  String? awayScore;
  int? homeTeamId;
  String? homeName;
  String? homeLogo;
  String? homePosition;
  int? awayTeamId;
  String? awayName;
  String? awayLogo;
  String? awayPosition;
  int? intelligence;
  int? lineup;
  int? needPeriod;
  int? periodCount;
  String? homeInfoRecentRecord;
  String? awayInfoRecentRecord;
  int? planCnt;
  List<OddsList>? oddsList;
  int? video;

  BasketListEntity(
      {this.appMatchScore,
      this.id,
      this.leagueId,
      this.leagueName,
      this.leagueColor,
      this.jcNo,
      this.matchHour,
      this.matchWeek,
      this.matchTime,
      this.show,
      this.color,
      this.statusId,
      this.matchPursueScore,
      this.matchScore,
      this.homeScore,
      this.awayScore,
      this.homeTeamId,
      this.homeName,
      this.homeLogo,
      this.homePosition,
      this.awayTeamId,
      this.awayName,
      this.awayLogo,
      this.awayPosition,
      this.intelligence,
      this.lineup,
      this.needPeriod,
      this.periodCount,
      this.homeInfoRecentRecord,
      this.awayInfoRecentRecord,
      this.planCnt,
      this.oddsList,
      this.video});

  BasketListEntity.fromJson(Map<String, dynamic> json) {
    appMatchScore = json['appMatchScore'] != null
        ? new AppMatchScore.fromJson(json['appMatchScore'])
        : null;
    id = json['id'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    leagueColor = json['leagueColor'];
    jcNo = json['jcNo'];
    matchHour = json['matchHour'];
    matchWeek = json['matchWeek'];
    matchTime = json['matchTime'];
    show = json['show'];
    color = json['color'];
    statusId = json['statusId'];
    matchPursueScore = json['matchPursueScore'];
    matchScore = json['matchScore'];
    homeScore = json['homeScore'];
    awayScore = json['awayScore'];
    homeTeamId = json['homeTeamId'];
    homeName = json['homeName'];
    homeLogo = json['homeLogo'];
    homePosition = json['homePosition'];
    awayTeamId = json['awayTeamId'];
    awayName = json['awayName'];
    awayLogo = json['awayLogo'];
    awayPosition = json['awayPosition'];
    intelligence = json['intelligence'];
    lineup = json['lineup'];
    needPeriod = json['needPeriod'];
    periodCount = json['periodCount'];
    homeInfoRecentRecord = json['homeInfoRecentRecord'];
    awayInfoRecentRecord = json['awayInfoRecentRecord'];
    planCnt = json['planCnt'];
    video = json['video'];
    if (json['oddsList'] != null) {
      oddsList = <OddsList>[];
      json['oddsList'].forEach((v) {
        oddsList!.add(new OddsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appMatchScore != null) {
      data['appMatchScore'] = this.appMatchScore!.toJson();
    }
    data['id'] = this.id;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['leagueColor'] = this.leagueColor;
    data['jcNo'] = this.jcNo;
    data['matchHour'] = this.matchHour;
    data['matchWeek'] = this.matchWeek;
    data['matchTime'] = this.matchTime;
    data['show'] = this.show;
    data['color'] = this.color;
    data['statusId'] = this.statusId;
    data['matchPursueScore'] = this.matchPursueScore;
    data['matchScore'] = this.matchScore;
    data['homeScore'] = this.homeScore;
    data['awayScore'] = this.awayScore;
    data['homeTeamId'] = this.homeTeamId;
    data['homeName'] = this.homeName;
    data['homeLogo'] = this.homeLogo;
    data['homePosition'] = this.homePosition;
    data['awayTeamId'] = this.awayTeamId;
    data['awayName'] = this.awayName;
    data['awayLogo'] = this.awayLogo;
    data['awayPosition'] = this.awayPosition;
    data['intelligence'] = this.intelligence;
    data['lineup'] = this.lineup;
    data['needPeriod'] = this.needPeriod;
    data['homeInfoRecentRecord'] = this.homeInfoRecentRecord;
    data['awayInfoRecentRecord'] = this.awayInfoRecentRecord;
    data['planCnt'] = this.planCnt;
    data['video'] = this.video;
    if (this.oddsList != null) {
      data['oddsList'] = this.oddsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

mixin BbMix {
  bool lastMatchInDay = false;
}

class AppMatchScore {
  String? awayFoul;
  String? awayFour;
  String? awayOne;
  String? awayOt;
  String? awayScore;
  String? awayThree;
  String? awayTimeOut;
  String? awayTwo;
  String? homeFoul;
  String? homeFour;
  String? homeOne;
  String? homeOt;
  String? homeScore;
  String? homeThree;
  String? homeTimeOut;
  String? homeTwo;

  AppMatchScore(
      {this.awayFoul,
      this.awayFour,
      this.awayOne,
      this.awayOt,
      this.awayScore,
      this.awayThree,
      this.awayTimeOut,
      this.awayTwo,
      this.homeFoul,
      this.homeFour,
      this.homeOne,
      this.homeOt,
      this.homeScore,
      this.homeThree,
      this.homeTimeOut,
      this.homeTwo});

  AppMatchScore.fromJson(Map<String, dynamic> json) {
    awayFoul = json['awayFoul'];
    awayFour = json['awayFour'];
    awayOne = json['awayOne'];
    awayOt = json['awayOt'];
    awayScore = json['awayScore'];
    awayThree = json['awayThree'];
    awayTimeOut = json['awayTimeOut'];
    awayTwo = json['awayTwo'];
    homeFoul = json['homeFoul'];
    homeFour = json['homeFour'];
    homeOne = json['homeOne'];
    homeOt = json['homeOt'];
    homeScore = json['homeScore'];
    homeThree = json['homeThree'];
    homeTimeOut = json['homeTimeOut'];
    homeTwo = json['homeTwo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['awayFoul'] = this.awayFoul;
    data['awayFour'] = this.awayFour;
    data['awayOne'] = this.awayOne;
    data['awayOt'] = this.awayOt;
    data['awayScore'] = this.awayScore;
    data['awayThree'] = this.awayThree;
    data['awayTimeOut'] = this.awayTimeOut;
    data['awayTwo'] = this.awayTwo;
    data['homeFoul'] = this.homeFoul;
    data['homeFour'] = this.homeFour;
    data['homeOne'] = this.homeOne;
    data['homeOt'] = this.homeOt;
    data['homeScore'] = this.homeScore;
    data['homeThree'] = this.homeThree;
    data['homeTimeOut'] = this.homeTimeOut;
    data['homeTwo'] = this.homeTwo;
    return data;
  }
}

extension BasketExtension on BasketListEntity {
  bool hasBegin() {
    return statusId == 2 ||
        statusId == 3 ||
        statusId == 4 ||
        statusId == 5 ||
        statusId == 6 ||
        statusId == 7 ||
        statusId == 8 ||
        statusId == 9 ||
        statusId == 10 ||
        statusId == 14;
  }
}
