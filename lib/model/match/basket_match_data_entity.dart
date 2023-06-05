class BasketMatchDataEntity {
  List<VsList>? vsHistory;
  List<VsList>? homeHistory;
  List<VsList>? awayHistory;
  List<RecentMatch>? homeFuture;
  List<RecentMatch>? awayFuture;
  CurrentMatchInfo? currentMatchInfo;

  BasketMatchDataEntity(
      {this.currentMatchInfo,
      this.vsHistory,
      this.homeHistory,
      this.awayHistory,
      this.homeFuture,
      this.awayFuture});

  BasketMatchDataEntity.fromJson(Map<String, dynamic> json) {
    currentMatchInfo = json['currentMatchInfo'] != null
        ? new CurrentMatchInfo.fromJson(json['currentMatchInfo'])
        : null;
    if (json['vsHistory'] != null) {
      vsHistory = <VsList>[];
      json['vsHistory'].forEach((v) {
        vsHistory!.add(new VsList.fromJson(v));
      });
    }
    if (json['homeHistory'] != null) {
      homeHistory = <VsList>[];
      json['homeHistory'].forEach((v) {
        homeHistory!.add(new VsList.fromJson(v));
      });
    }
    if (json['awayHistory'] != null) {
      awayHistory = <VsList>[];
      json['awayHistory'].forEach((v) {
        awayHistory!.add(new VsList.fromJson(v));
      });
    }
    if (json['homeFuture'] != null) {
      homeFuture = <RecentMatch>[];
      json['homeFuture'].forEach((v) {
        homeFuture!.add(new RecentMatch.fromJson(v));
      });
    }
    if (json['awayFuture'] != null) {
      awayFuture = <RecentMatch>[];
      json['awayFuture'].forEach((v) {
        awayFuture!.add(new RecentMatch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.currentMatchInfo != null) {
      data['currentMatchInfo'] = this.currentMatchInfo!.toJson();
    }
    if (this.vsHistory != null) {
      data['vsHistory'] = this.vsHistory!.map((v) => v.toJson()).toList();
    }
    if (this.homeHistory != null) {
      data['homeHistory'] = this.homeHistory!.map((v) => v.toJson()).toList();
    }
    if (this.awayHistory != null) {
      data['awayHistory'] = this.awayHistory!.map((v) => v.toJson()).toList();
    }
    if (this.homeFuture != null) {
      data['homeFuture'] = this.homeFuture!.map((v) => v.toJson()).toList();
    }
    if (this.awayFuture != null) {
      data['awayFuture'] = this.awayFuture!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentMatchInfo {
  String? homeName;
  String? homeLogo;
  String? awayName;
  String? awayLogo;
  int? homeSourceTeamId;
  int? awaySourceTeamId;
  int? homeQxbTeamId;
  int? awayQxbTeamId;
  int? sourceMatchId;
  int? qxbMatchId;
  int? seasonId;
  String? leagueName;
  int? leagueId;
  int? leagueQxbId;
  int? stageId;
  String? matchTime;
  String? homeScores;
  String? awayScores;
  int? periodCount;

  CurrentMatchInfo(
      {this.homeName,
      this.homeLogo,
      this.awayName,
      this.awayLogo,
      this.homeSourceTeamId,
      this.awaySourceTeamId,
      this.homeQxbTeamId,
      this.awayQxbTeamId,
      this.sourceMatchId,
      this.qxbMatchId,
      this.seasonId,
      this.leagueName,
      this.leagueId,
      this.leagueQxbId,
      this.stageId,
      this.matchTime,
      this.homeScores,
      this.awayScores,
      this.periodCount});

  CurrentMatchInfo.fromJson(Map<String, dynamic> json) {
    homeName = json['homeName'];
    homeLogo = json['homeLogo'];
    awayName = json['awayName'];
    awayLogo = json['awayLogo'];
    homeSourceTeamId = json['homeSourceTeamId'];
    awaySourceTeamId = json['awaySourceTeamId'];
    homeQxbTeamId = json['homeQxbTeamId'];
    awayQxbTeamId = json['awayQxbTeamId'];
    sourceMatchId = json['sourceMatchId'];
    qxbMatchId = json['qxbMatchId'];
    seasonId = json['seasonId'];
    leagueName = json['leagueName'];
    leagueId = json['leagueId'];
    leagueQxbId = json['leagueQxbId'];
    stageId = json['stageId'];
    matchTime = json['matchTime'];
    homeScores = json['homeScores'];
    awayScores = json['awayScores'];
    periodCount = json['periodCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homeName'] = this.homeName;
    data['homeLogo'] = this.homeLogo;
    data['awayName'] = this.awayName;
    data['awayLogo'] = this.awayLogo;
    data['homeSourceTeamId'] = this.homeSourceTeamId;
    data['awaySourceTeamId'] = this.awaySourceTeamId;
    data['homeQxbTeamId'] = this.homeQxbTeamId;
    data['awayQxbTeamId'] = this.awayQxbTeamId;
    data['sourceMatchId'] = this.sourceMatchId;
    data['qxbMatchId'] = this.qxbMatchId;
    data['seasonId'] = this.seasonId;
    data['leagueName'] = this.leagueName;
    data['leagueId'] = this.leagueId;
    data['leagueQxbId'] = this.leagueQxbId;
    data['stageId'] = this.stageId;
    data['matchTime'] = this.matchTime;
    data['homeScores'] = this.homeScores;
    data['awayScores'] = this.awayScores;
    data['periodCount'] = this.periodCount;
    return data;
  }
}

class VsList {
  String? matchTime;
  int? matchQxbId;
  String? leagueName;
  int? leagueQxbId;
  int? homeQxbId;
  int? awayQxbId;
  String? homeName;
  String? awayName;
  String? homeScore;
  String? awayScore;
  String? homeHalfScore;
  String? awayHalfScore;
  String? ypLine;
  int? ypStatus;
  String? ypStatusCn;
  String? dxLine;
  int? dxStatus;
  String? dxStatusCn;
  int? homeWin;

  VsList(
      {this.matchTime,
      this.matchQxbId,
      this.leagueName,
      this.leagueQxbId,
      this.homeQxbId,
      this.awayQxbId,
      this.homeName,
      this.awayName,
      this.homeScore,
      this.awayScore,
      this.homeHalfScore,
      this.awayHalfScore,
      this.ypLine,
      this.ypStatus,
      this.ypStatusCn,
      this.dxLine,
      this.dxStatus,
      this.dxStatusCn,
      this.homeWin});

  VsList.fromJson(Map<String, dynamic> json) {
    matchTime = json['matchTime'];
    matchQxbId = json['matchQxbId'];
    leagueName = json['leagueName'];
    leagueQxbId = json['leagueQxbId'];
    homeQxbId = json['homeQxbId'];
    awayQxbId = json['awayQxbId'];
    homeName = json['homeName'];
    awayName = json['awayName'];
    homeScore = json['homeScore'];
    awayScore = json['awayScore'];
    homeHalfScore = json['homeHalfScore'];
    awayHalfScore = json['awayHalfScore'];
    ypLine = json['ypLine'];
    ypStatus = json['ypStatus'];
    ypStatusCn = json['ypStatusCn'];
    dxLine = json['dxLine'];
    dxStatus = json['dxStatus'];
    dxStatusCn = json['dxStatusCn'];
    homeWin = json['homeWin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchTime'] = this.matchTime;
    data['matchQxbId'] = this.matchQxbId;
    data['leagueName'] = this.leagueName;
    data['leagueQxbId'] = this.leagueQxbId;
    data['homeQxbId'] = this.homeQxbId;
    data['awayQxbId'] = this.awayQxbId;
    data['homeName'] = this.homeName;
    data['awayName'] = this.awayName;
    data['homeScore'] = this.homeScore;
    data['awayScore'] = this.awayScore;
    data['homeHalfScore'] = this.homeHalfScore;
    data['awayHalfScore'] = this.awayHalfScore;
    data['ypLine'] = this.ypLine;
    data['ypStatus'] = this.ypStatus;
    data['ypStatusCn'] = this.ypStatusCn;
    data['dxLine'] = this.dxLine;
    data['dxStatus'] = this.dxStatus;
    data['dxStatusCn'] = this.dxStatusCn;
    data['homeWin'] = this.homeWin;
    return data;
  }
}

class RecentMatch {
  String? homeName;
  String? awayName;
  int? homeQxbId;
  int? awayQxbId;
  int? matchQxbId;
  int? leagueQxbId;
  String? matchTime;
  String? leagueName;
  String? offsetDay;

  RecentMatch(
      {this.homeName,
      this.awayName,
      this.homeQxbId,
      this.awayQxbId,
      this.matchQxbId,
      this.leagueQxbId,
      this.matchTime,
      this.leagueName,
      this.offsetDay});

  RecentMatch.fromJson(Map<String, dynamic> json) {
    homeName = json['homeName'];
    awayName = json['awayName'];
    homeQxbId = json['homeQxbId'];
    awayQxbId = json['awayQxbId'];
    matchQxbId = json['matchQxbId'];
    leagueQxbId = json['leagueQxbId'];
    matchTime = json['matchTime'];
    leagueName = json['leagueName'];
    offsetDay = json['offsetDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homeName'] = this.homeName;
    data['awayName'] = this.awayName;
    data['homeQxbId'] = this.homeQxbId;
    data['awayQxbId'] = this.awayQxbId;
    data['matchQxbId'] = this.matchQxbId;
    data['leagueQxbId'] = this.leagueQxbId;
    data['matchTime'] = this.matchTime;
    data['leagueName'] = this.leagueName;
    data['offsetDay'] = this.offsetDay;
    return data;
  }
}
