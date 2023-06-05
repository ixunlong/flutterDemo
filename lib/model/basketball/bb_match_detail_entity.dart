import 'dart:math';

class BbMatchDetailEntity {
  String? awayHalfScore;
  String? awayPosition;
  String? awayScore;
  int? awayTeamId;
  String? awayTeamName;
  String? groupNum;
  String? homeHalfScore;
  String? homePosition;
  String? homeScore;
  int? homeTeamId;
  String? homeTeamName;
  int? kind;
  String? leagueName;
  int? matchId;
  String? matchPursueScore;
  String? matchScore;
  String? matchTime;
  String? roundNum;
  int? periodCount;
  int? needPeriod;
  int? statusId;

  String? homeTeamLogo;
  String? awayTeamLogo;

  DetailMatchScoreEntity? appMatchScore;
  List<DetailMatchTeamEntity>? appMatchTeams;
  List<DetailMatchLiveTextEntity>? appMatchTlives;
  List<DetailMatchTrendEntity>? appMatchTrends;
  List<DetailMatchTechEntity>? appMatchItems;

  BbMatchDetailEntity(
      {this.awayHalfScore,
      this.awayPosition,
      this.awayScore,
      this.awayTeamId,
      this.awayTeamName,
      this.groupNum,
      this.homeHalfScore,
      this.homePosition,
      this.homeScore,
      this.homeTeamId,
      this.homeTeamName,
      this.kind,
      this.leagueName,
      this.matchId,
      this.matchPursueScore,
      this.matchScore,
      this.matchTime,
      this.roundNum,
      this.statusId,
      this.appMatchScore,
      this.appMatchTeams,
      this.appMatchTlives,
      this.appMatchTrends,
      this.appMatchItems,
      this.periodCount,
      this.needPeriod});

  BbMatchDetailEntity.fromJson(Map<String, dynamic> json) {
    awayHalfScore = json['awayHalfScore'];
    awayPosition = json['awayPosition'];
    awayScore = json['awayScore'];
    awayTeamId = json['awayTeamId'];
    awayTeamName = json['awayTeamName'];
    groupNum = json['groupNum'];
    homeHalfScore = json['homeHalfScore'];
    homePosition = json['homePosition'];
    homeScore = json['homeScore'];
    homeTeamId = json['homeTeamId'];
    homeTeamName = json['homeTeamName'];
    kind = json['kind'];
    leagueName = json['leagueName'];
    matchId = json['matchId'];
    matchPursueScore = json['matchPursueScore'];
    matchScore = json['matchScore'];
    matchTime = json['matchTime'];
    roundNum = json['roundNum'];
    statusId = json['statusId'];
    homeTeamLogo = json['homeTeamLogo'];
    awayTeamLogo = json['awayTeamLogo'];
    periodCount = json['periodCount'];
    needPeriod = json['needPeriod'];

    appMatchScore = DetailMatchScoreEntity.fromJson(json['appMatchScore']);
    if (json['appMatchTeams'] != null) {
      appMatchTeams = (json['appMatchTeams'].map<DetailMatchTeamEntity>((e)=>DetailMatchTeamEntity.fromJson(e))).toList();
    }
    if (json['appMatchTlives'] != null) {
      appMatchTlives = (json['appMatchTlives'].map<DetailMatchLiveTextEntity>((e)=>DetailMatchLiveTextEntity.fromJson(e))).toList();
    }
    if (json['appMatchTrends'] != null) {
      appMatchTrends = (json['appMatchTrends'].map<DetailMatchTrendEntity>((e)=>DetailMatchTrendEntity.fromJson(e))).toList();
    }
    if (json['appMatchItems'] != null) {
      appMatchItems = (json['appMatchItems'].map<DetailMatchTechEntity>((e)=>DetailMatchTechEntity.fromJson(e))).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['awayHalfScore'] = this.awayHalfScore;
    data['awayPosition'] = this.awayPosition;
    data['awayScore'] = this.awayScore;
    data['awayTeamId'] = this.awayTeamId;
    data['awayTeamName'] = this.awayTeamName;
    data['groupNum'] = this.groupNum;
    data['homeHalfScore'] = this.homeHalfScore;
    data['homePosition'] = this.homePosition;
    data['homeScore'] = this.homeScore;
    data['homeTeamId'] = this.homeTeamId;
    data['homeTeamName'] = this.homeTeamName;
    data['kind'] = this.kind;
    data['leagueName'] = this.leagueName;
    data['matchId'] = this.matchId;
    data['matchPursueScore'] = this.matchPursueScore;
    data['matchScore'] = this.matchScore;
    data['matchTime'] = this.matchTime;
    data['roundNum'] = this.roundNum;
    data['statusId'] = this.statusId;
    data['homeTeamLogo'] = homeTeamLogo;
    data['awayTeamLogo'] = awayTeamLogo;
    data['periodCount'] = periodCount;
    data['needPeriod'] = needPeriod;
    
    data['appMatchTrends'] = appMatchTrends?.map((e) => e.toJson());
    data['appMatchTeams'] = appMatchTeams?.map((e) => e.toJson());
    data['appMatchScore'] = appMatchScore?.toJson();
    data['appMatchTlives'] = appMatchTlives?.map((e) => e.toJson());
    return data;
  }
}

class DetailMatchTrendEntity {
  int? count;
  String? data;
  int? matchId;
  int? per;

  DetailMatchTrendEntity({this.count, this.data, this.matchId, this.per});

  DetailMatchTrendEntity.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'];
    matchId = json['matchId'];
    per = json['per'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['data'] = this.data;
    data['matchId'] = this.matchId;
    data['per'] = this.per;
    return data;
  }
}

class DetailMatchLiveTextEntity {
  List<DetailMatchLiveTextDataEntity>? data;
  String? name;

  DetailMatchLiveTextEntity({this.data, this.name});

  DetailMatchLiveTextEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DetailMatchLiveTextDataEntity>[];
      json['data'].forEach((v) {
        data!.add(new DetailMatchLiveTextDataEntity.fromJson(v));
      });
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    return data;
  }
}

class DetailMatchLiveTextDataEntity {
  String? data;
  int? id;
  int? periodNum;
  String? periodNumName;
  String? scores;
  int? teamType;
  String? time;

  DetailMatchLiveTextDataEntity(
      {this.data,
      this.id,
      this.periodNum,
      this.periodNumName,
      this.scores,
      this.teamType,
      this.time});

  DetailMatchLiveTextDataEntity.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    id = json['id'];
    periodNum = json['periodNum'];
    periodNumName = json['periodNumName'];
    scores = json['scores'];
    teamType = json['teamType'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['id'] = this.id;
    data['periodNum'] = this.periodNum;
    data['periodNumName'] = this.periodNumName;
    data['scores'] = this.scores;
    data['teamType'] = this.teamType;
    data['time'] = this.time;
    return data;
  }
}

class DetailMatchTechEntity {
  String? away;
  String? awayVis;
  String? home;
  String? homeVis;
  String? name;

  DetailMatchTechEntity({this.away, this.home, this.name,this.awayVis,this.homeVis});

  DetailMatchTechEntity.fromJson(Map<String, dynamic> json) {
    away = json['away'];
    home = json['home'];
    name = json['name'];
    awayVis = json['awayVis'];
    homeVis = json['homeVis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['away'] = this.away;
    data['home'] = this.home;
    data['name'] = this.name;
    data['awayVis'] = awayVis;
    data['homeVis'] = homeVis;
    return data;
  }
}

class DetailMatchTeamEntity {
  int? assists;
  int? blocks;
  int? defensiveRebounds;
  int? fieldGoalsScored;
  int? fieldGoalsTotal;
  int? freeThrowsScored;
  int? freeThrowsTotal;
  int? matchId;
  int? offensiveRebounds;
  int? personalFouls;
  int? points;
  int? rebounds;
  int? steals;
  int? teamType;
  int? threePointsScored;
  int? threePointsTotal;
  int? turnovers;

  DetailMatchTeamEntity(
      {this.assists,
      this.blocks,
      this.defensiveRebounds,
      this.fieldGoalsScored,
      this.fieldGoalsTotal,
      this.freeThrowsScored,
      this.freeThrowsTotal,
      this.matchId,
      this.offensiveRebounds,
      this.personalFouls,
      this.points,
      this.rebounds,
      this.steals,
      this.teamType,
      this.threePointsScored,
      this.threePointsTotal,
      this.turnovers});

  DetailMatchTeamEntity.fromJson(Map<String, dynamic> json) {
    assists = json['assists'];
    blocks = json['blocks'];
    defensiveRebounds = json['defensiveRebounds'];
    fieldGoalsScored = json['fieldGoalsScored'];
    fieldGoalsTotal = json['fieldGoalsTotal'];
    freeThrowsScored = json['freeThrowsScored'];
    freeThrowsTotal = json['freeThrowsTotal'];
    matchId = json['matchId'];
    offensiveRebounds = json['offensiveRebounds'];
    personalFouls = json['personalFouls'];
    points = json['points'];
    rebounds = json['rebounds'];
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
    data['freeThrowsScored'] = this.freeThrowsScored;
    data['freeThrowsTotal'] = this.freeThrowsTotal;
    data['matchId'] = this.matchId;
    data['offensiveRebounds'] = this.offensiveRebounds;
    data['personalFouls'] = this.personalFouls;
    data['points'] = this.points;
    data['rebounds'] = this.rebounds;
    data['steals'] = this.steals;
    data['teamType'] = this.teamType;
    data['threePointsScored'] = this.threePointsScored;
    data['threePointsTotal'] = this.threePointsTotal;
    data['turnovers'] = this.turnovers;
    return data;
  }
}

class DetailMatchScoreEntity {
  String? awayFoul;
  String? awayFour;
  String? awayOne;
  String? awayOt;
  String? awayScore;
  String? awayThree;
  String? awayTimeOut;
  String? awayTwo;
  String? homeFoul;
  String? homeFour;
  String? homeOne;
  String? homeOt;
  String? homeScore;
  String? homeThree;
  String? homeTimeOut;
  String? homeTwo;
  List<BbScoreArrayEntity>? homeArray;
  List<BbScoreArrayEntity>? awayArray;

  DetailMatchScoreEntity(
      {this.awayFoul,
      this.awayFour,
      this.awayOne,
      this.awayOt,
      this.awayScore,
      this.awayThree,
      this.awayTimeOut,
      this.awayTwo,
      this.homeFoul,
      this.homeFour,
      this.homeOne,
      this.homeOt,
      this.homeScore,
      this.homeThree,
      this.homeTimeOut,
      this.homeTwo,
      this.homeArray,
      this.awayArray});

  DetailMatchScoreEntity.fromJson(Map<String, dynamic> json) {
    awayFoul = json['awayFoul'];
    awayFour = json['awayFour'];
    awayOne = json['awayOne'];
    awayOt = json['awayOt'];
    awayScore = json['awayScore'];
    awayThree = json['awayThree'];
    awayTimeOut = json['awayTimeOut'];
    awayTwo = json['awayTwo'];
    homeFoul = json['homeFoul'];
    homeFour = json['homeFour'];
    homeOne = json['homeOne'];
    homeOt = json['homeOt'];
    homeScore = json['homeScore'];
    homeThree = json['homeThree'];
    homeTimeOut = json['homeTimeOut'];
    homeTwo = json['homeTwo'];
    if (json['homeArray'] != null) {
      List<BbScoreArrayEntity> arr = [];
      for (var element in json['homeArray']) {
        arr.add(BbScoreArrayEntity.fromJson(element));
      }
      homeArray = arr;
    }
    if (json['awayArray'] != null) {
      List<BbScoreArrayEntity> arr = [];
      for (var element in json['awayArray']) {
        arr.add(BbScoreArrayEntity.fromJson(element));
      }
      awayArray = arr;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['awayFoul'] = this.awayFoul;
    data['awayFour'] = this.awayFour;
    data['awayOne'] = this.awayOne;
    data['awayOt'] = this.awayOt;
    data['awayScore'] = this.awayScore;
    data['awayThree'] = this.awayThree;
    data['awayTimeOut'] = this.awayTimeOut;
    data['awayTwo'] = this.awayTwo;
    data['homeFoul'] = this.homeFoul;
    data['homeFour'] = this.homeFour;
    data['homeOne'] = this.homeOne;
    data['homeOt'] = this.homeOt;
    data['homeScore'] = this.homeScore;
    data['homeThree'] = this.homeThree;
    data['homeTimeOut'] = this.homeTimeOut;
    data['homeTwo'] = this.homeTwo;
    data['homeArray'] = homeArray?.map((e) => e.toJson()).toList();
    data['awayArray'] = awayArray?.map((e) => e.toJson()).toList();
    return data;
  }
}

class BbScoreArrayEntity {
  String? count;
  String? name;

  BbScoreArrayEntity({this.count, this.name});

  BbScoreArrayEntity.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['name'] = this.name;
    return data;
  }
}

class BbScoreItem {
  const BbScoreItem(this.name,{this.home,this.away});
  final String name;
  final int? home;
  final int? away;
}

extension BbMatchDetailEntityEx1 on BbMatchDetailEntity {

  DateTime? get matchDateTime => DateTime.tryParse(matchTime ?? "");
  
  // 分钟
  int get perTime => (appMatchTrends?.isEmpty ?? true) ? 0 : (appMatchTrends!.first.per ?? 0);
  // 比赛节数
  int get matchCount => periodCount ?? 0;

  List<int?> _getScores(List<String?> ss) {
    final scores = ss.map((e) => int.tryParse(e ?? "")).toList();
    if (periodCount == 4) { return scores; }
    final n1 = scores.first == null ? null : (scores[0] ?? 0) + (scores[1] ?? 0);
    final n2 = scores[2] == null ? null : (scores[2] ?? 0) + (scores[3] ?? 0) + (scores[4] ?? 0);
    return [n1,n2,null,null,null];
  }

  List<int?> homeScores() {
    int c = 0;
    return _getScores([appMatchScore?.homeOne,appMatchScore?.homeTwo,appMatchScore?.homeThree,appMatchScore?.homeFour,appMatchScore?.homeOt])
      .map((e) => (needPeriod ?? 0) > c++ ? e : null ).toList();
  }
  List<int?> awayScores() {
    int c = 0;
    return _getScores([appMatchScore?.awayOne,appMatchScore?.awayTwo,appMatchScore?.awayThree,appMatchScore?.awayFour,appMatchScore?.awayOt])
      .map((e) => (needPeriod ?? 0) > c++ ? e : null ).toList();
  }

  List<BbScoreItem> scoreArray() {
    final a = appMatchScore?.awayArray;
    final h = appMatchScore?.homeArray;

    // dev.log("scores away = ${a?.map((e) => e.toJson())}");
    // dev.log("scores home = ${h?.map((e) => e.toJson())}");
    
    if (a == null || h == null) { return List<BbScoreItem>.empty(growable: true); }
    final count = min(a.length, h.length);
    final l = List<BbScoreItem>.empty(growable: true);
    for (var i = 0; i < count; i++) {
      final hitem = h[i];
      final aitem = a[i];
      if (hitem.name == '总分') { continue; }
      l.add(BbScoreItem(hitem.name ?? "-",home: int.tryParse(hitem.count ?? "-"),away: int.tryParse(aitem.count ?? "-")));
    }
    return l;
  }

}