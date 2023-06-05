class BbTeamCountEntity {
  TeamRank? teamRank;
  TeamData? teamData;

  BbTeamCountEntity({this.teamRank, this.teamData});

  BbTeamCountEntity.fromJson(Map<String, dynamic> json) {
    teamRank = json['teamRank'] != null
        ? new TeamRank.fromJson(json['teamRank'])
        : null;
    teamData = json['teamData'] != null
        ? new TeamData.fromJson(json['teamData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teamRank != null) {
      data['teamRank'] = this.teamRank!.toJson();
    }
    if (this.teamData != null) {
      data['teamData'] = this.teamData!.toJson();
    }
    return data;
  }
}

class TeamRank {
  String? teamRank;
  String? victoryOrDefeatTotal;
  String? victoryOrDefeatHome;
  String? victoryOrDefeatAway;

  TeamRank(
      {this.teamRank,
      this.victoryOrDefeatTotal,
      this.victoryOrDefeatHome,
      this.victoryOrDefeatAway});

  TeamRank.fromJson(Map<String, dynamic> json) {
    teamRank = json['teamRank'];
    victoryOrDefeatTotal = json['victoryOrDefeatTotal'];
    victoryOrDefeatHome = json['victoryOrDefeatHome'];
    victoryOrDefeatAway = json['victoryOrDefeatAway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamRank'] = this.teamRank;
    data['victoryOrDefeatTotal'] = this.victoryOrDefeatTotal;
    data['victoryOrDefeatHome'] = this.victoryOrDefeatHome;
    data['victoryOrDefeatAway'] = this.victoryOrDefeatAway;
    return data;
  }
}

class TeamData {
  String? teamQxbId;
  double? points;
  String? pointsRank;
  String? threePointsAccuracy;
  String? threePointsAccuracyRank;
  String? fieldGoalsAccuracy;
  String? fieldGoalsAccuracyRank;
  double? rebounds;
  String? reboundsRank;
  double? assists;
  String? assistsRank;
  double? turnovers;
  String? turnoversRank;
  double? steals;
  String? stealsRank;
  double? blocks;
  String? blocksRank;

  TeamData(
      {this.teamQxbId,
      this.points,
      this.pointsRank,
      this.threePointsAccuracy,
      this.threePointsAccuracyRank,
      this.fieldGoalsAccuracy,
      this.fieldGoalsAccuracyRank,
      this.rebounds,
      this.reboundsRank,
      this.assists,
      this.assistsRank,
      this.turnovers,
      this.turnoversRank,
      this.steals,
      this.stealsRank,
      this.blocks,
      this.blocksRank});

  TeamData.fromJson(Map<String, dynamic> json) {
    teamQxbId = json['teamQxbId'];
    points = json['points'];
    pointsRank = json['pointsRank'];
    threePointsAccuracy = json['threePointsAccuracy'];
    threePointsAccuracyRank = json['threePointsAccuracyRank'];
    fieldGoalsAccuracy = json['fieldGoalsAccuracy'];
    fieldGoalsAccuracyRank = json['fieldGoalsAccuracyRank'];
    rebounds = json['rebounds'];
    reboundsRank = json['reboundsRank'];
    assists = json['assists'];
    assistsRank = json['assistsRank'];
    turnovers = json['turnovers'];
    turnoversRank = json['turnoversRank'];
    steals = json['steals'];
    stealsRank = json['stealsRank'];
    blocks = json['blocks'];
    blocksRank = json['blocksRank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamQxbId'] = this.teamQxbId;
    data['points'] = this.points;
    data['pointsRank'] = this.pointsRank;
    data['threePointsAccuracy'] = this.threePointsAccuracy;
    data['threePointsAccuracyRank'] = this.threePointsAccuracyRank;
    data['fieldGoalsAccuracy'] = this.fieldGoalsAccuracy;
    data['fieldGoalsAccuracyRank'] = this.fieldGoalsAccuracyRank;
    data['rebounds'] = this.rebounds;
    data['reboundsRank'] = this.reboundsRank;
    data['assists'] = this.assists;
    data['assistsRank'] = this.assistsRank;
    data['turnovers'] = this.turnovers;
    data['turnoversRank'] = this.turnoversRank;
    data['steals'] = this.steals;
    data['stealsRank'] = this.stealsRank;
    data['blocks'] = this.blocks;
    data['blocksRank'] = this.blocksRank;
    return data;
  }
}
