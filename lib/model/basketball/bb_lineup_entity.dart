class BbLineupKeyDataEntity {
  KeyData? awayPlayerInfo;
  KeyData? homePlayerInfo;

  BbLineupKeyDataEntity({this.awayPlayerInfo, this.homePlayerInfo});

  BbLineupKeyDataEntity.fromJson(Map<String, dynamic> json) {
    awayPlayerInfo = json['awayPlayerInfo'] != null
        ? new KeyData.fromJson(json['awayPlayerInfo'])
        : null;
    homePlayerInfo = json['homePlayerInfo'] != null
        ? new KeyData.fromJson(json['homePlayerInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.awayPlayerInfo != null) {
      data['awayPlayerInfo'] = this.awayPlayerInfo!.toJson();
    }
    if (this.homePlayerInfo != null) {
      data['homePlayerInfo'] = this.homePlayerInfo!.toJson();
    }
    return data;
  }
}

class KeyData {
  KeyDataInfo? assists;
  KeyDataInfo? points;
  KeyDataInfo? rebounds;

  KeyData({this.assists, this.points, this.rebounds});

  KeyData.fromJson(Map<String, dynamic> json) {
    assists = json['assists'] != null
        ? new KeyDataInfo.fromJson(json['assists'])
        : null;
    points = json['points'] != null
        ? new KeyDataInfo.fromJson(json['points'])
        : null;
    rebounds = json['rebounds'] != null
        ? new KeyDataInfo.fromJson(json['rebounds'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assists != null) {
      data['assists'] = this.assists!.toJson();
    }
    if (this.points != null) {
      data['points'] = this.points!.toJson();
    }
    if (this.rebounds != null) {
      data['rebounds'] = this.rebounds!.toJson();
    }
    return data;
  }
}

class KeyDataInfo {
  int? assists;
  String? logo;
  String? playerName;
  int? playerId;
  int? points;
  int? rebounds;
  int? shirtNumber;
  int? teamType;

  KeyDataInfo(
      {this.assists,
      this.logo,
      this.playerName,
      this.playerId,
      this.points,
      this.rebounds,
      this.shirtNumber,
      this.teamType});

  KeyDataInfo.fromJson(Map<String, dynamic> json) {
    assists = json['assists'];
    logo = json['logo'];
    playerName = json['playerName'];
    playerId = json['playerId'];
    points = json['points'];
    rebounds = json['rebounds'];
    shirtNumber = json['shirtNumber'];
    teamType = json['teamType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assists'] = this.assists;
    data['logo'] = this.logo;
    data['playerName'] = this.playerName;
    data['playerId'] = this.playerId;
    data['points'] = this.points;
    data['rebounds'] = this.rebounds;
    data['shirtNumber'] = this.shirtNumber;
    data['teamType'] = this.teamType;
    return data;
  }
}

class BbLineupDataEntity {
  int? assists;
  int? blocks;
  int? defensiveRebounds;
  int? fieldGoalsScored;
  int? fieldGoalsTotal;
  int? first;
  String? bpm;
  int? freeThrowsScored;
  int? freeThrowsTotal;
  int? matchId;
  String? minutesPlayed;
  String? playerName;
  int? offensiveRebounds;
  int? personalFouls;
  int? played;
  int? playerId;
  int? points;
  int? rebounds;
  int? shirtNumber;
  int? steals;
  int? teamType;
  int? threePointsScored;
  int? threePointsTotal;
  int? turnovers;

  BbLineupDataEntity(
      {this.assists,
      this.blocks,
      this.defensiveRebounds,
      this.fieldGoalsScored,
      this.fieldGoalsTotal,
      this.first,
      this.bpm,
      this.freeThrowsScored,
      this.freeThrowsTotal,
      this.matchId,
      this.minutesPlayed,
      this.playerName,
      this.offensiveRebounds,
      this.personalFouls,
      this.played,
      this.playerId,
      this.points,
      this.rebounds,
      this.shirtNumber,
      this.steals,
      this.teamType,
      this.threePointsScored,
      this.threePointsTotal,
      this.turnovers});

  BbLineupDataEntity.fromJson(Map<String, dynamic> json) {
    assists = json['assists'];
    blocks = json['blocks'];
    defensiveRebounds = json['defensiveRebounds'];
    fieldGoalsScored = json['fieldGoalsScored'];
    fieldGoalsTotal = json['fieldGoalsTotal'];
    first = json['first'];
    bpm = json['bpm'];
    freeThrowsScored = json['freeThrowsScored'];
    freeThrowsTotal = json['freeThrowsTotal'];
    matchId = json['matchId'];
    minutesPlayed = json['minutesPlayed'];
    playerName = json['playerName'];
    offensiveRebounds = json['offensiveRebounds'];
    personalFouls = json['personalFouls'];
    played = json['played'];
    playerId = json['playerId'];
    points = json['points'];
    rebounds = json['rebounds'];
    shirtNumber = json['shirtNumber'];
    steals = json['steals'];
    teamType = json['teamType'];
    threePointsScored = json['threePointsScored'];
    threePointsTotal = json['threePointsTotal'];
    turnovers = json['turnovers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assists'] = this.assists;
    data['blocks'] = this.blocks;
    data['defensiveRebounds'] = this.defensiveRebounds;
    data['fieldGoalsScored'] = this.fieldGoalsScored;
    data['fieldGoalsTotal'] = this.fieldGoalsTotal;
    data['first'] = this.first;
    data['bpm'] = this.bpm;
    data['freeThrowsScored'] = this.freeThrowsScored;
    data['freeThrowsTotal'] = this.freeThrowsTotal;
    data['matchId'] = this.matchId;
    data['minutesPlayed'] = this.minutesPlayed;
    data['playerName'] = this.playerName;
    data['offensiveRebounds'] = this.offensiveRebounds;
    data['personalFouls'] = this.personalFouls;
    data['played'] = this.played;
    data['playerId'] = this.playerId;
    data['points'] = this.points;
    data['rebounds'] = this.rebounds;
    data['shirtNumber'] = this.shirtNumber;
    data['steals'] = this.steals;
    data['teamType'] = this.teamType;
    data['threePointsScored'] = this.threePointsScored;
    data['threePointsTotal'] = this.threePointsTotal;
    data['turnovers'] = this.turnovers;
    return data;
  }
}

class BbLineupSuspendDataEntity {
  List<TeamInfo>? awayTeamInfo;
  List<TeamInfo>? homeTeamInfo;

  BbLineupSuspendDataEntity({this.awayTeamInfo, this.homeTeamInfo});

  BbLineupSuspendDataEntity.fromJson(Map<String, dynamic> json) {
    if (json['awayTeamInfo'] != null) {
      awayTeamInfo = <TeamInfo>[];
      json['awayTeamInfo'].forEach((v) {
        awayTeamInfo!.add(new TeamInfo.fromJson(v));
      });
    }
    if (json['homeTeamInfo'] != null) {
      homeTeamInfo = <TeamInfo>[];
      json['homeTeamInfo'].forEach((v) {
        homeTeamInfo!.add(new TeamInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.awayTeamInfo != null) {
      data['awayTeamInfo'] = this.awayTeamInfo!.map((v) => v.toJson()).toList();
    }
    if (this.homeTeamInfo != null) {
      data['homeTeamInfo'] = this.homeTeamInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamInfo {
  int? playerId;
  String? playerName;
  String? position;
  String? reason;
  String? shirtNumber;
  int? teamType;
  int? type;

  TeamInfo(
      {this.playerId,
      this.playerName,
      this.position,
      this.reason,
      this.shirtNumber,
      this.teamType,
      this.type});

  TeamInfo.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    playerName = json['playerName'];
    position = json['position'];
    reason = json['reason'];
    shirtNumber = json['shirtNumber'];
    teamType = json['teamType'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerId'] = this.playerId;
    data['playerName'] = this.playerName;
    data['position'] = this.position;
    data['reason'] = this.reason;
    data['shirtNumber'] = this.shirtNumber;
    data['teamType'] = this.teamType;
    data['type'] = this.type;
    return data;
  }
}
