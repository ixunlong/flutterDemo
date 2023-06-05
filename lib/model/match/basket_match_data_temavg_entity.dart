class BasketMatchDataTeamAvgEntity {
  AvgData? home;
  AvgData? away;

  BasketMatchDataTeamAvgEntity({this.home, this.away});

  BasketMatchDataTeamAvgEntity.fromJson(Map<String, dynamic> json) {
    home = json['home'] != null ? new AvgData.fromJson(json['home']) : null;
    away = json['away'] != null ? new AvgData.fromJson(json['away']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.home != null) {
      data['home'] = this.home!.toJson();
    }
    if (this.away != null) {
      data['away'] = this.away!.toJson();
    }
    return data;
  }
}

class AvgData {
  int? leagueQxbId;
  int? teamQxbId;
  String? points;
  String? rebounds;
  String? assists;
  String? blocks;
  String? turnovers;
  String? threePointsTotal;
  String? twoPointsTotal;
  String? freeThrowsTotal;
  String? fieldGoalsScored;
  String? steals;

  AvgData(
      {this.leagueQxbId,
      this.teamQxbId,
      this.points,
      this.rebounds,
      this.assists,
      this.blocks,
      this.turnovers,
      this.threePointsTotal,
      this.twoPointsTotal,
      this.freeThrowsTotal,
      this.fieldGoalsScored,
      this.steals});

  AvgData.fromJson(Map<String, dynamic> json) {
    leagueQxbId = json['leagueQxbId'];
    teamQxbId = json['teamQxbId'];
    points = json['points'];
    rebounds = json['rebounds'];
    assists = json['assists'];
    blocks = json['blocks'];
    turnovers = json['turnovers'];
    threePointsTotal = json['threePointsTotal'];
    twoPointsTotal = json['twoPointsTotal'];
    freeThrowsTotal = json['freeThrowsTotal'];
    fieldGoalsScored = json['fieldGoalsScored'];
    steals = json['steals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leagueQxbId'] = this.leagueQxbId;
    data['teamQxbId'] = this.teamQxbId;
    data['points'] = this.points;
    data['rebounds'] = this.rebounds;
    data['assists'] = this.assists;
    data['blocks'] = this.blocks;
    data['turnovers'] = this.turnovers;
    data['threePointsTotal'] = this.threePointsTotal;
    data['twoPointsTotal'] = this.twoPointsTotal;
    data['freeThrowsTotal'] = this.freeThrowsTotal;
    data['fieldGoalsScored'] = this.fieldGoalsScored;
    data['steals'] = this.steals;
    return data;
  }
}
