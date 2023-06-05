class BasketMatchDataTeamEntity {
  TeamInfo? homeInfo;
  TeamInfo? awayInfo;

  BasketMatchDataTeamEntity({this.homeInfo, this.awayInfo});

  BasketMatchDataTeamEntity.fromJson(Map<String, dynamic> json) {
    homeInfo = json['homeInfo'] != null
        ? new TeamInfo.fromJson(json['homeInfo'])
        : null;
    awayInfo = json['awayInfo'] != null
        ? new TeamInfo.fromJson(json['awayInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.homeInfo != null) {
      data['homeInfo'] = this.homeInfo!.toJson();
    }
    if (this.awayInfo != null) {
      data['awayInfo'] = this.awayInfo!.toJson();
    }
    return data;
  }
}

class TeamInfo {
  String? currentStanding;
  String? teamName;
  String? teamLogo;
  String? record;
  String? wonRate;
  String? gameBack;
  String? recentRecord;
  String? avgScore;
  String? pointsLostAvg;
  String? tenRecord;
  String? homeRecord;
  String? awayRecord;

  TeamInfo(
      {this.currentStanding,
      this.teamName,
      this.teamLogo,
      this.record,
      this.wonRate,
      this.gameBack,
      this.recentRecord,
      this.avgScore,
      this.tenRecord,
      this.homeRecord,
      this.awayRecord,
      this.pointsLostAvg});

  TeamInfo.fromJson(Map<String, dynamic> json) {
    currentStanding = json['currentStanding'];
    teamName = json['teamName'];
    teamLogo = json['teamLogo'];
    record = json['record'];
    wonRate = json['wonRate'];
    gameBack = json['gameBack'];
    recentRecord = json['recentRecord'];
    avgScore = json['avgScore'];
    tenRecord = json['tenRecord'];
    homeRecord = json['homeRecord'];
    awayRecord = json['awayRecord'];
    pointsLostAvg = json['pointsLostAvg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentStanding'] = this.currentStanding;
    data['teamName'] = this.teamName;
    data['teamLogo'] = this.teamLogo;
    data['record'] = this.record;
    data['wonRate'] = this.wonRate;
    data['gameBack'] = this.gameBack;
    data['recentRecord'] = this.recentRecord;
    data['avgScore'] = this.avgScore;
    data['tenRecord'] = this.tenRecord;
    data['homeRecord'] = this.homeRecord;
    data['awayRecord'] = this.awayRecord;
    data['pointsLostAvg'] = this.pointsLostAvg;
    return data;
  }
}
