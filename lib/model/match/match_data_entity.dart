class MatchDataEntity {
  int? source;
  int? matchId;
  int? homeId;
  int? guestId;
  int? leagueId;
  List<ShootTimeList>? shootTimeList;
  List<VsList>? vsList;
  List<VsList>? homeVsList;
  List<VsList>? guestVsList;
  List<MatchList>? homeMatchList;
  List<MatchList>? guestMatchList;
  List<StandingList>? standingList;
  List<StandingList>? standingCupList;

  MatchDataEntity(
      {this.source,
      this.matchId,
      this.homeId,
      this.guestId,
      this.leagueId,
      this.shootTimeList,
      this.vsList,
      this.homeVsList,
      this.guestVsList,
      this.homeMatchList,
      this.guestMatchList});

  MatchDataEntity.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    matchId = json['matchId'];
    homeId = json['homeId'];
    guestId = json['guestId'];
    leagueId = json['leagueId'];
    if (json['shootTimeList'] != null) {
      shootTimeList = <ShootTimeList>[];
      json['shootTimeList'].forEach((v) {
        shootTimeList!.add(new ShootTimeList.fromJson(v));
      });
    }
    if (json['vsList'] != null) {
      vsList = <VsList>[];
      json['vsList'].forEach((v) {
        vsList!.add(new VsList.fromJson(v));
      });
    }
    if (json['homeVsList'] != null) {
      homeVsList = <VsList>[];
      json['homeVsList'].forEach((v) {
        homeVsList!.add(new VsList.fromJson(v));
      });
    }
    if (json['guestVsList'] != null) {
      guestVsList = <VsList>[];
      json['guestVsList'].forEach((v) {
        guestVsList!.add(new VsList.fromJson(v));
      });
    }
    if (json['homeMatchList'] != null) {
      homeMatchList = <MatchList>[];
      json['homeMatchList'].forEach((v) {
        homeMatchList!.add(new MatchList.fromJson(v));
      });
    }
    if (json['guestMatchList'] != null) {
      guestMatchList = <MatchList>[];
      json['guestMatchList'].forEach((v) {
        guestMatchList!.add(new MatchList.fromJson(v));
      });
    }
    if (json['standingList'] != null) {
      standingList = <StandingList>[];
      json['standingList'].forEach((v) {
        standingList!.add(new StandingList.fromJson(v));
      });
    }
    if (json['standingCupList'] != null) {
      standingCupList = <StandingList>[];
      json['standingCupList'].forEach((v) {
        standingCupList!.add(new StandingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    data['matchId'] = this.matchId;
    data['homeId'] = this.homeId;
    data['guestId'] = this.guestId;
    data['leagueId'] = this.leagueId;
    if (this.shootTimeList != null) {
      data['shootTimeList'] =
          this.shootTimeList!.map((v) => v.toJson()).toList();
    }
    if (this.vsList != null) {
      data['vsList'] = this.vsList!.map((v) => v.toJson()).toList();
    }
    if (this.homeVsList != null) {
      data['homeVsList'] = this.homeVsList!.map((v) => v.toJson()).toList();
    }
    if (this.guestVsList != null) {
      data['guestVsList'] = this.guestVsList!.map((v) => v.toJson()).toList();
    }
    if (this.homeMatchList != null) {
      data['homeMatchList'] =
          this.homeMatchList!.map((v) => v.toJson()).toList();
    }
    if (this.guestMatchList != null) {
      data['guestMatchList'] =
          this.guestMatchList!.map((v) => v.toJson()).toList();
    }
    if (this.standingList != null) {
      data['standingList'] = this.standingList!.map((v) => v.toJson()).toList();
    }
    if (this.standingCupList != null) {
      data['standingCupList'] =
          this.standingCupList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShootTimeList {
  int? teamType;
  int? type1;
  int? type2;
  int? time1;
  int? time2;
  int? time3;
  int? time4;
  int? time5;
  int? time6;
  int? time7;
  int? time8;
  int? time9;
  int? time10;
  int? total;

  ShootTimeList(
      {this.teamType,
      this.type1,
      this.type2,
      this.time1,
      this.time2,
      this.time3,
      this.time4,
      this.time5,
      this.time6,
      this.time7,
      this.time8,
      this.time9,
      this.time10,
      this.total});

  ShootTimeList.fromJson(Map<String, dynamic> json) {
    teamType = json['teamType'];
    type1 = json['type1'];
    type2 = json['type2'];
    time1 = json['time1'];
    time2 = json['time2'];
    time3 = json['time3'];
    time4 = json['time4'];
    time5 = json['time5'];
    time6 = json['time6'];
    time7 = json['time7'];
    time8 = json['time8'];
    time9 = json['time9'];
    time10 = json['time10'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamType'] = this.teamType;
    data['type1'] = this.type1;
    data['type2'] = this.type2;
    data['time1'] = this.time1;
    data['time2'] = this.time2;
    data['time3'] = this.time3;
    data['time4'] = this.time4;
    data['time5'] = this.time5;
    data['time6'] = this.time6;
    data['time7'] = this.time7;
    data['time8'] = this.time8;
    data['time9'] = this.time9;
    data['time10'] = this.time10;
    data['total'] = this.total;
    return data;
  }
}

class VsList {
  int? id;
  int? matchId;
  int? leagueId;
  String? leagueName;
  String? matchTime;
  String? matchAddr;
  int? homeId;
  String? homeName;
  int? guestId;
  String? guestName;
  int? homeScore;
  int? homeHalfScore;
  int? homeRed;
  int? homeCorner;
  int? guestScore;
  int? guestHalfScore;
  int? guestRed;
  int? guestCorner;
  int? win;
  String? ah1;
  String? ah1Home;
  String? ah1Guest;
  String? ah2;
  String? ah2Home;
  String? ah2Guest;
  int? ah1Win;
  int? ah2Win;
  String? odds1W;
  String? odds1D;
  String? odds1L;
  String? odds2W;
  String? odds2D;
  String? odds2L;
  int? odds1Win;
  int? odds2Win;
  String? sb1;
  String? sb1Home;
  String? sb1Guest;
  String? sb2;
  String? sb2Home;
  String? sb2Guest;
  int? sb1Win;
  int? sb2Win;

  VsList(
      {this.id,
      this.matchId,
      this.leagueId,
      this.leagueName,
      this.matchTime,
      this.matchAddr,
      this.homeId,
      this.homeName,
      this.guestId,
      this.guestName,
      this.homeScore,
      this.homeHalfScore,
      this.homeRed,
      this.homeCorner,
      this.guestScore,
      this.guestHalfScore,
      this.guestRed,
      this.guestCorner,
      this.win,
      this.ah1,
      this.ah1Home,
      this.ah1Guest,
      this.ah2,
      this.ah2Home,
      this.ah2Guest,
      this.ah1Win,
      this.ah2Win,
      this.odds1W,
      this.odds1D,
      this.odds1L,
      this.odds2W,
      this.odds2D,
      this.odds2L,
      this.odds1Win,
      this.odds2Win,
      this.sb1,
      this.sb1Home,
      this.sb1Guest,
      this.sb2,
      this.sb2Home,
      this.sb2Guest,
      this.sb1Win,
      this.sb2Win});

  VsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matchId = json['matchId'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    matchTime = json['matchTime'];
    matchAddr = json['matchAddr'];
    homeId = json['homeId'];
    homeName = json['homeName'];
    guestId = json['guestId'];
    guestName = json['guestName'];
    homeScore = json['homeScore'];
    homeHalfScore = json['homeHalfScore'];
    homeRed = json['homeRed'];
    homeCorner = json['homeCorner'];
    guestScore = json['guestScore'];
    guestHalfScore = json['guestHalfScore'];
    guestRed = json['guestRed'];
    guestCorner = json['guestCorner'];
    win = json['win'];
    ah1 = json['ah1'];
    ah1Home = json['ah1Home'];
    ah1Guest = json['ah1Guest'];
    ah2 = json['ah2'];
    ah2Home = json['ah2Home'];
    ah2Guest = json['ah2Guest'];
    ah1Win = json['ah1Win'];
    ah2Win = json['ah2Win'];
    odds1W = json['odds1W'];
    odds1D = json['odds1D'];
    odds1L = json['odds1L'];
    odds2W = json['odds2W'];
    odds2D = json['odds2D'];
    odds2L = json['odds2L'];
    odds1Win = json['odds1Win'];
    odds2Win = json['odds2Win'];
    sb1 = json['sb1'];
    sb1Home = json['sb1Home'];
    sb1Guest = json['sb1Guest'];
    sb2 = json['sb2'];
    sb2Home = json['sb2Home'];
    sb2Guest = json['sb2Guest'];
    sb1Win = json['sb1Win'];
    sb2Win = json['sb2Win'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['matchId'] = this.matchId;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['matchTime'] = this.matchTime;
    data['matchAddr'] = this.matchAddr;
    data['homeId'] = this.homeId;
    data['homeName'] = this.homeName;
    data['guestId'] = this.guestId;
    data['guestName'] = this.guestName;
    data['homeScore'] = this.homeScore;
    data['homeHalfScore'] = this.homeHalfScore;
    data['homeRed'] = this.homeRed;
    data['homeCorner'] = this.homeCorner;
    data['guestScore'] = this.guestScore;
    data['guestHalfScore'] = this.guestHalfScore;
    data['guestRed'] = this.guestRed;
    data['guestCorner'] = this.guestCorner;
    data['win'] = this.win;
    data['ah1'] = this.ah1;
    data['ah1Home'] = this.ah1Home;
    data['ah1Guest'] = this.ah1Guest;
    data['ah2'] = this.ah2;
    data['ah2Home'] = this.ah2Home;
    data['ah2Guest'] = this.ah2Guest;
    data['ah1Win'] = this.ah1Win;
    data['ah2Win'] = this.ah2Win;
    data['odds1W'] = this.odds1W;
    data['odds1D'] = this.odds1D;
    data['odds1L'] = this.odds1L;
    data['odds2W'] = this.odds2W;
    data['odds2D'] = this.odds2D;
    data['odds2L'] = this.odds2L;
    data['odds1Win'] = this.odds1Win;
    data['odds2Win'] = this.odds2Win;
    data['sb1'] = this.sb1;
    data['sb1Home'] = this.sb1Home;
    data['sb1Guest'] = this.sb1Guest;
    data['sb2'] = this.sb2;
    data['sb2Home'] = this.sb2Home;
    data['sb2Guest'] = this.sb2Guest;
    data['sb1Win'] = this.sb1Win;
    data['sb2Win'] = this.sb2Win;
    return data;
  }
}

class MatchList {
  int? id;
  int? matchId;
  int? leagueId;
  String? leagueName;
  String? matchTime;
  String? matchAddr;
  int? homeId;
  String? homeName;
  int? guestId;
  String? guestName;
  String? days;

  MatchList(
      {this.id,
      this.matchId,
      this.leagueId,
      this.leagueName,
      this.matchTime,
      this.matchAddr,
      this.homeId,
      this.homeName,
      this.guestId,
      this.guestName,
      this.days});

  MatchList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matchId = json['matchId'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    matchTime = json['matchTime'];
    matchAddr = json['matchAddr'];
    homeId = json['homeId'];
    homeName = json['homeName'];
    guestId = json['guestId'];
    guestName = json['guestName'];
    days = json['days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['matchId'] = this.matchId;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['matchTime'] = this.matchTime;
    data['matchAddr'] = this.matchAddr;
    data['homeId'] = this.homeId;
    data['homeName'] = this.homeName;
    data['guestId'] = this.guestId;
    data['guestName'] = this.guestName;
    data['days'] = this.days;
    return data;
  }
}

class StandingList {
  int? source;
  int? leagueId;
  int? sourceleagueId;
  String? leagueName;
  String? season;
  String? groupCn;
  int? type;
  int? rank;
  int? teamId;
  int? sourceTeamId;
  String? teamName;
  int? totalCount;
  int? winCount;
  int? drawCount;
  int? loseCount;
  int? getScore;
  int? loseScore;
  int? goalDifference;
  int? integral;

  StandingList(
      {this.source,
      this.leagueId,
      this.sourceleagueId,
      this.leagueName,
      this.season,
      this.groupCn,
      this.type,
      this.rank,
      this.teamId,
      this.sourceTeamId,
      this.teamName,
      this.totalCount,
      this.winCount,
      this.drawCount,
      this.loseCount,
      this.getScore,
      this.loseScore,
      this.goalDifference,
      this.integral});

  StandingList.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    leagueId = json['leagueId'];
    sourceleagueId = json['sourceleagueId'];
    leagueName = json['leagueName'];
    season = json['season'];
    groupCn = json['groupCn'];
    type = json['type'];
    rank = json['rank'];
    teamId = json['teamId'];
    sourceTeamId = json['sourceTeamId'];
    teamName = json['teamName'];
    totalCount = json['totalCount'];
    winCount = json['winCount'];
    drawCount = json['drawCount'];
    loseCount = json['loseCount'];
    getScore = json['getScore'];
    loseScore = json['loseScore'];
    goalDifference = json['goalDifference'];
    integral = json['integral'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    data['leagueId'] = this.leagueId;
    data['sourceleagueId'] = this.sourceleagueId;
    data['leagueName'] = this.leagueName;
    data['season'] = this.season;
    data['groupCn'] = this.groupCn;
    data['type'] = this.type;
    data['rank'] = this.rank;
    data['teamId'] = this.teamId;
    data['sourceTeamId'] = this.sourceTeamId;
    data['teamName'] = this.teamName;
    data['totalCount'] = this.totalCount;
    data['winCount'] = this.winCount;
    data['drawCount'] = this.drawCount;
    data['loseCount'] = this.loseCount;
    data['getScore'] = this.getScore;
    data['loseScore'] = this.loseScore;
    data['goalDifference'] = this.goalDifference;
    data['integral'] = this.integral;
    return data;
  }
}
