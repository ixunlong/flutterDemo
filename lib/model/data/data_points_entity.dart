class DataPointsEntity {
  String? introduce;
  List<Points>? pointsList;

  DataPointsEntity({this.introduce, this.pointsList});

  DataPointsEntity.fromJson(Map<String, dynamic> json) {
    introduce = json['introduce'];
    if (json['list'] != null) {
      pointsList = <Points>[];
      json['list'].forEach((v) {
        pointsList!.add(new Points.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['introduce'] = this.introduce;
    if (this.pointsList != null) {
      data['list'] = this.pointsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Points {
  String? groupName;
  int? index;
  int? isGroup;
  List<Qualifying>? qualifying;
  List<TeamStanding>? teamStanding;

  Points(
      {this.groupName,
        this.index,
        this.isGroup,
        this.qualifying,
        this.teamStanding});

  Points.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    index = json['index'];
    isGroup = json['isGroup'];
    if (json['qualifying'] != null) {
      qualifying = <Qualifying>[];
      json['qualifying'].forEach((v) {
        qualifying!.add(new Qualifying.fromJson(v));
      });
    }
    if (json['teamStanding'] != null) {
      teamStanding = <TeamStanding>[];
      json['teamStanding'].forEach((v) {
        teamStanding!.add(new TeamStanding.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupName'] = this.groupName;
    data['index'] = this.index;
    data['isGroup'] = this.isGroup;
    if (this.qualifying != null) {
      data['qualifying'] = this.qualifying!.map((v) => v.toJson()).toList();
    }
    if (this.teamStanding != null) {
      data['teamStanding'] = this.teamStanding!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Qualifying {
  int? beginRank;
  String? color;
  int? endRank;
  int? id;
  int? leagueId;
  String? leagueName;
  String? season;
  String? tagColor;
  int? source;

  Qualifying(
      {this.beginRank,
        this.color,
        this.endRank,
        this.id,
        this.leagueId,
        this.leagueName,
        this.season,
        this.tagColor,
        this.source});

  Qualifying.fromJson(Map<String, dynamic> json) {
    beginRank = json['beginRank'];
    color = json['color'];
    endRank = json['endRank'];
    id = json['id'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    season = json['season'];
    tagColor = json['tagColor'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beginRank'] = this.beginRank;
    data['color'] = this.color;
    data['endRank'] = this.endRank;
    data['id'] = this.id;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['season'] = this.season;
    data['tagColor'] = this.tagColor;
    data['source'] = this.source;
    return data;
  }
}

class TeamStanding {
  String? deductionExplainCn;
  int? drawCount;
  int? getScore;
  int? goalDifference;
  String? groupCn;
  int? integral;
  int? leagueId;
  String? leagueName;
  int? loseCount;
  int? loseScore;
  int? rank;
  String? season;
  int? source;
  int? sourceLeagueId;
  int? sourceTeamId;
  int? teamId;
  String? teamLogo;
  String? teamName;
  int? totalCount;
  int? type;
  int? winCount;

  TeamStanding({this.deductionExplainCn, this.drawCount, this.getScore, this.goalDifference, this.groupCn, this.integral, this.leagueId, this.leagueName, this.loseCount, this.loseScore, this.rank, this.season, this.source, this.sourceLeagueId, this.sourceTeamId, this.teamId, this.teamLogo, this.teamName, this.totalCount, this.type, this.winCount});

  TeamStanding.fromJson(Map<String, dynamic> json) {
    deductionExplainCn = json['deductionExplainCn'];
    drawCount = json['drawCount'];
    getScore = json['getScore'];
    goalDifference = json['goalDifference'];
    groupCn = json['groupCn'];
    integral = json['integral'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    loseCount = json['loseCount'];
    loseScore = json['loseScore'];
    rank = json['rank'];
    season = json['season'];
    source = json['source'];
    sourceLeagueId = json['sourceLeagueId'];
    sourceTeamId = json['sourceTeamId'];
    teamId = json['teamId'];
    teamLogo = json['teamLogo'];
    teamName = json['teamName'];
    totalCount = json['totalCount'];
    type = json['type'];
    winCount = json['winCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deductionExplainCn'] = this.deductionExplainCn;
    data['drawCount'] = this.drawCount;
    data['getScore'] = this.getScore;
    data['goalDifference'] = this.goalDifference;
    data['groupCn'] = this.groupCn;
    data['integral'] = this.integral;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['loseCount'] = this.loseCount;
    data['loseScore'] = this.loseScore;
    data['rank'] = this.rank;
    data['season'] = this.season;
    data['source'] = this.source;
    data['sourceLeagueId'] = this.sourceLeagueId;
    data['sourceTeamId'] = this.sourceTeamId;
    data['teamId'] = this.teamId;
    data['teamLogo'] = this.teamLogo;
    data['teamName'] = this.teamName;
    data['totalCount'] = this.totalCount;
    data['type'] = this.type;
    data['winCount'] = this.winCount;
    return data;
  }
}