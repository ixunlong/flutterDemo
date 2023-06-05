class TeamScheduleEntity {
  List<LeagueArray>? leagueArray;
  List<MatchGroup>? matchGroup;

  TeamScheduleEntity({this.leagueArray, this.matchGroup});

  TeamScheduleEntity.fromJson(Map<String, dynamic> json) {
    if (json['leagueArray'] != null) {
      leagueArray = <LeagueArray>[];
      json['leagueArray'].forEach((v) {
        leagueArray!.add(new LeagueArray.fromJson(v));
      });
    }
    if (json['matchGroup'] != null) {
      matchGroup = <MatchGroup>[];
      json['matchGroup'].forEach((v) {
        matchGroup!.add(new MatchGroup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leagueArray != null) {
      data['leagueArray'] = this.leagueArray!.map((v) => v.toJson()).toList();
    }
    if (this.matchGroup != null) {
      data['matchGroup'] = this.matchGroup!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeagueArray {
  int? leagueId;
  String? leagueName;

  LeagueArray({this.leagueId, this.leagueName});

  LeagueArray.fromJson(Map<String, dynamic> json) {
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    return data;
  }
}

class MatchGroup {
  List<MatchArray>? matchArray;
  String? title;

  MatchGroup({this.matchArray, this.title});

  MatchGroup.fromJson(Map<String, dynamic> json) {
    if (json['matchArray'] != null) {
      matchArray = <MatchArray>[];
      json['matchArray'].forEach((v) {
        matchArray!.add(new MatchArray.fromJson(v));
      });
    }
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.matchArray != null) {
      data['matchArray'] = this.matchArray!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    return data;
  }
}

class MatchArray {
  String? groupCn;
  int? guestId;
  String? guestLogo;
  String? guestName;
  String? guestScore90;
  String? guestScoreOt;
  String? guestScorePk;
  int? homeId;
  String? homeLogo;
  String? homeName;
  String? homeScore90;
  String? homeScoreOt;
  String? homeScorePk;
  int? isWin;
  int? leagueId;
  String? leagueName;
  String? matchMonth;
  String? matchTime;
  int? qxbLeagueId;
  int? qxbMatchId;
  int? status;
  String? statusName;

  MatchArray(
      {this.groupCn,
        this.guestId,
        this.guestLogo,
        this.guestName,
        this.guestScore90,
        this.guestScoreOt,
        this.guestScorePk,
        this.homeId,
        this.homeLogo,
        this.homeName,
        this.homeScore90,
        this.homeScoreOt,
        this.homeScorePk,
        this.isWin,
        this.leagueId,
        this.leagueName,
        this.matchMonth,
        this.matchTime,
        this.qxbLeagueId,
        this.qxbMatchId,
        this.status,
        this.statusName});

  MatchArray.fromJson(Map<String, dynamic> json) {
    groupCn = json['groupCn'];
    guestId = json['guestId'];
    guestLogo = json['guestLogo'];
    guestName = json['guestName'];
    guestScore90 = json['guestScore90'];
    guestScoreOt = json['guestScoreOt'];
    guestScorePk = json['guestScorePk'];
    homeId = json['homeId'];
    homeLogo = json['homeLogo'];
    homeName = json['homeName'];
    homeScore90 = json['homeScore90'];
    homeScoreOt = json['homeScoreOt'];
    homeScorePk = json['homeScorePk'];
    isWin = json['isWin'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    matchMonth = json['matchMonth'];
    matchTime = json['matchTime'];
    qxbLeagueId = json['qxbLeagueId'];
    qxbMatchId = json['qxbMatchId'];
    status = json['status'];
    statusName = json['statusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupCn'] = this.groupCn;
    data['guestId'] = this.guestId;
    data['guestLogo'] = this.guestLogo;
    data['guestName'] = this.guestName;
    data['guestScore90'] = this.guestScore90;
    data['guestScoreOt'] = this.guestScoreOt;
    data['guestScorePk'] = this.guestScorePk;
    data['homeId'] = this.homeId;
    data['homeLogo'] = this.homeLogo;
    data['homeName'] = this.homeName;
    data['homeScore90'] = this.homeScore90;
    data['homeScoreOt'] = this.homeScoreOt;
    data['homeScorePk'] = this.homeScorePk;
    data['isWin'] = this.isWin;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['matchMonth'] = this.matchMonth;
    data['matchTime'] = this.matchTime;
    data['qxbLeagueId'] = this.qxbLeagueId;
    data['qxbMatchId'] = this.qxbMatchId;
    data['status'] = this.status;
    data['statusName'] = this.statusName;
    return data;
  }
}

class TeamScheduleYearEntity {
  int? count;
  int? year;

  TeamScheduleYearEntity({this.count, this.year});

  TeamScheduleYearEntity.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    year = json['matchYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['matchYear'] = this.year;
    return data;
  }
}