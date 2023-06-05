import 'package:sports/util/utils.dart';
import 'package:sports/util/datetime_ex1.dart';

class BbDetailHeadInfoEntity {
  int? homeTeamId;
  int? awayTeamId;
  String? awayHalfScore;
  String? awayPosition;
  String? awayScore;
  String? awayTeamLogo;
  String? awayTeamName;
  bool? data;
  String? homeHalfScore;
  String? homePosition;
  String? homeScore;
  String? homeTeamLogo;
  String? homeTeamName;
  bool? info;
  bool? injure;
  int? kind;
  String? leagueName;
  bool? lineup;
  bool? live;
  String? matchPursueScore;
  String? matchScore;
  String? matchTime;
  bool? odds;
  bool? plan;
  int? statusId;
  String? remainingTime;
  int? periodCount; //	比赛总节数-不包含加时
  int? planCnt;
  int? video;

  BbDetailHeadInfoEntity(
      {this.homeTeamId,
      this.awayTeamId,
      this.awayHalfScore,
      this.awayPosition,
      this.awayScore,
      this.awayTeamLogo,
      this.awayTeamName,
      this.data,
      this.homeHalfScore,
      this.homePosition,
      this.homeScore,
      this.homeTeamLogo,
      this.homeTeamName,
      this.info,
      this.injure,
      this.kind,
      this.leagueName,
      this.lineup,
      this.live,
      this.matchPursueScore,
      this.matchScore,
      this.matchTime,
      this.odds,
      this.plan,
      this.statusId,
      this.remainingTime,
      this.periodCount,
      this.planCnt,
      this.video});

  BbDetailHeadInfoEntity.fromJson(Map<String, dynamic> json) {
    homeTeamId = json['homeTeamId'];
    awayTeamId = json['awayTeamId'];
    awayHalfScore = json['awayHalfScore'];
    awayPosition = json['awayPosition'];
    awayScore = json['awayScore'];
    awayTeamLogo = json['awayTeamLogo'];
    awayTeamName = json['awayTeamName'];
    data = json['data'];
    homeHalfScore = json['homeHalfScore'];
    homePosition = json['homePosition'];
    homeScore = json['homeScore'];
    homeTeamLogo = json['homeTeamLogo'];
    homeTeamName = json['homeTeamName'];
    info = json['info'];
    injure = json['injure'];
    kind = json['kind'];
    leagueName = json['leagueName'];
    lineup = json['lineup'];
    live = json['live'];
    matchPursueScore = json['matchPursueScore'];
    matchScore = json['matchScore'];
    matchTime = json['matchTime'];
    odds = json['odds'];
    plan = json['plan'];
    statusId = json['statusId'];
    periodCount = json['periodCount'];
    remainingTime = json['remainingTime'];
    planCnt = json['planCnt'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homeTeamId'] = this.homeTeamId;
    data['awayTeamId'] = this.awayTeamId;
    data['awayHalfScore'] = this.awayHalfScore;
    data['awayPosition'] = this.awayPosition;
    data['awayScore'] = this.awayScore;
    data['awayTeamLogo'] = this.awayTeamLogo;
    data['awayTeamName'] = this.awayTeamName;
    data['data'] = this.data;
    data['homeHalfScore'] = this.homeHalfScore;
    data['homePosition'] = this.homePosition;
    data['homeScore'] = this.homeScore;
    data['homeTeamLogo'] = this.homeTeamLogo;
    data['homeTeamName'] = this.homeTeamName;
    data['info'] = this.info;
    data['injure'] = this.injure;
    data['kind'] = this.kind;
    data['leagueName'] = this.leagueName;
    data['lineup'] = this.lineup;
    data['live'] = this.live;
    data['matchPursueScore'] = this.matchPursueScore;
    data['matchScore'] = this.matchScore;
    data['matchTime'] = this.matchTime;
    data['odds'] = this.odds;
    data['plan'] = this.plan;
    data['statusId'] = this.statusId;
    data['remainingTime'] = this.remainingTime;
    data['periodCount'] = periodCount;
    data['planCnt'] = planCnt;
    data['video'] = video;
    return data;
  }
}

const _statusMap = {
  0: "比赛异常", //，说明：暂未判断具体原因的异常比赛，可能但不限于：腰斩、取消等等，建议隐藏处理"
  1: "未开赛",
  2: "第一节",
  3: "第一节完",
  4: "第二节",
  5: "第二节完",
  6: "第三节",
  7: "第三节完",
  8: "第四节",
  9: "加时",
  10: "完场",
  11: "中断",
  12: "取消",
  13: "延期",
  14: "腰斩",
  15: "待定"
};

const _statusMap2 = {
  0: "比赛异常",
  1: "未开赛",
  2: "上半场",
  3: "中场",
  4: "下半场",
  9: "加时",
  10: "完场",
  11: "中断",
  12: "取消",
  13: "延期",
  14: "腰斩",
  15: "待定"
};

extension BbDetailHeadInfoEntityEx1 on BbDetailHeadInfoEntity {
  Map<int, String> get statusMap => periodCount == 2 ? _statusMap2 : _statusMap;
  DateTime? get matchDateTime => DateTime.tryParse(matchTime ?? "");
  String? get timeDesc => () {
        final date = matchDateTime;
        if (date == null) {
          return null;
        }
        if (date.isInToday()) {
          return date.formatedString('今天 HH:mm');
        }
        if (date.isInTommorow()) {
          return date.formatedString('明天 HH:mm');
        }
        return date.isInThisYear
            ? date.formatedString('MM-dd HH:mm')
            : date.formatedString("yyyy-MM-dd HH:mm");
      }.call();
  String get getRemainingTime => [2, 4, 6, 8].contains(statusId ?? 0)
      ? (remainingTime == null ? "" : " $remainingTime")
      : "";

  String? get halfScore => () {
        if (periodCount == 2) {
          if ([1, 2].contains(statusId)) {
            return null;
          }
        } else {
          if ([1, 2, 3, 4].contains(statusId)) {
            return null;
          }
        }
        if (awayHalfScore != null && homeHalfScore != null) {
          return "半场 ${awayHalfScore ?? ''} - ${homeHalfScore ?? ''}";
        }
        return null;
      }.call();
}
