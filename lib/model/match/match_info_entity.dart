import 'dart:developer';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:sports/res/colours.dart';
import 'package:sports/util/datetime_ex1.dart';

class MatchInfoEntity {
  String? awayHalfScore;
  String? awayScore;
  String? awayScoreAll;
  String? awayScoreOt;
  String? awayScorePk;
  BaseInfo? baseInfo;
  String? color;
  bool? data;
  String? homeHalfScore;
  String? homeScore;
  String? homeScoreAll;
  String? homeScoreOt;
  String? homeScorePk;
  bool? info;
  bool? injure;
  int? kind;
  bool? lineup;
  bool? live;
  String? locationCn;
  int? matchId;
  int? neutrality;
  bool? odds;
  bool? plan;
  String? runningTime;
  int? source;
  String? startTime;
  int? planCnt;

  MatchInfoEntity(
      {this.awayHalfScore,
      this.awayScore,
      this.awayScoreAll,
      this.awayScoreOt,
      this.awayScorePk,
      this.baseInfo,
      this.color,
      this.data,
      this.homeHalfScore,
      this.homeScore,
      this.homeScoreAll,
      this.homeScoreOt,
      this.homeScorePk,
      this.info,
      this.injure,
      this.kind,
      this.lineup,
      this.live,
      this.locationCn,
      this.matchId,
      this.neutrality,
      this.odds,
      this.plan,
      this.runningTime,
      this.source,
      this.startTime,
      this.planCnt});

  MatchInfoEntity.fromJson(Map<String, dynamic> json) {
    awayHalfScore = json['awayHalfScore'];
    awayScore = json['awayScore'];
    awayScoreAll = json['awayScoreAll'];
    awayScoreOt = json['awayScoreOt'];
    awayScorePk = json['awayScorePk'];
    baseInfo = json['baseInfo'] != null
        ? new BaseInfo.fromJson(json['baseInfo'])
        : null;
    color = json['color'];
    data = json['data'];
    homeHalfScore = json['homeHalfScore'];
    homeScore = json['homeScore'];
    homeScoreAll = json['homeScoreAll'];
    homeScoreOt = json['homeScoreOt'];
    homeScorePk = json['homeScorePk'];
    info = json['info'];
    injure = json['injure'];
    kind = json['kind'];
    lineup = json['lineup'];
    live = json['live'];
    locationCn = json['locationCn'];
    matchId = json['matchId'];
    neutrality = json['neutrality'];
    odds = json['odds'];
    plan = json['plan'];
    runningTime = json['runningTime'];
    source = json['source'];
    startTime = json['startTime'];
    planCnt = json['planCnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['awayHalfScore'] = this.awayHalfScore;
    data['awayScore'] = this.awayScore;
    data['awayScoreAll'] = this.awayScoreAll;
    data['awayScoreOt'] = this.awayScoreOt;
    data['awayScorePk'] = this.awayScorePk;
    if (this.baseInfo != null) {
      data['baseInfo'] = this.baseInfo!.toJson();
    }
    data['color'] = this.color;
    data['data'] = this.data;
    data['homeHalfScore'] = this.homeHalfScore;
    data['homeScore'] = this.homeScore;
    data['homeScoreAll'] = this.homeScoreAll;
    data['homeScoreOt'] = this.homeScoreOt;
    data['homeScorePk'] = this.homeScorePk;
    data['info'] = this.info;
    data['injure'] = this.injure;
    data['kind'] = this.kind;
    data['lineup'] = this.lineup;
    data['live'] = this.live;
    data['locationCn'] = this.locationCn;
    data['matchId'] = this.matchId;
    data['neutrality'] = this.neutrality;
    data['odds'] = this.odds;
    data['plan'] = this.plan;
    data['runningTime'] = this.runningTime;
    data['source'] = this.source;
    data['startTime'] = this.startTime;
    data['planCnt'] = this.planCnt;
    return data;
  }
}

class BaseInfo {
  int? auto;
  String? countryCn;
  String? countryLogo;
  int? currRound;
  String? currSeason;
  String? dcMatchNo;
  int? guestId;
  String? guestLogo;
  String? guestName;
  String? guestNameAll;
  String? guestRanking;
  int? homeId;
  String? homeLogo;
  String? homeName;
  String? homeNameAll;
  String? homeRanking;
  int? hot;
  int? id;
  int? info;
  String? jcMatchNo;
  int? leagueId;
  String? leagueLogo;
  String? leagueType;
  int? leagueWeight;
  String? matchTime;
  String? nameChs;
  String? nameChsShort;
  String? sfcMatchNo;
  int? status;
  String? statusName;
  String? subClassCn;
  String? sumRound;
  int? weight;
  int? video;

  BaseInfo(
      {this.auto,
      this.countryCn,
      this.countryLogo,
      this.currRound,
      this.currSeason,
      this.dcMatchNo,
      this.guestId,
      this.guestLogo,
      this.guestName,
      this.guestNameAll,
      this.guestRanking,
      this.homeId,
      this.homeLogo,
      this.homeName,
      this.homeNameAll,
      this.homeRanking,
      this.hot,
      this.id,
      this.info,
      this.jcMatchNo,
      this.leagueId,
      this.leagueLogo,
      this.leagueType,
      this.leagueWeight,
      this.matchTime,
      this.nameChs,
      this.nameChsShort,
      this.sfcMatchNo,
      this.status,
      this.statusName,
      this.subClassCn,
      this.sumRound,
      this.weight,
      this.video});

  BaseInfo.fromJson(Map<String, dynamic> json) {
    auto = json['auto'];
    countryCn = json['countryCn'];
    countryLogo = json['countryLogo'];
    currRound = json['currRound'];
    currSeason = json['currSeason'];
    dcMatchNo = json['dcMatchNo'];
    guestId = json['guestId'];
    guestLogo = json['guestLogo'];
    guestName = json['guestName'];
    guestNameAll = json['guestNameAll'];
    guestRanking = json['guestRanking'];
    homeId = json['homeId'];
    homeLogo = json['homeLogo'];
    homeName = json['homeName'];
    homeNameAll = json['homeNameAll'];
    homeRanking = json['homeRanking'];
    hot = json['hot'];
    id = json['id'];
    info = json['info'];
    jcMatchNo = json['jcMatchNo'];
    leagueId = json['leagueId'];
    leagueLogo = json['leagueLogo'];
    leagueType = json['leagueType'];
    leagueWeight = json['leagueWeight'];
    matchTime = json['matchTime'];
    nameChs = json['nameChs'];
    nameChsShort = json['nameChsShort'];
    sfcMatchNo = json['sfcMatchNo'];
    status = json['status'];
    statusName = json['statusName'];
    subClassCn = json['subClassCn'];
    sumRound = json['sumRound'];
    weight = json['weight'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auto'] = this.auto;
    data['countryCn'] = this.countryCn;
    data['countryLogo'] = this.countryLogo;
    data['currRound'] = this.currRound;
    data['currSeason'] = this.currSeason;
    data['dcMatchNo'] = this.dcMatchNo;
    data['guestId'] = this.guestId;
    data['guestLogo'] = this.guestLogo;
    data['guestName'] = this.guestName;
    data['guestNameAll'] = this.guestNameAll;
    data['guestRanking'] = this.guestRanking;
    data['homeId'] = this.homeId;
    data['homeLogo'] = this.homeLogo;
    data['homeName'] = this.homeName;
    data['homeNameAll'] = this.homeNameAll;
    data['homeRanking'] = this.homeRanking;
    data['hot'] = this.hot;
    data['id'] = this.id;
    data['info'] = this.info;
    data['jcMatchNo'] = this.jcMatchNo;
    data['leagueId'] = this.leagueId;
    data['leagueLogo'] = this.leagueLogo;
    data['leagueType'] = this.leagueType;
    data['leagueWeight'] = this.leagueWeight;
    data['matchTime'] = this.matchTime;
    data['nameChs'] = this.nameChs;
    data['nameChsShort'] = this.nameChsShort;
    data['sfcMatchNo'] = this.sfcMatchNo;
    data['status'] = this.status;
    data['statusName'] = this.statusName;
    data['subClassCn'] = this.subClassCn;
    data['sumRound'] = this.sumRound;
    data['weight'] = this.weight;
    data['video'] = this.video;
    return data;
  }
}

enum MatchState {
  notStart, //未开始
  inMatch, //比赛中
  end, //比赛结束
  delay, //推迟
  canceled,
  halfCut,
  inter,
  determined
}

extension MatchInfoEntityEx1 on MatchInfoEntity {
  bool get hasHomeRanking => ((baseInfo?.homeRanking?.length ?? 0) != 0);
  bool get hasGuestRanking => ((baseInfo?.guestRanking?.length ?? 0) != 0);
  //(1, "未开赛"),(2, "上半场"),(3, "中场"),(4, "下半场"),(5, "加时"),(6, "点球"),(7, "完场"),
  //(8, "取消"),(9, "中断"),(10, "腰斩"),(11, "延期"),(12, "待定"),(99, "未知"),

  MatchState get state {
    switch (baseInfo?.status) {
      case 1:
        return MatchState.notStart;
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        return MatchState.inMatch;
      case 7:
        return MatchState.end;
      case 8:
        return MatchState.canceled;
      case 9:
        return MatchState.inter;
      case 10:
        return MatchState.halfCut;
      case 11:
        return MatchState.delay;
      case 12:
        return MatchState.determined;
    }
    return MatchState.end;
  }

  bool get isMatchFinish {
    switch (state) {
      case MatchState.end:
      case MatchState.halfCut:
        return true;
      default:
        return false;
    }
  }

  String get centerTitle {
    switch (state) {
      case MatchState.notStart:
      case MatchState.determined:
        return time;
      case MatchState.inMatch:
      case MatchState.canceled:
      case MatchState.inter:
      case MatchState.end:
        return scoreRate ?? "VS";
      case MatchState.delay:
      case MatchState.halfCut:
        return "VS";
    }
    return "VS";
  }

  String? get scoreRate =>
      homeScore == null ? null : "${homeScore} - ${awayScore}";
  String? get halfScoreRate =>
      homeHalfScore == null ? null : "${homeHalfScore} - ${awayHalfScore}";
  String? get otScoreRate =>
      homeScoreOt == null ? null : "${homeScoreOt} - ${awayScoreOt}";
  String? get pkScoreRate =>
      homeScorePk == null ? null : "${homeScorePk} - ${awayScorePk}";
  // String? get scoreRateInMatch => matchDuration == null
  //     ? null
  //     : "${homeScore} ${matchDuration} ${awayScore}";

  // String? get matchDuration {
  //   if (state != MatchState.inMatch) {
  //     return null;
  //   }
  //   try {
  //     final date = DateFormat("yyyy-MM-dd HH:mm:ss")
  //         .parse(startTime?.replaceAll("/", "-") ?? "");
  //     log("message");
  //     final dur = DateTime.now().difference(date);
  //     return "${dur.inMinutes}′";
  //   } catch (err) {}
  //   return null;
  // }

  String get time {
    String time = "${baseInfo?.matchTime}";
    try {
      final t = baseInfo?.matchTime?.replaceAll("/", "-");
      final date = DateFormat("yyyy-MM-dd HH:mm:ss").parse(t ?? "");
      final day0 = DateTime.now().nextStartDay(0);
      final day1 = day0.nextStartDay();
      final day2 = day1.nextStartDay();
      time = date.isInThisYear
          ? "${date.formatedString("MM-dd HH:mm")}"
          : date.formatedString("yyyy-MM-dd HH:mm");
      final milldate = date.millisecondsSinceEpoch;
      if (milldate > day0.millisecondsSinceEpoch &&
          date.millisecondsSinceEpoch < day1.millisecondsSinceEpoch) {
        time = "今天 ${date.formatedString("HH:mm")}";
      } else if (milldate > day1.millisecondsSinceEpoch &&
          milldate < day2.millisecondsSinceEpoch) {
        time = "明天 ${date.formatedString("HH:mm")}";
      }
    } catch (err) {
      log("match info entity get time err ${err}");
    }
    return time;
  }

  Color get topColor {
    switch (state) {
      case MatchState.end:
        return Color(0xFF383C41);
      case MatchState.notStart:
        return Color(0xFF2457B1);
      case MatchState.delay:
        return Color(0xffd27d3a);
      case MatchState.inMatch:
        return Color(0xFFF53F3F);
      default:
        return Color(0xFF7186A0);
    }
    return Color(0xFFF53F3F);
  }

  Color get topStatusBgColor {
    switch (state) {
      case MatchState.end:
        return Color(0xFF292D32);
      case MatchState.notStart:
        return Color(0xFF1548A0);
      case MatchState.delay:
        return Color(0xFFCA6D15);
      case MatchState.inMatch:
        return Color(0x6EFDFDFD);
      default:
        return Color(0xFF597496);
    }
    return Color(0xFFF53F3F);
  }
}
