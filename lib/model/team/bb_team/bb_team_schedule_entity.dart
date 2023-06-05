class BbTeamScheduleEntity {
  List<MatchGroup>? matchGroup;
  List<LeagueArray>? leagueArray;

  BbTeamScheduleEntity({this.matchGroup, this.leagueArray});

  BbTeamScheduleEntity.fromJson(Map<String, dynamic> json) {
    if (json['appTeamMatch'] != null) {
      matchGroup = <MatchGroup>[];
      json['appTeamMatch'].forEach((v) {
        matchGroup!.add(new MatchGroup.fromJson(v));
      });
    }
    if (json['categoryArr'] != null) {
      leagueArray = <LeagueArray>[];
      json['categoryArr'].forEach((v) {
        leagueArray!.add(new LeagueArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.matchGroup != null) {
      data['appTeamMatch'] = this.matchGroup!.map((v) => v.toJson()).toList();
    }
    if (this.leagueArray != null) {
      data['leagueArr'] = this.leagueArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MatchGroup {
  List<MatchArray>? matchArray;
  String? title;

  MatchGroup({this.matchArray, this.title});

  MatchGroup.fromJson(Map<String, dynamic> json) {
    if (json['appTeamMatchInfo'] != null) {
      matchArray = <MatchArray>[];
      json['appTeamMatchInfo'].forEach((v) {
        matchArray!.add(new MatchArray.fromJson(v));
      });
    }
    title = json['matchMonth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.matchArray != null) {
      data['appTeamMatchInfo'] =
          this.matchArray!.map((v) => v.toJson()).toList();
    }
    data['matchMonth'] = this.title;
    return data;
  }
}

class MatchArray {
  String? guestLogo;
  int? guestPoints;
  String? guestName;
  String? homeLogo;
  int? homePoints;
  String? homeName;
  int? leagueId;
  String? leagueName;
  String? matchId;
  String? matchMonth;
  int? matchResult;
  String? matchTime;
  String? matchYear;
  int? kind;
  String? kindName;
  int? national;
  int? statusId;

  MatchArray(
      {this.guestLogo,
        this.guestPoints,
        this.guestName,
        this.homeLogo,
        this.homePoints,
        this.homeName,
        this.leagueId,
        this.leagueName,
        this.matchId,
        this.matchMonth,
        this.matchResult,
        this.matchTime,
        this.matchYear,
        this.kind,
        this.kindName,
        this.national,
        this.statusId});

  MatchArray.fromJson(Map<String, dynamic> json) {
    guestLogo = json['awayLogo'];
    guestPoints = json['awayPoints'];
    guestName = json['awayTeamName'];
    homeLogo = json['homeLogo'];
    homePoints = json['homePoints'];
    homeName = json['homeTeamName'];
    leagueId = json['leagueId'];
    leagueName = json['leagueName'];
    matchId = json['matchId'];
    matchMonth = json['matchMonth'];
    matchResult = json['matchResult'];
    matchTime = json['matchTime'];
    matchYear = json['matchYear'];
    kind = json["kind"];
    kindName = json["kindName"];
    national = json["national"];
    statusId = json["statusId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['awayLogo'] = this.guestLogo;
    data['awayPoints'] = this.guestPoints;
    data['awayTeamName'] = this.guestName;
    data['homeLogo'] = this.homeLogo;
    data['homePoints'] = this.homePoints;
    data['homeTeamName'] = this.homeName;
    data['leagueId'] = this.leagueId;
    data['leagueName'] = this.leagueName;
    data['matchId'] = this.matchId;
    data['matchMonth'] = this.matchMonth;
    data['matchResult'] = this.matchResult;
    data['matchTime'] = this.matchTime;
    data['matchYear'] = this.matchYear;
    data['kind'] = this.kind;
    data['kindName'] = this.kindName;
    data["statusId"] = this.statusId;
    return data;
  }
}

class LeagueArray {
  int? leagueId;
  String? leagueName;

  LeagueArray({this.leagueId, this.leagueName});

  LeagueArray.fromJson(Map<String, dynamic> json) {
    leagueId = json['id'];
    leagueName = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.leagueId;
    data['name'] = this.leagueName;
    return data;
  }
}

class BbTeamScheduleYearEntity {
  String? year;

  BbTeamScheduleYearEntity({this.year});

  BbTeamScheduleYearEntity.fromJson(Map<String, dynamic> json) {
    year = json['matchYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchYear'] = this.year;
    return data;
  }
}