class BbTeamPlayerEntity {
  int? teamQxbId;
  int? scope;
  double? points;
  String? freeThrowsAccuracy;
  String? threePointsAccuracy;
  String? fieldGoalsAccuracy;
  double? rebounds;
  double? assists;
  double? turnovers;
  double? steals;
  double? blocks;
  double? personalFouls;
  String? nameZhShort;
  String? logo;
  int? leagueCareerAge;
  int? shirtNumber;
  String? position;

  BbTeamPlayerEntity(
      {this.teamQxbId,
      this.scope,
      this.points,
      this.freeThrowsAccuracy,
      this.threePointsAccuracy,
      this.fieldGoalsAccuracy,
      this.rebounds,
      this.assists,
      this.turnovers,
      this.steals,
      this.blocks,
      this.personalFouls,
      this.nameZhShort,
      this.logo,
      this.leagueCareerAge,
      this.shirtNumber,
      this.position});

  BbTeamPlayerEntity.fromJson(Map<String, dynamic> json) {
    teamQxbId = json['teamQxbId'];
    scope = json['scope'];
    points = json['points'];
    freeThrowsAccuracy = json['freeThrowsAccuracy'];
    threePointsAccuracy = json['threePointsAccuracy'];
    fieldGoalsAccuracy = json['fieldGoalsAccuracy'];
    rebounds = json['rebounds'];
    assists = json['assists'];
    turnovers = json['turnovers'];
    steals = json['steals'];
    blocks = json['blocks'];
    personalFouls = json['personalFouls'];
    nameZhShort = json['nameZhShort'];
    logo = json['logo'];
    leagueCareerAge = json['leagueCareerAge'];
    shirtNumber = json['shirtNumber'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamQxbId'] = this.teamQxbId;
    data['scope'] = this.scope;
    data['points'] = this.points;
    data['freeThrowsAccuracy'] = this.freeThrowsAccuracy;
    data['threePointsAccuracy'] = this.threePointsAccuracy;
    data['fieldGoalsAccuracy'] = this.fieldGoalsAccuracy;
    data['rebounds'] = this.rebounds;
    data['assists'] = this.assists;
    data['turnovers'] = this.turnovers;
    data['steals'] = this.steals;
    data['blocks'] = this.blocks;
    data['personalFouls'] = this.personalFouls;
    data['nameZhShort'] = this.nameZhShort;
    data['logo'] = this.logo;
    data['leagueCareerAge'] = this.leagueCareerAge;
    data['shirtNumber'] = this.shirtNumber;
    data['position'] = this.position;
    return data;
  }
}
