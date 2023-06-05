class DataScheduleEntity {
  int? isCurrent;
  List<TeamList>? teamList;
  int? matchTime;
  String? round;

  DataScheduleEntity({this.isCurrent, this.teamList, this.matchTime, this.round});

  DataScheduleEntity.fromJson(Map<String, dynamic> json) {
    isCurrent = json['isCurrent'];
    if (json['list'] != null) {
      teamList = <TeamList>[];
      json['list'].forEach((v) {
        teamList!.add(new TeamList.fromJson(v));
      });
    }
    matchTime = json['matchTime'];
    round = json['round'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isCurrent'] = this.isCurrent;
    if (this.teamList != null) {
      data['list'] = this.teamList!.map((v) => v.toJson()).toList();
    }
    data['matchTime'] = this.matchTime;
    data['round'] = this.round;
    return data;
  }
}

class TeamList {
  String? currRound;
  String? grouping2;
  int? guestId;
  String? guestLogo;
  String? guestName;
  int? guestScore90;
  int? guestScoreHalf;
  int? guestScoreOt;
  int? guestScorePk;
  int? homeId;
  String? homeLogo;
  String? homeName;
  int? homeScore90;
  int? homeScoreHalf;
  int? homeScoreOt;
  int? homeScorePk;
  String? leagueColor;
  int? leagueId;
  String? leagueName;
  int? matchId;
  String? matchTime;
  String? round;
  String? season;
  int? sourceGuestId;
  int? sourceHomeId;
  int? sourceStatus;
  int? status;
  int? subLeagueId;
  String? subNameChs;
  String? sumRound;

  TeamList({this.currRound, this.grouping2, this.guestId, this.guestLogo, this.guestName, this.guestScore90, this.guestScoreHalf, this.guestScoreOt, this.guestScorePk, this.homeId, this.homeLogo, this.homeName, this.homeScore90, this.homeScoreHalf, this.homeScoreOt, this.homeScorePk, this.leagueColor, this.leagueId, this.leagueName, this.matchId, this.matchTime, this.round, this.season, this.sourceGuestId, this.sourceHomeId, this.sourceStatus, this.status, this.subLeagueId, this.subNameChs, this.sumRound});

  TeamList.fromJson(Map<String, dynamic> json) {
    currRound = json['currRound'];
    grouping2 = json['grouping2'];
    guestId = json['guestId'];
    guestLogo = json['guestLogo'];
    guestName = json['guestName'];
    guestScore90 = json['guestScore90'];
    guestScoreHalf = json['guestScoreHalf'];
    guestScoreOt = json['guestScoreOt'];
    guestScorePk = json['guestScorePk'];
    homeId = json['homeId'];
    homeLogo = json['homeLogo'];
    homeName = json['homeName'];
    homeScore90 = json['homeScore90'];
    homeScoreHalf = json['homeScoreHalf'];
    homeScoreOt = json['homeScoreOt'];
    homeScorePk = json['homeScorePk'];
    leagueColor = json['leagueColor'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    matchId = json['matchId'];
    matchTime = json['matchTime'];
    round = json['round'];
    season = json['season'];
    sourceGuestId = json['sourceGuestId'];
    sourceHomeId = json['sourceHomeId'];
    sourceStatus = json['sourceStatus'];
    status = json['status'];
    subLeagueId = json['subLeagueId'];
    subNameChs = json['subNameChs'];
    sumRound = json['sumRound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currRound'] = this.currRound;
    data['grouping2'] = this.grouping2;
    data['guestId'] = this.guestId;
    data['guestLogo'] = this.guestLogo;
    data['guestName'] = this.guestName;
    data['guestScore90'] = this.guestScore90;
    data['guestScoreHalf'] = this.guestScoreHalf;
    data['guestScoreOt'] = this.guestScoreOt;
    data['guestScorePk'] = this.guestScorePk;
    data['homeId'] = this.homeId;
    data['homeLogo'] = this.homeLogo;
    data['homeName'] = this.homeName;
    data['homeScore90'] = this.homeScore90;
    data['homeScoreHalf'] = this.homeScoreHalf;
    data['homeScoreOt'] = this.homeScoreOt;
    data['homeScorePk'] = this.homeScorePk;
    data['leagueColor'] = this.leagueColor;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['matchId'] = this.matchId;
    data['matchTime'] = this.matchTime;
    data['round'] = this.round;
    data['season'] = this.season;
    data['sourceGuestId'] = this.sourceGuestId;
    data['sourceHomeId'] = this.sourceHomeId;
    data['sourceStatus'] = this.sourceStatus;
    data['status'] = this.status;
    data['subLeagueId'] = this.subLeagueId;
    data['subNameChs'] = this.subNameChs;
    data['sumRound'] = this.sumRound;
    return data;
  }
}