class MatchPointEntity {
  int? guestId;
  int? homeId;
  int? leagueId;
  int? matchId;
  List<StandingPointList>? standingCupList1;
  List<StandingPointList>? standingCupList2;
  List<StandingPointList>? standingList1;
  List<StandingPointList>? standingList2;

  MatchPointEntity(
      {this.guestId,
      this.homeId,
      this.leagueId,
      this.matchId,
      this.standingCupList1,
      this.standingCupList2,
      this.standingList1,
      this.standingList2});

  MatchPointEntity.fromJson(Map<String, dynamic> json) {
    guestId = json['guestId'];
    homeId = json['homeId'];
    leagueId = json['leagueId'];
    matchId = json['matchId'];
    if (json['standingCupList1'] != null) {
      standingCupList1 = <StandingPointList>[];
      json['standingCupList1'].forEach((v) {
        standingCupList1!.add(new StandingPointList.fromJson(v));
      });
    }
    if (json['standingCupList2'] != null) {
      standingCupList2 = <StandingPointList>[];
      json['standingCupList2'].forEach((v) {
        standingCupList2!.add(new StandingPointList.fromJson(v));
      });
    }
    if (json['standingList1'] != null) {
      standingList1 = <StandingPointList>[];
      json['standingList1'].forEach((v) {
        standingList1!.add(new StandingPointList.fromJson(v));
      });
    }
    if (json['standingList2'] != null) {
      standingList2 = <StandingPointList>[];
      json['standingList2'].forEach((v) {
        standingList2!.add(new StandingPointList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guestId'] = this.guestId;
    data['homeId'] = this.homeId;
    data['leagueId'] = this.leagueId;
    data['matchId'] = this.matchId;
    if (this.standingCupList1 != null) {
      data['standingCupList1'] =
          this.standingCupList1!.map((v) => v.toJson()).toList();
    }
    if (this.standingCupList2 != null) {
      data['standingCupList2'] =
          this.standingCupList2!.map((v) => v.toJson()).toList();
    }
    if (this.standingList1 != null) {
      data['standingList1'] =
          this.standingList1!.map((v) => v.toJson()).toList();
    }
    if (this.standingList2 != null) {
      data['standingList2'] =
          this.standingList2!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StandingPointList {
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
  int? sourceTeamId;
  int? sourceleagueId;
  int? tag;
  int? teamId;
  String? teamName;
  int? totalCount;
  int? type;
  int? winCount;

  StandingPointList(
      {this.drawCount,
      this.getScore,
      this.goalDifference,
      this.groupCn,
      this.integral,
      this.leagueId,
      this.leagueName,
      this.loseCount,
      this.loseScore,
      this.rank,
      this.season,
      this.source,
      this.sourceTeamId,
      this.sourceleagueId,
      this.tag,
      this.teamId,
      this.teamName,
      this.totalCount,
      this.type,
      this.winCount});

  StandingPointList.fromJson(Map<String, dynamic> json) {
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
    sourceTeamId = json['sourceTeamId'];
    sourceleagueId = json['sourceleagueId'];
    tag = json['tag'];
    teamId = json['teamId'];
    teamName = json['teamName'];
    totalCount = json['totalCount'];
    type = json['type'];
    winCount = json['winCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['sourceTeamId'] = this.sourceTeamId;
    data['sourceleagueId'] = this.sourceleagueId;
    data['tag'] = this.tag;
    data['teamId'] = this.teamId;
    data['teamName'] = this.teamName;
    data['totalCount'] = this.totalCount;
    data['type'] = this.type;
    data['winCount'] = this.winCount;
    return data;
  }
}
