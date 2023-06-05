class BasketScheduleEntity {
  List<ScheduleList>? scheduleList;
  int? isCurrent;
  int? kind;
  String? kindName;
  int? matchLocation;

  BasketScheduleEntity(
      {this.scheduleList, this.isCurrent, this.kind, this.kindName, this.matchLocation});

  BasketScheduleEntity.fromJson(Map<String, dynamic> json) {
    if (json['appTeamMatchInfo'] != null) {
      scheduleList = <ScheduleList>[];
      json['appTeamMatchInfo'].forEach((v) {
        scheduleList!.add(new ScheduleList.fromJson(v));
      });
    }
    isCurrent = json['isCurrent'];
    kind = json['kind'];
    kindName = json['kindName'];
    matchLocation = json['matchLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.scheduleList != null) {
      data['appTeamMatchInfo'] =
          this.scheduleList!.map((v) => v.toJson()).toList();
    }
    data['isCurrent'] = this.isCurrent;
    data['kind'] = this.kind;
    data['kindName'] = this.kindName;
    data['matchLocation'] = this.matchLocation;
    return data;
  }
}

class ScheduleList {
  String? awayLogo;
  String? awayName;
  int? awayScore;
  int? awayTeamId;
  String? homeLogo;
  String? homeName;
  int? homeScore;
  int? homeTeamId;
  int? kind;
  String? kindName;
  String? leagueName;
  int? id;
  String? matchMonth;
  int? matchResult;
  String? matchTime;
  String? matchYear;
  int? statusId;

  ScheduleList(
      {this.awayLogo,
        this.awayName,
        this.awayScore,
        this.awayTeamId,
        this.homeLogo,
        this.homeName,
        this.homeScore,
        this.homeTeamId,
        this.kind,
        this.kindName,
        this.leagueName,
        this.id,
        this.matchMonth,
        this.matchResult,
        this.matchTime,
        this.matchYear,
        this.statusId});

  ScheduleList.fromJson(Map<String, dynamic> json) {
    awayLogo = json['awayLogo'];
    awayName = json['awayName'];
    awayScore = json['awayScore'];
    awayTeamId = json['awayTeamId'];
    homeLogo = json['homeLogo'];
    homeName = json['homeName'];
    homeScore = json['homeScore'];
    homeTeamId = json['homeTeamId'];
    kind = json['kind'];
    kindName = json['kindName'];
    leagueName = json['leagueName'];
    id = json['id'];
    matchMonth = json['matchMonth'];
    matchResult = json['matchResult'];
    matchTime = json['matchTime'];
    matchYear = json['matchYear'];
    statusId = json['statusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['awayLogo'] = this.awayLogo;
    data['awayName'] = this.awayName;
    data['awayScore'] = this.awayScore;
    data['awayTeamId'] = this.awayTeamId;
    data['homeLogo'] = this.homeLogo;
    data['homeName'] = this.homeName;
    data['homeScore'] = this.homeScore;
    data['homeTeamId'] = this.homeTeamId;
    data['kind'] = this.kind;
    data['kindName'] = this.kindName;
    data['leagueName'] = this.leagueName;
    data['id'] = this.id;
    data['matchMonth'] = this.matchMonth;
    data['matchResult'] = this.matchResult;
    data['matchTime'] = this.matchTime;
    data['matchYear'] = this.matchYear;
    data['statusId'] = this.statusId;
    return data;
  }
}